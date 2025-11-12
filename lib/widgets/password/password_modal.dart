import 'package:enciphered_app/services/enum_mapper.dart';
import 'package:enciphered_app/services/session_manager.dart';
import 'package:enciphered_app/services/string_extension.dart';
import 'package:enciphered_app/widgets/components/custom_text_field.dart';
import 'package:enciphered_app/widgets/enums/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:enciphered_app/models/password.dart';

class AddPasswordModal extends StatefulWidget {
  final PasswordModel? password;

  const AddPasswordModal({super.key, this.password});

  @override
  State<AddPasswordModal> createState() => _AddPasswordModalState();
}

class _AddPasswordModalState extends State<AddPasswordModal> {
  final _formKey = GlobalKey<FormState>();
  PlatformType _selectedPlatform = PlatformType.other;

  final _passwordController = TextEditingController();
  final _passwordEmailController = TextEditingController();
  final _passwordUrlController = TextEditingController();
  final _passwordDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.password != null) {
      _passwordUrlController.text = widget.password!.platformName;
      _passwordEmailController.text = widget.password!.email;
      _passwordDescriptionController.text =
          widget.password!.passwordDescription ?? '';
      _passwordController.text = widget.password!.decrypt();
      _selectedPlatform = widget.password!.platformType;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordEmailController.dispose();
    _passwordUrlController.dispose();
    _passwordDescriptionController.dispose();
    super.dispose();
  }

  void _savePassword() async {
    if (_formKey.currentState!.validate()) {
      final userId = await SessionManager.getCurrentUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: usuário não autenticado...'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salvando..."),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.password == null) {
        final newPassword = PasswordModel(
          email: _passwordEmailController.text.trim(),
          platformName: _passwordUrlController.text.trim(),
          platformPassword: _passwordController.text.trim(),
          passwordDescription: _passwordDescriptionController.text.trim(),
          userId: userId,
          platformType: _selectedPlatform,
        );
        Navigator.pop(context, newPassword);
      } else {
        widget.password!
          ..platformName = _passwordUrlController.text.trim()
          ..platformPassword = _passwordController.text.trim()
          ..email = _passwordEmailController.text.trim()
          ..passwordDescription = _passwordDescriptionController.text.trim()
          ..platformType = _selectedPlatform;
        Navigator.pop(context, widget.password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.password != null;
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Editar Senha' : 'Adicionar Senha',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          isEditing
                              ? Icons.edit_note_rounded
                              : Icons.add_circle,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          onPressed: Navigator.of(context).pop,
                          icon: Icon(
                            Icons.close,
                            color: Colors.redAccent,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<PlatformType>(
                  initialValue: _selectedPlatform,
                  decoration: InputDecoration(
                    prefixIcon: Icon(getPlatformIcon(_selectedPlatform)),
                    labelText: 'Tipo de Plataforma',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: PlatformType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(children: [Text(type.name.toCapitalized)]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedPlatform = value);
                    }
                  },
                ),
                const SizedBox(height: 14),

                CustomFormField(
                  controller: _passwordUrlController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Entre com a URL ou nome' : null,
                  fieldType: FieldType.platform,
                  label: 'Plataforma',
                ),
                const SizedBox(height: 14),

                CustomFormField(
                  controller: _passwordEmailController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Entre com o email' : null,
                  fieldType: FieldType.email,
                  label: 'Email',
                ),
                const SizedBox(height: 14),

                CustomFormField(
                  controller: _passwordController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Entre com a senha' : null,
                  fieldType: FieldType.password,
                  label: 'Senha',
                ),
                const SizedBox(height: 14),

                CustomFormField(
                  controller: _passwordDescriptionController,
                  fieldType: FieldType.description,
                  label: 'Descrição',
                ),
                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton.icon(
                    onPressed: _savePassword,
                    icon: const Icon(
                      Icons.save_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: Text(
                      isEditing ? 'Atualizar' : 'Salvar',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:enciphered_app/services/session_manager.dart';
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
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Salvando...")));

      if (widget.password == null) {
        final newPassword = PasswordModel(
          email: _passwordEmailController.text.trim(),
          platformName: _passwordUrlController.text.trim(),
          platformPassword: _passwordController.text.trim(),
          passwordDescription: _passwordDescriptionController.text.trim(),
          userId: userId,
        );
        Navigator.pop(context, newPassword);
      } else {
        widget.password!
          ..platformName = _passwordUrlController.text.trim()
          ..platformPassword = _passwordController.text.trim()
          ..email = _passwordEmailController.text.trim()
          ..passwordDescription = _passwordDescriptionController.text.trim();

        Navigator.pop(context, widget.password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.password == null ? 'Adicionar Senha' : 'Editar Senha'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'URL / Nome da Plataforma',
                  ),
                  controller: _passwordUrlController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Entre com a URL ou nome do site'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: _passwordEmailController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Entre com o email da senha'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  controller: _passwordDescriptionController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Entre com uma descrição'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Entre com a senha'
                      : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _savePassword,
                  child: const Text("Salvar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

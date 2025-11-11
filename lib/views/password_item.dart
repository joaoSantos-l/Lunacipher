import 'package:enciphered_app/models/password.dart';
import 'package:enciphered_app/services/database_helper.dart';
import 'package:enciphered_app/widgets/password/password_modal.dart';
import 'package:flutter/material.dart';

class Passworditem extends StatefulWidget {
  final PasswordModel password;
  final Function() deletePassword;

  const Passworditem({
    super.key,
    required this.password,
    required this.deletePassword,
  });

  @override
  State<Passworditem> createState() => _PassworditemState();
}

class _PassworditemState extends State<Passworditem> {
  // ignore: unused_field
  bool _isPasswordVisible = false;
  // ignore: unused_field
  late String _decryptedPassword;

  @override
  void initState() {
    super.initState();
    _decryptedPassword = widget.password.decrypt();
  }

  // ignore: unused_element
  void _copyPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Senha copiada para a área de trasnferência.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: const Icon(Icons.abc),
          title: Text(widget.password.platformName),
          subtitle: widget.password.passwordDescription!.isNotEmpty
              ? Text(widget.password.passwordDescription!)
              : null,
          tileColor: Theme.of(context).colorScheme.secondaryContainer,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  final updatedPassword = await showDialog<PasswordModel>(
                    context: context,
                    builder: (context) =>
                        AddPasswordModal(password: widget.password),
                  );

                  if (updatedPassword != null) {
                    await DatabaseHelper.instance.updatePassword(
                      updatedPassword,
                    );
                    setState(() {});
                  }
                },
              ),

              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Excluir Senha'),
                      content: const Text(
                        'Tem certeza que deseja excluir esta senha?',
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text('Excluir'),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    widget.deletePassword();
                  }
                },
              ),
            ],
          ),
          onTap: () {
            showDialog<PasswordModel>(
              context: context,
              builder: (context) => AddPasswordModal(password: widget.password),
            );
          },
        ),
      ),
    );
  }
}

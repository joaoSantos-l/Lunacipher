import 'package:enciphered_app/models/password.dart';
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
        ),
      ),
    );
  }
}

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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordEmailController =
      TextEditingController();
  final TextEditingController _passwordUrlController = TextEditingController();
  final TextEditingController _passwordDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  showAddPasswordDialog(int userId) {
    return DialogRoute(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Url senha'),
                      controller: _passwordUrlController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entre com a url do site';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      controller: _passwordEmailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entre com o email da senha';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Descrição senha'),
                      controller: _passwordDescriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entre com a descrição da senha';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Senha'),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entre com a senha';
                        }
                        return null;
                      },
                    ),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("salvando")),
                          );
                          if (widget.password == null) {
                            PasswordModel newPassword = PasswordModel(
                              email: _passwordEmailController.text,
                              platformName: _passwordUrlController.text,
                              platformPassword: _passwordController.text,
                              passwordDescription:
                                  _passwordDescriptionController.text,
                              userId: userId,
                            );
                            Navigator.pop(context, [newPassword]);
                          } else {
                            widget.password?.platformName =
                                _passwordUrlController.text;
                            widget.password?.platformPassword =
                                _passwordController.text;
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text("Salvar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

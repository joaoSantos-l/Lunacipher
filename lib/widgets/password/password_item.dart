import 'package:enciphered_app/models/password.dart';
import 'package:enciphered_app/services/database_helper.dart';
import 'package:enciphered_app/services/enum_mapper.dart';
import 'package:enciphered_app/widgets/enums/platform_type.dart';
import 'package:enciphered_app/widgets/password/password_details.dart';
import 'package:enciphered_app/widgets/password/password_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Passworditem extends StatefulWidget {
  final PasswordModel password;
  final Function() deletePassword;
  final int index;
  final int totalCount;

  const Passworditem({
    super.key,
    required this.password,
    required this.deletePassword,
    required this.index,
    required this.totalCount,
  });

  @override
  State<Passworditem> createState() => _PassworditemState();
}

class _PassworditemState extends State<Passworditem> {
  late String _decryptedPassword;

  @override
  void initState() {
    super.initState();
    _decryptedPassword = widget.password.decrypt();
  }

  void _copyPassword() {
    Clipboard.setData(ClipboardData(text: _decryptedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Senha copiada para a área de transferência.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry customBorderRadius;

    if (widget.index == 0 && widget.index == widget.totalCount - 1) {
      customBorderRadius = BorderRadius.circular(20);
    } else if (widget.index == 0) {
      customBorderRadius = const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      );
    } else if (widget.index == widget.totalCount - 1) {
      customBorderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      );
    } else {
      customBorderRadius = BorderRadius.zero;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: customBorderRadius,
        child: Material(
          child: ListTile(
            minTileHeight: 80,
            leading: widget.password.platformType == PlatformType.outros
                ? CircleAvatar(
                    backgroundColor: Colors.blueGrey.shade700,
                    child: Text(
                      widget.password.platformName[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : Icon(
                    getPlatformIcon(widget.password.platformType),
                    color: Colors.white70,
                  ),
            title: Text(
              widget.password.platformName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            tileColor: Theme.of(context).colorScheme.tertiaryContainer,
            subtitle: widget.password.passwordDescription != null
                ? Text(
                    widget.password.passwordDescription!,
                    style: const TextStyle(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy, size: 18, color: Colors.white54),
                  onPressed: _copyPassword,
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
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
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
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
                            child: const Text(
                              'Excluir',
                              style: TextStyle(color: Colors.white),
                            ),
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
                builder: (context) =>
                    PasswordDetailsModal(password: widget.password),
              );
            },
          ),
        ),
      ),
    );
  }
}

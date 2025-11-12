import 'package:enciphered_app/services/enum_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enciphered_app/models/password.dart';
import 'package:enciphered_app/services/string_extension.dart';
import 'package:enciphered_app/widgets/components/info_tile.dart';

class PasswordDetailsModal extends StatelessWidget {
  final PasswordModel password;

  const PasswordDetailsModal({super.key, required this.password});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copiado para a área de transferência'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decryptedPassword = password.decrypt();

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    password.platformName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                ),
                child: Row(
                  children: [
                    Icon(
                      getPlatformIcon(password.platformType),
                      size: 36,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      password.platformType.name.toCapitalized,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              InfoTile(
                label: 'Email',
                tileType: TileType.info,
                value: password.email,
                icon: Icons.email_rounded,
              ),
              const SizedBox(height: 14),

              InfoTile(
                label: 'Senha',
                tileType: TileType.password,
                value: decryptedPassword,
                icon: Icons.lock_rounded,
                onCopy: () => _copyToClipboard(context, decryptedPassword),
              ),
              const SizedBox(height: 14),

              if (password.passwordDescription != null &&
                  password.passwordDescription!.isNotEmpty)
                InfoTile(
                  label: 'Descrição',
                  tileType: TileType.info,
                  value: password.passwordDescription!,
                  icon: Icons.notes_rounded,
                  multiline: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

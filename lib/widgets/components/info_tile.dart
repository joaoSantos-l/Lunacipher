import 'package:flutter/material.dart';

enum TileType { password, info }

class InfoTile extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool multiline;
  final VoidCallback? onCopy;
  final TileType tileType;

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.multiline = false,
    this.onCopy,
    required this.tileType,
  });

  @override
  State<InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<InfoTile> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(3),
        ),
      ),
      child: Row(
        crossAxisAlignment: widget.multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(widget.icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.tileType == TileType.password && _obscure
                      ? '•' * widget.value.length
                      : widget.value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (widget.onCopy != null)
                IconButton(
                  icon: const Icon(Icons.copy_rounded),
                  color: theme.colorScheme.primary,
                  tooltip: 'Copiar',
                  onPressed: widget.onCopy,
                ),
              ?widget.tileType == TileType.password
                  ? IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    )
                  : null,
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum FieldType { username, email, password }

class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final FieldType fieldType;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.fieldType,
    required this.label,
    this.hint,
    this.validator,
    this.labelStyle,
    this.hintStyle,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscure = true;

  IconData _getPrefixIcon() {
    switch (widget.fieldType) {
      case FieldType.username:
        return Icons.person_outline;
      case FieldType.email:
        return Icons.email_outlined;
      case FieldType.password:
        return Icons.lock_outline;
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.fieldType) {
      case FieldType.username:
        return TextInputType.text;
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.password:
        return TextInputType.visiblePassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final normalColor = widget.labelStyle?.color ?? Colors.white70;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.fieldType == FieldType.password ? _obscure : false,
      validator: widget.validator,
      keyboardType: _getKeyboardType(),
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        prefixIcon: Icon(_getPrefixIcon(), color: Colors.white70),
        labelText: widget.label,
        hintText: widget.hint,
        hintStyle: widget.hintStyle,
        labelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return TextStyle(color: errorColor);
          }
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(color: Colors.white);
          }
          return TextStyle(color: normalColor);
        }),

        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return TextStyle(color: errorColor);
          }
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(color: Colors.white);
          }
          return TextStyle(color: normalColor);
        }),
        suffixIcon: widget.fieldType == FieldType.password
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}

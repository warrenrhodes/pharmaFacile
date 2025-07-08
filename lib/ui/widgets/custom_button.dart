import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool loading;
  final ShadButtonSize size;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.loading = false,
    this.size = ShadButtonSize.lg,
  });

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      onPressed: loading ? null : onPressed,
      size: size,
      child: loading ? const CircularProgressIndicator() : child,
    );
  }
}

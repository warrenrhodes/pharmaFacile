import 'package:flutter/widgets.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const GradientContainer({
    super.key,
    required this.child,
    required this.colors,
    this.borderRadius,
    this.boxShadow,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

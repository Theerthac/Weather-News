import 'package:flutter/material.dart';
import 'custom_apptext.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.width,
    this.height = 50.0,
    this.fontSize,
    this.textColor = Colors.white,
    this.isBg = true,
    this.boxColor = Colors.blue,
    this.borderColor = Colors.transparent,
    this.borderRadius = 8.0,
    this.shadow,
    this.weight,
    this.family,
    this.child,
    this.isLoading = false,
    this.icon, // New property for the icon
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final double? width, height, fontSize, borderRadius, iconSize;
  final Color textColor, boxColor, borderColor;
  final bool isBg;
  final Widget? child;
  final List<BoxShadow>? shadow;
  final FontWeight? weight;
  final String? family;
  final bool isLoading;
  final IconData? icon; // Icon to be displayed at the start
  final Color? iconColor; // Color for the icon

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap, // Disable tap when loading
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          boxShadow: shadow,
          color: isBg ? boxColor : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius!),
          border: Border.all(color: borderColor),
        ),
        child: isLoading
            ? SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, size: iconSize ?? 20.0, color: iconColor ?? textColor),
            if (icon != null) SizedBox(width: 8.0),
            child ??
                AppText(
                  text,
                  size: fontSize,
                  color: textColor,
                  weight: weight,
                ),
          ],
        ),
      ),
    );
  }
}

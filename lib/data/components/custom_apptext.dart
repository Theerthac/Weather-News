import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  const AppText(
      this.text, {
        super.key,
        this.color,
        this.height,
        this.size = 14,
        this.align,
        this.maxLines,
        this.family,
        this.weight,
        this.style,
        this.overflow,
        this.width,
        this.softWrap,
        this.decoration, 
        this.decorationColor, 
        this.decorationThickness, 
      });

  final dynamic text;
  final String? family;
  final Color? color;
  final double? height;
  final double? width;
  final double? size;
  final FontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
  final TextStyle? style;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;

  @override
  Widget build(BuildContext context) {
    return Text(
      text?.toString() ?? '',
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap ?? true,
      textAlign: align,
      style: (family != null)
          ? TextStyle(
        fontFamily: family,
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: height,
        decoration: decoration, 
        decorationColor: decorationColor, 
        decorationThickness: decorationThickness, 
      ).merge(style)
          : GoogleFonts.lato(
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: height,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
      ).merge(style),
    );
  }
}

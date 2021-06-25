import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign align;
  final String font;
  final TextOverflow overflow;

  const AppText(this.text,
      {Key key,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.align,
      this.font,
      this.overflow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          fontFamily: font),
      textAlign: align,
      overflow: overflow ?? TextOverflow.fade,
    );
  }
}

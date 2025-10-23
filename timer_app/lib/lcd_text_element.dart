import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LCDTextElement {
  final double left;
  final double top;
  final double width;
  final double height;
  final String showedText;
  final bool debug;
  final TextStyle? style;

  LCDTextElement({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.showedText,
    this.debug = false,
    this.style,
  });

  Widget build() {
    Widget debugWrap(Widget child) {
      if (!debug) return child;
      return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(80, 255, 255, 0),
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: child,
      );
    }

    TextStyle defaultStyle = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.w800,
      fontSize: 72,
      letterSpacing: -2,
      color: Colors.black,
    );

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: debugWrap(
        FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
          child: Text(
            showedText,
            textAlign: TextAlign.right,
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            strutStyle: const StrutStyle(
              forceStrutHeight: true,
              height: 1.0,
              leading: 0.0,
              fontSize: 100,
            ),
            style: style ?? defaultStyle,
          ),
        ),
      ),
    );
  }
}

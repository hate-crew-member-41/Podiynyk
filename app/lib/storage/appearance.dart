import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Appearance {
	static Color get mainColor => const HSVColor.fromAHSV(1, 0, 0, .1).toColor();
	static Color get accentColor => const HSVColor.fromAHSV(1, 0, 0, .2).toColor();
	static Color get contentColor => Colors.white;

	static TextStyle get contentText => GoogleFonts.montserrat(fontSize: 17, color: contentColor);
	static TextStyle get smallText => GoogleFonts.montserrat(fontSize: 13, color: contentColor);
	static TextStyle get titleText => GoogleFonts.montserrat(fontSize: 30, color: contentColor);
	static TextStyle get appBarText => GoogleFonts.montserrat(fontSize: 20, color: contentColor);

	static EdgeInsetsGeometry get padding => const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
}


extension StyledWidget on Widget {
	Widget get withPadding => Padding(
		padding: Appearance.padding,
		child: this
	);
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Appearance {
	static Color get backgroundColor => const HSVColor.fromAHSV(1, 0, 0, .1).toColor();
	static Color get secondaryBackgroundColor => const HSVColor.fromAHSV(1, 0, 0, .2).toColor();
	static Color get primaryColor => Colors.white;

	static TextStyle get bodyText => GoogleFonts.montserrat(fontSize: 16);
	static TextStyle get titleText => GoogleFonts.montserrat(fontSize: 17);
	static TextStyle get largeTitleText => GoogleFonts.montserrat(fontSize: 20);
	static TextStyle get headlineText => GoogleFonts.montserrat(fontSize: 30);
	static TextStyle get displayText => GoogleFonts.montserrat(fontSize: 40);
	static TextStyle get labelText => GoogleFonts.montserrat(fontSize: 14);

	static EdgeInsetsGeometry get padding => const EdgeInsets.all(16);
}


extension StyledWidget on Widget {
	Widget get withPadding => Padding(
		padding: Appearance.padding,
		child: this
	);
}

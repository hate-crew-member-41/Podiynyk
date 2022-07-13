import 'package:flutter/material.dart';


void openPage({
	required BuildContext context,
	required Widget Function(BuildContext, void Function()) builder
}) {
	final navigator = Navigator.of(context);
	navigator.push(MaterialPageRoute(
		builder: (context) => builder(context, navigator.pop)
	));
}

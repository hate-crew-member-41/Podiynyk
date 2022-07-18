import 'package:flutter/material.dart';


void openPage({
	required BuildContext context,
	required Widget Function(BuildContext, void Function() close) builder
}) {
	final navigator = Navigator.of(context);
	navigator.push(MaterialPageRoute(
		// think: do not pass the pop method
		builder: (context) => builder(context, navigator.pop)
	));
}

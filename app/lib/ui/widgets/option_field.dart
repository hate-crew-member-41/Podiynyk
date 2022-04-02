import 'package:flutter/material.dart';


class OptionField extends StatelessWidget {
	const OptionField({
		required this.controller,
		required this.name,
		required this.showOptions,
		this.style
	});

	final TextEditingController controller;
	final String name;
	final void Function(BuildContext)? showOptions;
	final TextStyle? style;

	@override
	Widget build(BuildContext context) {
		return showOptions != null ? GestureDetector(
			onTap: () => showOptions!(context),
			child: _builder(context),
		) : _builder(context);
	}

	Widget _builder(context) => TextField(
		controller: controller,
		enabled: false,
		style: style,
		decoration: InputDecoration(hintText: name)
	);
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class InputField extends HookWidget {
	const InputField({
		required this.controller,
		required this.name,
		this.enabled = true,
		this.multiline = false,
		this.style
	});

	final TextEditingController controller;
	final String name;
	final bool enabled;
	final bool multiline;
	final TextStyle? style;

	@override
	Widget build(BuildContext context) {
		final focusNode = useFocusNode();
		useListenable(focusNode);

		return TextField(
			controller: controller,
			focusNode: focusNode,
			enabled: enabled,
			maxLines: multiline ? null : 1,
			showCursor: false,
			style: style,
			decoration: InputDecoration(
				filled: focusNode.hasFocus,
				hintText: name,
			)
		);
	}
}

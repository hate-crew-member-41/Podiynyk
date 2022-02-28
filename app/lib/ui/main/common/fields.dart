import 'package:flutter/material.dart';


class InputField extends StatefulWidget {
	final TextEditingController controller;
	final String name;
	final void Function(String text)? onSubmitted;

	const InputField({
		required this.controller,
		required this.name,
		this.onSubmitted
	});

	@override
	_InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
	final _focusNode = FocusNode();

	@override
	void initState() {
		_focusNode.addListener(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return TextField(
			controller: widget.controller,
			focusNode: _focusNode,
			onSubmitted: widget.onSubmitted,
			showCursor: false,
			decoration: InputDecoration(
				border: InputBorder.none,
				contentPadding: const EdgeInsets.symmetric(horizontal: 16),
				fillColor: const HSVColor.fromAHSV(1, 0, 0, .2).toColor(),
				filled: _focusNode.hasFocus,
				hintText: widget.name,
				hintStyle: TextStyle(color: Colors.white.withOpacity(.5))
			)
		);
	}
}


class OptionField extends StatelessWidget {
	final TextEditingController controller;
	final String name;
	final void Function(BuildContext context) showOptions;

	const OptionField({
		required this.controller,
		required this.name,
		required this.showOptions
	});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			// todo: capture common functionality of [onTap] args
			onTap: () => showOptions(context),
			child: TextField(
				controller: controller,
				enabled: false,
				decoration: InputDecoration(
					border: InputBorder.none,
					contentPadding: const EdgeInsets.symmetric(horizontal: 16),
					hintText: name,
					hintStyle: TextStyle(color: Colors.white.withOpacity(.5))
				)
			),
		);
	}
}

import 'package:flutter/material.dart';

import 'package:podiynyk/ui/main/group_zone/home/sections/section.dart' show EntityDate;


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


// todo: make this private and create a more specific field from it for options lists?
class OptionField extends StatelessWidget {
	final TextEditingController controller;
	final String? name;
	final void Function(BuildContext context) showOptions;

	const OptionField({
		required this.controller,
		this.name,
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
					hintText: name ?? "",
					hintStyle: TextStyle(color: Colors.white.withOpacity(.5))
				)
			),
		);
	}
}


class DateField extends StatefulWidget {
	final DateTime? initialDate;
	final void Function(DateTime) onDatePicked;

	const DateField({
		this.initialDate,
		required this.onDatePicked
	});

	@override
	State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
	final _field = TextEditingController();
	DateTime? _date;

	@override
	void initState() {	
		super.initState();
		_date = widget.initialDate;
		_field.text = widget.initialDate?.fullRepr ?? "";
	}

	@override
	Widget build(BuildContext context) {
		return OptionField(
			controller: _field,
			name: "date",
			showOptions: _ask
		);
	}

	void _ask(BuildContext context) async {
		final now = DateTime.now();

		_date = await showDatePicker(
			context: context,
			initialDate: _date ?? now.add(const Duration(days: DateTime.daysPerWeek * 2)),
			firstDate: now,
			lastDate: now.add(const Duration(days: 365))
		);

		if (_date != null) {
			final time = await showTimePicker(
				context: context,
				initialTime: TimeOfDay.now().replacing(minute: 0)
			);
			_date = time != null ? _date!.withTime(time) : _date!.withDefaultTime;

			_field.text = _date!.fullRepr;
			widget.onDatePicked(_date!);
		}
	}
}

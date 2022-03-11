import 'package:flutter/material.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/entities/date.dart';


class InputField extends StatefulWidget {
	final TextEditingController controller;
	final String name;
	final bool enabled;
	final TextStyle style;

	const InputField({
		required this.controller,
		required this.name,
		this.enabled = true,
		required this.style
	});

	@override
	_InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
	final _focusNode = FocusNode();

	@override
	void initState() {
		super.initState();
		_focusNode.addListener(() => setState(() {}));
	}

	@override
	Widget build(BuildContext context) {
		return TextField(
			controller: widget.controller,
			focusNode: _focusNode,
			enabled: widget.enabled,
			showCursor: false,
			style: widget.style,
			decoration: InputDecoration(
				border: InputBorder.none,
				contentPadding: Appearance.padding,
				fillColor: Appearance.accentColor,
				filled: _focusNode.hasFocus,
				hintText: widget.name,
				hintStyle: widget.style.copyWith(color: widget.style.color?.withOpacity(.5))
			)
		);
	}
}


class OptionField extends StatelessWidget {
	final TextEditingController controller;
	final String? name;
	final void Function(BuildContext) showOptions;
	final TextStyle style;

	const OptionField({
		required this.controller,
		this.name,
		required this.showOptions,
		required this.style
	});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () => showOptions(context),
			child: TextField(
				controller: controller,
				enabled: false,
				style: style,
				decoration: InputDecoration(
					border: InputBorder.none,
					contentPadding: Appearance.padding,
					hintText: name ?? "",
					hintStyle: style.copyWith(color: style.color?.withOpacity(.5))
				)
			),
		);
	}
}


class DateField extends StatefulWidget {
	final DateTime? initialDate;
	final void Function(DateTime) onDatePicked;
	final bool enabled;
	final TextStyle style;

	const DateField({
		this.initialDate,
		required this.onDatePicked,
		this.enabled = true,
		required this.style
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
			showOptions: (context) {
				if (widget.enabled) _ask(context);
			},
			style: widget.style
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

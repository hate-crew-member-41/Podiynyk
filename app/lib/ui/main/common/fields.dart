import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/entities/date.dart';


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


class DateField extends HookWidget {
	const DateField({
		this.initialDate,
		required this.onDatePicked,
		this.enabled = true,
		this.style
	});

	final DateTime? initialDate;
	final void Function(DateTime) onDatePicked;
	final bool enabled;
	final TextStyle? style;

	@override
	Widget build(BuildContext context) {
		final field = useTextEditingController(text: initialDate?.fullRepr);
		final date = useRef(initialDate);

		return OptionField(
			controller: field,
			name: "date",
			showOptions: enabled ? (context) => _ask(context, date, field) : null,
			style: style
		);
	}

	void _ask(BuildContext context, ObjectRef<DateTime?> date, TextEditingController field) async {
		final now = DateTime.now();

		date.value = await showDatePicker(
			context: context,
			initialDate: date.value ?? now.add(const Duration(days: DateTime.daysPerWeek * 2)),
			firstDate: now,
			lastDate: now.add(const Duration(days: 365)),
			helpText: '',
			confirmText: "pick the time",
			cancelText: "cancel"
		);

		if (date.value != null) {
			final time = await showTimePicker(
				context: context,
				initialTime: TimeOfDay.now().replacing(minute: 0),
				helpText: '',
				confirmText: "ok",
				cancelText: "no time"
			);
			date.value = time != null ? date.value!.withTime(time) : date.value!.withDefaultTime;

			field.text = date.value!.fullRepr;
			onDatePicked(date.value!);
		}
	}
}

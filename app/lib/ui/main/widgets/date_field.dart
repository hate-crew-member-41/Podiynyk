import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/entities/date.dart';

import 'option_field.dart';


class DateField extends HookWidget {
	const DateField({
		this.initialDate,
		required this.onPicked,
		this.enabled = true,
		this.style
	});

	final DateTime? initialDate;
	final void Function(DateTime) onPicked;
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
			confirmText: "time",
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
			onPicked(date.value!);
		}
	}
}

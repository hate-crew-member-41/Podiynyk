import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiinyk/core/domain/types/date.dart';
import 'package:podiinyk/core/presentation/open_page.dart';


class DateField extends HookWidget {
	const DateField({required this.onPick});

	final void Function(Date) onPick;

	@override
	Widget build(BuildContext context) {
		final field = useTextEditingController();

		return GestureDetector(
			onTap: () => openPage(
				context: context,
				builder: (context, close) => _DatePage(field: field, onPick: onPick)
			),
			child: TextField(
				controller: field,
				enabled: false,
				decoration: const InputDecoration(labelText: 'date')
			)
		);
	}
}


// do: build a usable page
class _DatePage extends HookWidget {
	const _DatePage({
		required this.field,
		required this.onPick
	});

	final TextEditingController field;
	final void Function(Date) onPick;

	@override
	Widget build(BuildContext context) {
		final now = DateTime.now();
		final yearField = useTextEditingController(text: now.year.toString());
		final monthField = useTextEditingController(text: now.month.toString());
		final dayField = useTextEditingController(text: now.day.toString());
		final hourField = useTextEditingController(text: now.hour.toString());
		final minuteField = useTextEditingController(text: now.minute.toString());

		return GestureDetector(
			onDoubleTap: () {
				final date = Date(DateTime(
					int.parse(yearField.text),
					int.parse(monthField.text),
					int.parse(dayField.text),
					int.parse(hourField.text),
					int.parse(minuteField.text)
				));

				field.text = date.repr;
				Navigator.of(context).pop();
				onPick(date);
			},
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					TextField(controller: yearField),
					TextField(controller: monthField),
					TextField(controller: dayField),
					TextField(controller: hourField),
					TextField(controller: minuteField)
				]
			))
		);
	}
}

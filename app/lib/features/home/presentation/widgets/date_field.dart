import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiinyk/core/domain/types/date.dart';
import 'package:podiinyk/core/domain/types/formatted_int.dart';
import 'package:podiinyk/core/presentation/open_page.dart';


class DateField extends HookWidget {
	const DateField({required this.onPick});

	// think: replace with ObjectRef<Date>
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


// do: constrain the values
// do: provide default values
// do: make time optional
// do: show the name of the selected weekday and month when scrolling
class _DatePage extends HookWidget {
	const _DatePage({
		required this.field,
		required this.onPick
	});

	final TextEditingController field;
	// think: replace with ObjectRef<Date>
	final void Function(Date) onPick;

	@override
	Widget build(BuildContext context) {
		final day = useRef(1);
		final month = useRef(1);
		final hour = useRef(0);
		final minute = useRef(0);

		return GestureDetector(
			onDoubleTap: () {
				final date = Date(DateTime(2022, month.value, day.value, hour.value, minute.value));
				field.text = date.repr;
				Navigator.of(context).pop();
				onPick(date);
			},
			// do: take the values from the theme
			// think: remove the . and :
			// do: fix the baseline
			child: Scaffold(body: Row(children: [
				const Spacer(),
				_AttributeWheel(first: 1, last: 31, onChange: (d) => day.value = d),
				const Padding(
					padding: EdgeInsets.symmetric(horizontal: 16),
					child: Text('.')
				),
				_AttributeWheel(first: 1, last: 12, onChange: (m) => month.value = m),
				const Spacer(),
				_AttributeWheel(first: 0, last: 23, onChange: (h) => hour.value = h),
				const Padding(
					padding: EdgeInsets.symmetric(horizontal: 16),
					child: Text(':')
				),
				_AttributeWheel(first: 0, last: 59, onChange: (m) => minute.value = m),
				const Spacer()
			]))
		);
	}

	// @override
	// Widget build(BuildContext context) {
	// 	final now = DateTime.now();
	// 	final yearField = useTextEditingController(text: now.year.toString());
	// 	final monthField = useTextEditingController(text: now.month.toString());
	// 	final dayField = useTextEditingController(text: now.day.toString());
	// 	final hourField = useTextEditingController(text: now.hour.toString());
	// 	final minuteField = useTextEditingController(text: now.minute.toString());

	// 	return GestureDetector(
	// 		onDoubleTap: () {
	// 			final date = Date(DateTime(
	// 				int.parse(yearField.text),
	// 				int.parse(monthField.text),
	// 				int.parse(dayField.text),
	// 				int.parse(hourField.text),
	// 				int.parse(minuteField.text)
	// 			));

	// 			field.text = date.repr;
	// 			Navigator.of(context).pop();
	// 			onPick(date);
	// 		},
	// 		child: Scaffold(body: Column(
	// 			mainAxisAlignment: MainAxisAlignment.center,
	// 			children: [
	// 				TextField(controller: yearField),
	// 				TextField(controller: monthField),
	// 				TextField(controller: dayField),
	// 				TextField(controller: hourField),
	// 				TextField(controller: minuteField)
	// 			]
	// 		))
	// 	);
	// }
}


class _AttributeWheel extends HookWidget {
	const _AttributeWheel({
		required this.first,
		required this.last,
		required this.onChange
	});

	final int first;
	final int last;
	// think: replace with [ObjectRef<int> current]
	final void Function(int) onChange;

	@override
	Widget build(BuildContext context) {
		final current = useValueNotifier(first);
		final scrolling = useValueNotifier(false);

		return NotificationListener<UserScrollNotification>(
			onNotification: (notification) {
				scrolling.value = notification.direction != ScrollDirection.idle;
				return true;
			},
			// do: take the values from the theme
			// think: use ListWheelScrollView.useDelegate (AnimatedOpacity does not work with it)
			child: Flexible(child: ListWheelScrollView(
				physics: const FixedExtentScrollPhysics(),
				itemExtent: 56,
				diameterRatio: 16,
				onSelectedItemChanged: (index) => current.value = index + first,
				children: [
					for (int n = first; n <= last; n++) HookBuilder(builder: (context) {
						useValueListenable(current);
						useListenable(scrolling);

						return AnimatedOpacity(
							opacity: n == current.value ? 1 : (scrolling.value ? .5 : 0),
							duration: const Duration(milliseconds: 200),
							child: Text(n.twoDigitRepr)
						);
					})
				]
			))
		);
	}
}

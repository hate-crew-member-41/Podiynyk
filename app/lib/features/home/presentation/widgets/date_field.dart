import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiinyk/core/domain/types/date.dart';
import 'package:podiinyk/core/domain/types/formatted_int.dart';
import 'package:podiinyk/core/domain/types/date_time.dart';
import 'package:podiinyk/core/presentation/open_page.dart';


// think: use Riverpod for state management
class DateField extends HookWidget {
	const DateField({required this.onPick});

	// think: replace with ObjectRef<Date>
	final void Function(Date) onPick;

	@override
	Widget build(BuildContext context) {
		final field = useTextEditingController();
		final date = useRef(Date.now(hasTime: false));

		return GestureDetector(
			onTap: () => openPage(
				context: context,
				builder: (context) => _DatePage(
					initial: date.value,
					onPick: (d) {
						field.text = d.repr;
						date.value = d;
						onPick(d);
					}
				)
			),
			child: TextField(
				controller: field,
				enabled: false,
				decoration: const InputDecoration(labelText: 'date')
			)
		);
	}
}


// do: make time optional
// do: provide initial date
// do: show the name of the selected weekday and month when scrolling
class _DatePage extends HookWidget {
	const _DatePage({required this.initial, required this.onPick});

	final Date initial;
	// think: replace with ObjectRef<Date>
	final void Function(Date) onPick;
	static const minuteStep = 5;

	@override
	Widget build(BuildContext context) {
		final months = _months();
		final days = useValueNotifier(const <int>[]);
		final hours = useValueNotifier(const <int>[]);
		final minutes = useValueNotifier(const <int>[]);
		final timeIsIncluded = useValueNotifier(initial.hasTime);

		var monthObject = DateTime(initial.value.year, initial.value.month).latest(months.first);
		final date = useRef(_dateWithMonth(initial.value, monthObject, days, hours, minutes));

		return GestureDetector(
			onDoubleTap: () {
				Navigator.of(context).pop();
				onPick(Date(date.value, hasTime: timeIsIncluded.value));
			},
			// think: . and :
			child: Scaffold(body: Row(children: [
				const Spacer(),
				Flexible(child: HookBuilder(builder: (context) {
					useListenable(days);
					return _NumberWheel<int>(
						options: days.value,
						initial: date.value.day,
						optionRepr: (day) => day.twoDigitRepr,
						onPick: (day) => date.value = _dateWithDay(date.value, day, hours, minutes)
					);
				})),
				Flexible(child: _NumberWheel<DateTime>(
					options: months,
					optionRepr: (object) => object.month.twoDigitRepr,
					onPick: (month) => date.value = _dateWithMonth(date.value, month, days, hours, minutes)
				)),
				const Spacer(),
				Flexible(child: GestureDetector(
					onVerticalDragDown: (_) => timeIsIncluded.value = true,
					child: HookBuilder(builder: (context) {
						useListenable(hours);
						useListenable(timeIsIncluded);
						return Opacity(
							opacity: timeIsIncluded.value ? 1 : .5,
							child: _NumberWheel<int>(
								options: hours.value,
								initial: date.value.hour,
								optionRepr: (hour) => hour.twoDigitRepr,
								onPick: (hour) => date.value = _dateWithHour(date.value, hour, minutes)
							)
						);
					})
				)),
				Flexible(child: GestureDetector(
					onVerticalDragDown: (_) => timeIsIncluded.value = true,
					child: HookBuilder(builder: (context) {
						useListenable(minutes);
						useListenable(timeIsIncluded);
						return Opacity(
							opacity: timeIsIncluded.value ? 1 : .5,
							child: _NumberWheel<int>(
								options: minutes.value,
								initial: date.value.minute,
								optionRepr: (minute) => minute.twoDigitRepr,
								onPick: (minute) => date.value = date.value.copyWith(minute: minute)
							)
						);
					})
				)),
				const Spacer()
			]))
		);
	}

	DateTime _dateWithMonth(
		DateTime date,
		DateTime monthObject,
		ValueNotifier<List<int>> days,
		ValueNotifier<List<int>> hours,
		ValueNotifier<List<int>> minutes
	) {
		days.value = _days(monthObject);
		final day = date.day.clamp(days.value.first, days.value.last);
		final dateWithMonth = date.copyWith(year: monthObject.year, month: monthObject.month);
		return _dateWithDay(dateWithMonth, day, hours, minutes);
	}

	DateTime _dateWithDay(
		DateTime date,
		int day,
		ValueNotifier<List<int>> hours,
		ValueNotifier<List<int>> minutes
	) {
		hours.value = _hours(date.copyWith(day: day, hour: 0, minute: 0));
		final hour = max(date.hour, hours.value.first);
		return _dateWithHour(date.copyWith(day: day), hour, minutes);
	}

	DateTime _dateWithHour(DateTime date, int hour, ValueNotifier<List<int>> minutes) {
		final hourObject = date.copyWith(hour: hour, minute: 0);
		minutes.value = _minutes(hourObject);
		final minute = max(date.minute, minutes.value.first);
		return hourObject.copyWith(minute: minute);
	}

	List<DateTime> _months() {
		final now =  DateTime.now();

		final currentMonthIsEmpty = now.day == now.monthDayCount && _dayIsEmpty(now.hour, now.minute);
		final start = !currentMonthIsEmpty ? now.month : now.month + 1;
		return [
			for (int month = start; month <= 12; month++)
				DateTime(now.year, month),
			for (int month = 1; month < now.month; month++)
				DateTime(now.year + 1, month),
			if (now.day != 1)
				DateTime(now.year + 1, now.month)
		];
	}

	List<int> _days(DateTime monthObject) {
		final now = DateTime.now();
		final currentMonthObject = DateTime(now.year, now.month);
		final nextCurrentMonthObject = DateTime(now.year + 1, now.month);

		final start = monthObject != currentMonthObject ? 1 :
			(!_dayIsEmpty(now.hour, now.minute) ? now.day : now.day + 1);
		final end = monthObject != nextCurrentMonthObject ? monthObject.monthDayCount : now.day - 1;
		return [
			for (int day = start; day <= end; day++) day
		];
	}

	bool _dayIsEmpty(int hour, int minute) => hour == 23 && _hourIsEmpty(minute);

	List<int> _hours(DateTime dayObject) {
		final now = DateTime.now();
		final today = DateTime(now.year, now.month, now.day);

		final start = dayObject != today ? 0 : (!_hourIsEmpty(now.minute) ? now.hour : now.hour + 1);
		return [
			for (int hour = start; hour < 24; hour++) hour
		];
	}

	bool _hourIsEmpty(int minute) => minute >= 60 - minuteStep;

	List<int> _minutes(DateTime hourObject) {
		final now = DateTime.now();
		final currentHour = DateTime(now.year, now.month, now.day, now.hour);

		final start = hourObject != currentHour ? 0 : now.minute + minuteStep - now.minute % minuteStep;
		return [
			for (int minute = start; minute < 60; minute += minuteStep) minute
		];
	}
}


// do: hide unselected options when the wheel is still
class _NumberWheel<O> extends StatelessWidget {
	_NumberWheel({
		required this.options,
		O? initial,
		required this.optionRepr,
		required this.onPick
	}) :
		_initialIndex = initial != null ? options.indexOf(initial) : 0;

	final List<O> options;
	final String Function(O) optionRepr;
	// think: replace with ObjectRef<O>
	final void Function(O) onPick;
	final int _initialIndex;

	@override
	Widget build(BuildContext context) {
		// do: use a hook
		final wheel = FixedExtentScrollController(initialItem: _initialIndex);

		return NotificationListener<ScrollEndNotification>(
			onNotification: (notification) {
				onPick(options[wheel.selectedItem]);
				return true;
			},
			child: ListWheelScrollView(
				key: ValueKey(options),
				controller: wheel,
				physics: const FixedExtentScrollPhysics(),
				// do: take from the theme
				itemExtent: 56,
				diameterRatio: 1024,
				children: [
					for (final option in options) Text(optionRepr(option))
				]
			)
		);
	}
}

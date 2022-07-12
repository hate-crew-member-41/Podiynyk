import 'formatted_int.dart';


class Date implements Comparable {
	const Date(this.value, {this.hasTime = true});

	Date.now() :
		value = DateTime.now(),
		hasTime = true;

	final DateTime value;
	final bool hasTime;

	String get shortRepr => _dayRepr(implyToday: true);

	String get repr {
		final dayRepr = _dayRepr(includeWeekday: true);
		return hasTime ? '$dayRepr, $timeRepr' : dayRepr;
	}

	String _dayRepr({bool includeWeekday = false, bool implyToday = false}) {
		final day = DateTime(value.year, value.month, value.day);

		final now = DateTime.now();
		final today = DateTime(now.year, now.month, now.day);
		final tomorrow = DateTime(now.year, now.month, now.day + 1);
		final yesterday = DateTime(now.year, now.month, now.day - 1);

		if (day.isAfter(tomorrow) || day.isBefore(yesterday)) {
			return !includeWeekday ? dateRepr : '$weekdayRepr $dateRepr';
		}

		if (day == tomorrow) return 'tomorrow';

		if (day == today) {
			return !implyToday || !hasTime ? 'today' : timeRepr;
		}

		return 'yesterday';
	}

	String get dateRepr => '${value.day.twoDigitRepr}.${value.month.twoDigitRepr}';

	String get timeRepr => '${value.hour.twoDigitRepr}:${value.minute.twoDigitRepr}';

	String get weekdayRepr {
		switch (value.weekday) {
			case 1: return 'Monday';
			case 2: return 'Tuesday';
			case 3: return 'Wednesday';
			case 4: return 'Thursday';
			case 5: return 'Friday';
			case 6: return 'Saturday';
			default: return 'Sunday';
		}
	}

	@override
	int compareTo(covariant Date other) => value.compareTo(other.value);
}

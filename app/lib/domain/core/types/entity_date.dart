import 'formatted_integer.dart';


class EntityDate {
	const EntityDate(this.object, {this.hasTime = true});

	EntityDate.now() :
		object = DateTime.now(),
		hasTime = true;

	final DateTime object;
	final bool hasTime;

	String get shortRepr => _dayRepr(implyToday: true);

	String get repr {
		final dayRepr = _dayRepr(includeWeekday: true);
		return hasTime ? '$dayRepr, $timeRepr' : dayRepr;
	}

	String _dayRepr({bool includeWeekday = false, bool implyToday = false}) {
		final now = DateTime.now();
		final today = DateTime(now.year, now.month, now.day);
		final tomorrow = DateTime(now.year, now.month, now.day + 1);
		final yesterday = DateTime(now.year, now.month, now.day - 1);

		if (object.isAfter(tomorrow) || object.isBefore(yesterday)) {
			return !includeWeekday ? dateRepr : '$weekdayRepr $dateRepr';
		}

		if (object == tomorrow) return 'tomorrow';

		if (object == today) {
			return !implyToday | !hasTime ? 'today' : timeRepr;
		}

		return 'yesterday';
	}

	String get dateRepr => '${object.day.twoDigitRepr}.${object.month.twoDigitRepr}';

	String get timeRepr => '${object.hour.twoDigitRepr}:${object.minute.twoDigitRepr}';

	String get weekdayRepr {
		switch (object.weekday) {
			case 1: return 'Monday';
			case 2: return 'Tuesday';
			case 3: return 'Wednesday';
			case 4: return 'Thursday';
			case 5: return 'Friday';
			case 6: return 'Saturday';
			default: return 'Sunday';
		}
	}
}

import 'package:flutter/material.dart';


extension EntityDate on DateTime {
	/// The representation of the date with 2 digits for each part.
	/// If the date is in a future year, it is also included.
	String get dateRepr {
		String repr = '${day.twoDigitRepr}.${month.twoDigitRepr}';
		if (year != DateTime.now().year) repr = '$repr.${year.twoDigitRepr}';
		return repr;
	}

	/// The representation with the weekday and the time if it was specified.
	String get fullRepr {
		late String repr;
		switch (weekday) {
			case 1: repr = 'Monday'; break;
			case 2: repr = 'Tuesday'; break;
			case 3: repr = 'Wednesday'; break;
			case 4: repr = 'Thursday'; break;
			case 5: repr = 'Friday'; break;
			case 6: repr = 'Saturday'; break;
			case 7: repr = 'Sunday'; break;
		}

		repr = '$repr $dateRepr';
		if (this != withDefaultTime) repr = '$repr, ${hour.twoDigitRepr}:${minute.twoDigitRepr}';

		return repr;
	}

	/// The date with [time]'s time parameters.
	DateTime withTime(TimeOfDay time) => DateTime(year, month, day, time.hour, time.minute);

	/// The last moment of the date.
	DateTime get withDefaultTime => DateTime(year, month, day).add(const Duration(hours: 24) - const Duration(seconds: 1));

	/// Whether the date is before now.
	bool get isPast => isBefore(DateTime.now());
}

extension on int {
	/// The 2-digit [String] representation. May start with '0'.
	String get twoDigitRepr => toString().padLeft(2, '0');
}

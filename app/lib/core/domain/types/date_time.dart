extension DateTimeExtension on DateTime {
	int get monthDayCount {
		switch (month) {
			case DateTime.september: return 30;
			case DateTime.october: return 31;
			case DateTime.november: return 30;

			case DateTime.december: return 31;
			case DateTime.january: return 31;
			case DateTime.february: 
				final yearIsLeap = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
				return !yearIsLeap ? 28 : 29;

			case DateTime.march: return 31;
			case DateTime.april: return 30;
			case DateTime.may: return 31;

			case DateTime.june: return 30;
			case DateTime.july: return 31;
			default: return 31;
		}
	}

	DateTime latest(DateTime other) => other.isAfter(this) ? other : this;

	DateTime copyWith({
		int? year,
		int? month,
		int? day,
		int? hour,
		int? minute
	}) => DateTime(
		year ?? this.year,
		month ?? this.month,
		day ?? this.day,
		hour ?? this.hour,
		minute ?? this.minute
	);
}

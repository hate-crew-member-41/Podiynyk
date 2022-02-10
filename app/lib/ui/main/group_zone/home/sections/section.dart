import 'package:flutter/material.dart';


extension on int {
	/// The 2-digit [String] representation. If less than 10, a leading zero is added.
	String get twoDigitRepr => toString().padLeft(2, '0');
}

extension EntityDate on DateTime {
	/// The representation of the date with 2 digits for each part.
	/// If the date is in a future year, it is also included.
	String get dateRepr {
		String repr = '${day.twoDigitRepr}.${month.twoDigitRepr}';
		if (year != DateTime.now().year) repr = '$repr.${year.twoDigitRepr}';
		return repr;
	}

	/// The representation with the weekday, and the time unless it is midnight.
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
		if (hour != 0 || minute != 0) repr = '$repr, ${hour.twoDigitRepr}:${minute.twoDigitRepr}';

		return repr;
	}
}


abstract class Section extends StatelessWidget {
	const Section();

	/// The static [name].
	String get sectionName;
	/// The static [icon].
	IconData get sectionIcon;

	Widget? get actionButton => null;
}


abstract class CloudSectionData {
	Future<List<dynamic>> get counted;
	Future<int> get count => counted.then((counted) => counted.length);
}

// todo: rename to CloudListSection if the the common build behavior is captured
// idea: consider an AnimatedOpacity animation with a different delay for each tile
abstract class CloudSection<D extends CloudSectionData> extends Section {
	final D data;

	const CloudSection(this.data);
}


class NewEntityButton extends StatelessWidget {
	final Widget Function(BuildContext) pageBuilder;

	const NewEntityButton({required this.pageBuilder});

	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: pageBuilder))
		);
	}
}

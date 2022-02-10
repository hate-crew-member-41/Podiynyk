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

	/// The representation with the weekday and the time.
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
		if (_hasTime) repr = '$repr, ${hour.twoDigitRepr}:${minute.twoDigitRepr}';

		return repr;
	}

	/// The [EntityDate] with [time]'s time parameters.
	DateTime withTime(TimeOfDay time) => DateTime(year, month, day, time.hour, time.minute, 1);

	/// Whether the [EntityDate] is past.
	bool get isPast {
		if (_hasTime) return isBefore(DateTime.now());
		return day < DateTime.now().day;
	}

	bool get _hasTime => !(hour == 0 && minute == 0 && second == 0);
}


abstract class Section extends StatelessWidget {
	const Section();

	/// The static [name].
	String get sectionName;
	/// The static [icon].
	IconData get sectionIcon;

	Widget? get actionButton => null;
}


abstract class CloudEntitiesSectionData<E> {
	Future<List<E>> get counted;
	Future<int> get count => counted.then((counted) => counted.length);
}

// todo: rename to CloudListSection if the the common build behavior is captured
// idea: consider an AnimatedOpacity animation with a different delay for each tile
abstract class CloudEntitiesSection<D extends CloudEntitiesSectionData<E>, E> extends Section {
	final D data;

	const CloudEntitiesSection(this.data);

	// todo: is it always equal to this.counted?
	Future<List<E>> get entities;

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<E>>(
			future: entities,
			builder: (context, snapshot) {
				// todo: what is shown while awaiting
				if (snapshot.connectionState == ConnectionState.waiting) return Center(child: Icon(sectionIcon));
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				return ListView(
					children: tiles(context, snapshot.data!)
				);
			}
		);
	}

	List<Widget> tiles(BuildContext context, List<E> entities);
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

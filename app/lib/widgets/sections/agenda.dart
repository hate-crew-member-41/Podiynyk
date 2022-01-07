import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Event;

import 'section.dart';


class AgendaData with ChangeNotifier {
	List<String>? subjectNames;

	Future<void> fetchSubjectNames() async {
		subjectNames = await Cloud.subjectNames();
		notifyListeners();
	}
}


class AgendaSection extends ExtendableListSection<Event> {
	@override
	final name = "agenda";
	@override
	final icon = Icons.remove_red_eye;

	const AgendaSection();

	@override
	Future<List<Event>> get entities => Cloud.events();

	@override
	ListTile tile(Event event) => ListTile(
		title: Text(event.name),
		subtitle: event.subject != null ? Text(event.subject!) : null,
		trailing: Text(event.date.dateRepr)
	);

	@override
	Widget floatingActionButton(BuildContext context) => ChangeNotifierProvider<AgendaData>(
		create: (_) => AgendaData()..fetchSubjectNames(),
		builder: (context, _) => AddEventButton(onTap: showNewEntityPage)
	);

	@override
	Widget get newEntityPage => NewEventPage();
}


class AddEventButton extends StatefulWidget {
	final void Function(BuildContext context) onTap;

	const AddEventButton({required this.onTap});

	@override
	_AddEventButtonState createState() => _AddEventButtonState();
}

class _AddEventButtonState extends State<AddEventButton> {
	@override
	Widget build(BuildContext context) {
		final isVisible = context.watch<AgendaData>().subjectNames != null;

		return AnimatedOpacity(
			opacity: isVisible ? 1 : 0,
			duration: const Duration(milliseconds: 200),
			child: Visibility(
				visible: isVisible,
				child: FloatingActionButton(
					child: const Icon(Icons.add),
					onPressed: () => widget.onTap(context)
				)
			)
		);
	}
}


class NewEventPage extends StatefulWidget {
	late final bool _askSubject;
	late final bool _subjectRequired;
	late final String? _subject;

	final _nameField = TextEditingController();
	final _subjectField = TextEditingController();
	final _dateField = TextEditingController();
	final _noteField = TextEditingController();

	NewEventPage() {
		_askSubject = true;
		_subjectRequired = false;
		_subject = null;
	}

	NewEventPage.subjectEvent(String subject) {
		_askSubject = false;
		_subjectRequired = true;
		_subject = subject;
	}

	NewEventPage.noSubjectEvent() {
		_askSubject = false;
		_subjectRequired = false;
		_subject = null;
	}

	@override
	State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
	String? _subjectName;
	DateTime? _date;

	@override
	void initState() {
		_subjectName = widget._subject;
		super.initState();
	}

	@override
	Widget build(BuildContext context) => NewEntityPage(
		addEntity: _add,
		children: [
			TextField(
				controller: widget._nameField,
				decoration: const InputDecoration(hintText: "name")
			),
			if (widget._askSubject) GestureDetector(  // TextField.onTap is not called if the field is disabled
				onTap: () => _askSubject(context),
				child: TextField(
					controller: widget._subjectField,
					enabled: false,
					decoration: const InputDecoration(hintText: "subject")
				),
			),
			GestureDetector(
				onTap: () => _askDate(context),
				child: TextField(
					controller: widget._dateField,
					enabled: false,
					decoration: const InputDecoration(hintText: "date")
				)
			),
			TextField(
				controller: widget._noteField,
				decoration: const InputDecoration(hintText: "note")
			)
		]
	);


	void _askSubject(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					// tofix: the context does not have the Provider<AgendaSection>
					children: [for (final name in context.read<AgendaData>().subjectNames!) ListTile(
						title: Text(name),
						onTap: () {
							_subjectName = name;
							widget._subjectField.text = name;
							Navigator.of(context).pop();
						}
					)]
				))
			)
		));
	}

	void _askDate(BuildContext context) async {
		final now = DateTime.now();
		_date = await showDatePicker(
			context: context,
			initialDate: _date ?? now.add(const Duration(days: 7)),
			firstDate: now,
			lastDate: now.add(const Duration(days: 365 * 4 + 1))
		);
		if (_date != null) {
			await _askTime(context);
			widget._dateField.text = _date!.forEvent();
		}
	}

	Future<void> _askTime(BuildContext context) async {
		final time = await showTimePicker(
			context: context,
			initialTime: const TimeOfDay(hour: 8, minute: 30)
		);
		if (time != null) {
			_date = DateTime(_date!.year, _date!.month, _date!.day, time.hour, time.minute);
		}
	}

	void _add(BuildContext context) {
		final name = widget._nameField.text, note = widget._noteField.text;
		if (widget._askSubject) {
			final inputSubject = widget._subjectField.text;
			_subjectName = inputSubject.isNotEmpty ? inputSubject : null;
		}
		if (
			name.isEmpty ||
			(widget._subjectRequired && _subjectName == null) ||
			_date == null
		) return;

		// these ideas apply to all new-entity pages
		// todo: show an animation of the event flying away?
		// todo: show the result of the request on the page?
		Navigator.of(context).pop();

		Cloud.addEvent(
			name: name,
			subject: _subjectName,
			date: _date!,
			note: note.isNotEmpty ? note : null
		);
	}
}

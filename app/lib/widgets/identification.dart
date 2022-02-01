import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/local.dart' show Local;
import 'package:podiynyk/storage/entities/county.dart';
import 'package:podiynyk/storage/entities/department.dart';
import 'package:podiynyk/storage/entities/identification_option.dart';
import 'package:podiynyk/storage/entities/university.dart';


class Identification extends StatefulWidget {
	static const _intro = "This text is a placeholder, so here comes Loreeeeem... "
		"Lorem ipsum dolor, sit amet consectetur adipisicing elit. Cumque, architecto.";
	final void Function() after;

	const Identification({required this.after});

	@override
	State<Identification> createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
	late Widget _content;

	_IdentificationState() {
		_content = GestureDetector(
			onDoubleTap: () => setState(() {
				_content = IdentificationForm(after: widget.after);
			}),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: const [
						Text('Hi'),
						Text(Identification._intro)
					]
				)
			)
		);
	}

	@override
	Widget build(BuildContext context) {
		return _content;
	}
}


class IdentificationForm extends StatefulWidget {
	final void Function() after;
	const IdentificationForm({required this.after});

	@override
	State<IdentificationForm> createState() => _IdentificationFormState();
}

class _IdentificationFormState extends State<IdentificationForm> {
	final _universityField = TextEditingController();
	final _departmentField = TextEditingController();
	final _groupField = TextEditingController();
	final _nameField = TextEditingController();

	University? _university;
	late Department _department;

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: _enterGroup,
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						GestureDetector(
							onTap: _showCountyOptions,
							child: TextField(
								controller: _universityField,
								enabled: false,
								decoration: const InputDecoration(hintText: "university")
							),
						),
						GestureDetector(
							onTap: () => _university != null ? _showDepartmentOptions() : _showCountyOptions(),
							child: TextField(
								controller: _departmentField,
								enabled: false,
								decoration: const InputDecoration(hintText: "department")
							)
						),
						TextField(
							controller: _groupField,
							decoration: const InputDecoration(hintText: "group"),
						),
						TextField(
							controller: _nameField,
							decoration: const InputDecoration(hintText: "name"),
						)
					]
				)
			)
		);
	}

	// todo: call asap after the build
	Future<bool?> _showCountyOptions() => _showOptions(
		context: context,
		title: "county",
		options: Cloud.counties(),
		builder: _countiesBuilder
	);

	Widget _countiesBuilder(
		BuildContext context,
		AsyncSnapshot<List<County>> snapshot
	) => _optionsBuilder<County>(
		context: context,
		snapshot: snapshot,
		onTap: (county) async {
			final navigator = Navigator.of(context);

			final universityChosen = await _showOptions(
				context: context,
				title: "university",
				options: county.universities,
				builder: _universitiesBuilder
			);

			if (universityChosen == true) navigator.pop();
		}
	);

	Widget _universitiesBuilder(
		BuildContext context,
		AsyncSnapshot<List<University>> snapshot
	) => _optionsBuilder<University>(
		context: context,
		snapshot: snapshot,
		onTap: (university) async {
			_university = university;
			final departmentChosen = await _showDepartmentOptions();

			if (departmentChosen == true) {
				_universityField.text = university.name;
				Navigator.of(context).pop(true);
			}
		}
	);

	Future<bool?> _showDepartmentOptions() => _showOptions(
		context: context,
		title: "department",
		options: _university!.departments,
		builder: _departmentsBuilder
	);

	Widget _departmentsBuilder(
		BuildContext context,
		AsyncSnapshot<List<Department>> snapshot
	) => _optionsBuilder<Department>(
		context: context,
		snapshot: snapshot,
		onTap: (department) {
			_department = department;
			_departmentField.text = department.name;
			Navigator.of(context).pop(true);
		}
	);

	Future<bool?> _showOptions<O extends IdentificationOption>({
		required BuildContext context,
		required String title,
		required Future<List<O>> options,
		required Widget Function(BuildContext, AsyncSnapshot<List<O>>) builder
	}) => Navigator.of(context).push<bool>(MaterialPageRoute(
		builder: (_) => Scaffold(
			appBar: AppBar(
				title: Text(title),
				automaticallyImplyLeading: false
			),
			body: FutureBuilder(
				future: options,
				builder: builder
			)
		)
	));

	Widget _optionsBuilder<O extends IdentificationOption>({
		required BuildContext context,
		required AsyncSnapshot<List<O>> snapshot,
		required void Function(O) onTap
	}) {
		if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(Icons.cloud_download));

		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: [
			for (final option in snapshot.data!) ListTile(
				title: Text(option.name),
				onTap: () => onTap(option)
			)
		]);
	}

	void _enterGroup() {
		if (_departmentField.text.isEmpty || _groupField.text.isEmpty || _nameField.text.isEmpty) return;

		final groupName = _groupField.text.toLowerCase().replaceAll('-', ' ').replaceAll(' ', '');
		final groupId = '${_university!.id}.${_department.id}.$groupName';
		Local.groupId = groupId;
		Local.name = _nameField.text;
		
		Cloud.addStudent().whenComplete(widget.after);
	}
}

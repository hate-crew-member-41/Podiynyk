import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';

import 'package:podiynyk/storage/entities/identification_options/department.dart';
import 'package:podiynyk/storage/entities/identification_options/county.dart';
import 'package:podiynyk/storage/entities/identification_options/identification_option.dart';
import 'package:podiynyk/storage/entities/identification_options/university.dart';

import 'common/fields.dart';


class Identification extends StatefulWidget {
	const Identification();

	@override
	State<Identification> createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
	static const _intro = "This text is an intro placeholder. The only reason this is explained in such detail "
		"is that some number of words is needed here.";

	bool _showIntro = true;

	@override
	Widget build(BuildContext context) {
		return _showIntro ? GestureDetector(
			onDoubleTap: () => setState(() {
				_showIntro = false;
			}),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Hi', style: Theme.of(context).textTheme.headlineMedium).withPadding,
						const Text(_intro).withPadding
					]
				)
			)
		) : const IdentificationForm();
	}
}


class IdentificationForm extends StatefulWidget {
	const IdentificationForm();

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
			onDoubleTap: () => _enterGroup(context),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						OptionField(
							controller: _universityField,
							name: "university",
							showOptions: _showCountyOptions,
							// style: Appearance.contentText
						),
						OptionField(
							controller: _departmentField,
							name: "department",
							showOptions: (context) => _university != null ?
								_showDepartmentOptions(context) :
								_showCountyOptions(context),
								// style: Appearance.contentText
						),
						InputField(
							controller: _groupField,
							name: "group",
							// style: Appearance.contentText
						),
						InputField(
							controller: _nameField,
							name: "name",
							// style: Appearance.contentText
						)
					]
				)
			)
		);
	}

	Future<bool?> _showCountyOptions(BuildContext context) => _showOptions(
		context: context,
		title: "county",
		options: Cloud.counties,
		builder: _countiesBuilder
	);

	Widget _countiesBuilder(
		BuildContext context,
		AsyncSnapshot<List<County>> snapshot
	) => _optionsBuilder<County>(
		context: context,
		snapshot: snapshot,
		onTap: (county) async {
			final universityChosen = await _showOptions(
				context: context,
				title: "university",
				options: county.universities,
				builder: _universitiesBuilder
			);

			if (universityChosen == true) Navigator.of(context).pop();
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
			final departmentChosen = await _showDepartmentOptions(context);

			if (departmentChosen == true) {
				_universityField.text = university.name;
				Navigator.of(context).pop(true);
			}
		}
	);

	Future<bool?> _showDepartmentOptions(BuildContext context) => _showOptions(
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

	void _enterGroup(BuildContext context) {
		if (_departmentField.text.isEmpty || _groupField.text.isEmpty || _nameField.text.isEmpty) return;

		final groupName = _groupField.text.toLowerCase().replaceAll('-', '').replaceAll(' ', '');
		final groupId = '${_university!.id}:${_department.id}:$groupName'.safeId;

		Local.groupId = groupId;
		Local.name = _nameField.text;
		Local.id = Local.name.safeId;

		Cloud.enterGroup().whenComplete(context.read<void Function()>());
	}
}

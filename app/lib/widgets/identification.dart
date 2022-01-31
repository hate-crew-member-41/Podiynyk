import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/county.dart';
import 'package:podiynyk/storage/entities/department.dart';
import 'package:podiynyk/storage/entities/university.dart';


class Identification extends StatefulWidget {
	static const _intro = "This text is a placeholder, so here comes Loreeeeem... "
		"Lorem ipsum dolor, sit amet consectetur adipisicing elit. Cumque, architecto.";

	@override
	State<Identification> createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
	late Widget _content;

	_IdentificationState() {
		_content = GestureDetector(
			onDoubleTap: () => setState(() {
				_content = IdentificationForm();
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
	@override
	State<IdentificationForm> createState() => _IdentificationFormState();
}

class _IdentificationFormState extends State<IdentificationForm> {
	final _universityField = TextEditingController();
	final _departmentField = TextEditingController();
	final _groupField = TextEditingController();
	final _nameField = TextEditingController();

	late University _university;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					GestureDetector(
						onTap: () => Navigator.of(context).push(MaterialPageRoute(
							builder: (_) => Scaffold(
								appBar: AppBar(title: const Text("county")),
								body: FutureBuilder(
									future: Cloud.counties(),
									builder: _countiesBuilder
								)
							)
						)),
						child: TextField(
							controller: _universityField,
							enabled: false
						)
					),
					GestureDetector(
						onTap: () => Navigator.of(context).push(MaterialPageRoute(
							builder: (_) => Scaffold(
								appBar: AppBar(title: const Text("department")),
								body: FutureBuilder(
									future: _university.departments,
									builder: _departmentsBuilder
								)
							)
						)),
						child: TextField(
							controller: _departmentField,
							enabled: false
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
		);
	}

	Widget _countiesBuilder(BuildContext context, AsyncSnapshot<List<County>> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(Icons.cloud_download));

		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: [
			for (final county in snapshot.data!) ListTile(
				title: Text(county.name),
				onTap: () async {
					final navigator = Navigator.of(context);

					final universityChosen = await navigator.push<bool>(MaterialPageRoute(
						builder: (_) => Scaffold(
							appBar: AppBar(title: const Text("university")),
							body: FutureBuilder(
								future: county.universities,
								builder: _universitiesBuilder
							)
						)
					));

					if (universityChosen == true) navigator.pop();
				}
			)
		]);
	}

	Widget _universitiesBuilder(BuildContext context, AsyncSnapshot<List<University>> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(Icons.cloud_download));

		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: [
			for (final university in snapshot.data!) ListTile(
				title: Text(university.name),
				onTap: () async {
					final navigator = Navigator.of(context);

					final departmentChosen = await navigator.push<bool>(MaterialPageRoute(
						builder: (_) => Scaffold(
							appBar: AppBar(title: const Text("department")),
							body: FutureBuilder(
								future: university.departments,
								builder: _departmentsBuilder
							)
						)
					));

					if (departmentChosen == true) {
						_university = university;
						_universityField.text = university.name;
						navigator.pop(true);
					}
				}
			)
		]);
	}

	Widget _departmentsBuilder(BuildContext context, AsyncSnapshot<List<Department>> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(Icons.cloud_download));

		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: [
			for (final department in snapshot.data!) ListTile(
				title: Text(department.name),
				onTap: () {
					_departmentField.text = department.name;
					Navigator.of(context).pop(true);
				}
			)
		]);
	}
}


// class DepartmentOptions extends StatefulWidget {
// 	const DepartmentOptions();

// 	@override
// 	DepartmentOptionsState createState() => DepartmentOptionsState();
// }

// class DepartmentOptionsState extends State<DepartmentOptions> {
// 	String _title = "county";
// 	late Future<List<dynamic>> _options;
// 	late Widget Function(BuildContext, AsyncSnapshot<List<dynamic>>) _optionsBuilder;

// 	@override
// 	void initState() {
// 		_options = Cloud.counties();
// 		_optionsBuilder = _countiesBuilder;
// 		super.initState();
// 	}

// 	@override
// 	Widget build(BuildContext context) {
// 		return Scaffold(
// 			appBar: AppBar(title: AnimatedSwitcher(
// 				duration: const Duration(milliseconds: 200),
// 				child: Text(_title)
// 			)),
// 			body: FutureBuilder(
// 				future: _options,
// 				builder: _optionsBuilder
// 			)
// 		);
// 	}

// 	Widget _countiesBuilder(BuildContext context, AsyncSnapshot<List<County>> snapshot) {
// 		if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(Icons.cloud_download));

// 		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

// 		return ListView(children: [
// 			for (final county in snapshot.data!) ListTile(
// 				title: Text(county.name),
// 				onTap: () => setState(() {
// 					_title = "university";
// 					_options = county.universities;
// 					_optionsBuilder = _universitiesBuilder
// 				})
// 			)
// 		]);
// 	}

// 	Widget _universitiesBuilder(BuildContext context, AsyncSnapshot<List<University>> snapshot) {
// 		if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(Icons.cloud_download));

// 		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

// 		return ListView(children: [
// 			for (final university in snapshot.data!) ListTile(
// 				title: Text(university.name),
// 				onTap: () => setState(() {
// 					_title = "department";
// 					_options = university.departments;
// 					_optionsBuilder = _departmentsBuilder
// 				})
// 			)
// 		]);
// 	}

// 	Widget _departmentsBuilder(BuildContext context, AsyncSnapshot<List<Department>> snapshot) {
// 		if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(Icons.cloud_download));

// 		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

// 		return ListView(children: [
// 			for (final university in snapshot.data!) ListTile(
// 				title: Text(university.name),
// 				onTap: () => Navigator.of(context).pop(),
// 			)
// 		]);
// 	}
// }

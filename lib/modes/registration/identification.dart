import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_similarity/string_similarity.dart' show StringExtensions;

import '../../main.dart';
import '../../database/database.dart';
import '../../database/models/user.dart';
import '../../database/models/group.dart';


class IdentificationModel with ChangeNotifier {
	late Widget _page;
	Widget get page => _page;
	set page(Widget page) {
		_page = page;
		notifyListeners();
	}

	IdentificationModel(edus) {
		page = EDUForm(edus); // todo: consider the provided info
	}
}

class Identification extends StatelessWidget {  // tofin
	final Map<String, String> _edus;
	Identification(this._edus);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Padding(
				padding: EdgeInsets.symmetric(horizontal: 20.0),
				child: Stack(
					fit: StackFit.expand,
					children: [
						Align(
							alignment: Alignment(-1.0, -0.6),
							child: Text("Ідентифікація")
						),
						ChangeNotifierProvider<IdentificationModel>(
							create: (_) => IdentificationModel(_edus),
							child: Consumer<IdentificationModel>(
								builder: (_, registration, __) => AnimatedSwitcher(
									duration: Duration(milliseconds: 400),
									child: registration.page
								)
							)
						)
					]
				)
			)
		);
	}
}


class EDUForm extends StatefulWidget {
	final TextEditingController _controller = TextEditingController();
	final List<String> _edus;
	EDUForm(this._edus);

	@override
	_EDUFormState createState() => _EDUFormState(_edus);

	static String pureEDU(String name) =>
		name.toLowerCase().replaceAll('"', '').replaceAll('.', '').replaceAll('ім', '').replaceAll('імені', '');
}

class _EDUFormState extends State<EDUForm> {
  final List<String> _edus;
	late List<String> _pureEDUs;
	_EDUFormState(this._edus) {
		_pureEDUs = _edus.map(EDUForm.pureEDU).toList();
	}

	bool _provided = false;

	@override
	Widget build(BuildContext context) {
		return Column(  // todo: move this part from all ...Form widgets to a single StatelessWidget
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.end,
			children: [
				TextField(
					decoration: InputDecoration(
						icon: Icon(Icons.business),
						labelText: "ВНЗ"
					),
					controller: widget._controller,
					onSubmitted: (edu) {
						setState(() { _provided = edu.isNotEmpty; });
						if (!_provided) return;

						String pureEDU = EDUForm.pureEDU(edu);
						int meantEDUIndex = pureEDU.bestMatch(_pureEDUs).bestMatchIndex;
						String meantEDU = widget._edus[meantEDUIndex];

						context.read<Group>().edu = meantEDU;
						widget._controller.text = meantEDU;
					},
					onTap: () {
						setState(() { _provided = false; });
					},
				),
				AnimatedOpacity(
					opacity: _provided ? 1.0 : 0.0,
					duration: Duration(milliseconds: 400),
					child: TextButton(
						onPressed: () {
							if (_provided) context.read<IdentificationModel>().page = DepartmentForm(widget._controller.text);
						},
						child: Text("далі")
					)
				)
			]
		);
	}
}


class DepartmentForm extends StatefulWidget {
	final TextEditingController _controller = TextEditingController();
	final String _edu;
	DepartmentForm(this._edu);

	@override
	_DepartmentFormState createState() => _DepartmentFormState();

	static String pureDepartment(String name) => name.toUpperCase().replaceAll('"', '');
}

class _DepartmentFormState extends State<DepartmentForm> {
	late List<String> _departments;
	late List<String> _pureDepartments;
	bool _provided = false;

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<Map<String, dynamic>>(  // todo: rewrite how the data is used | CUC
			future: context.read<Database>().departments(widget._edu),
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) return Text("підрозділи летять із хмари");
				
				if (snapshot.hasData) {
					context.read<Group>().id.eduId = snapshot.data!['id'];
					_departments = snapshot.data!['departments'].cast<String>();
					_pureDepartments = _departments.map(DepartmentForm.pureDepartment).toList();

					return Column(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.end,
						children: [
							TextField(
								decoration: InputDecoration(
									icon: Icon(Icons.device_hub),
									labelText: "підрозділ"
								),
								controller: widget._controller,
								onSubmitted: (department) {
									if (department.isEmpty) return;

									String pureDepartment = DepartmentForm.pureDepartment(department);
									int meantDepartmentIndex = pureDepartment.bestMatch(_pureDepartments).bestMatchIndex;
									String meantDepartment = _departments[meantDepartmentIndex];

									Group group = context.read<Group>();
									group.department = meantDepartment;
									group.id.departmentId = meantDepartmentIndex.toString();
									widget._controller.text = meantDepartment;
								},
								// onTap: () {  // tofix: setState rebuilds FutureBuilder
								// 	setState(() { _provided = false; });
								// },
							),
							AnimatedOpacity(
								// opacity: _provided ? 1.0 : 0.0,
                opacity: 1.0,
								duration: Duration(milliseconds: 400),
								child: TextButton(
									onPressed: () {
										// if (_provided) context.read<RegistrationModel>().page = GroupNameForm();
                    context.read<IdentificationModel>().page = GroupNameForm();
									},
									child: Text("далі")
								)
							)
						]
					);
				}

				return Text("error: ${snapshot.error}");
			},
		);
	}
}


class GroupNameForm extends StatefulWidget {
	@override
	_GroupNameFormState createState() => _GroupNameFormState();
}

class _GroupNameFormState extends State<GroupNameForm> {
	bool _provided = false;

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.end,
			children: [
				TextField(
					decoration: InputDecoration(
						icon: Icon(Icons.people),
						labelText: "група"
					),
					onSubmitted: (groupName) {
						setState(() { _provided = groupName.isNotEmpty; });
						if (_provided) context.read<Group>().name = groupName;
					},
					onTap: () {
						setState(() { _provided = false; });
					},
				),
				AnimatedOpacity(
					opacity: _provided ? 1.0 : 0.0,
					duration: Duration(milliseconds: 400),
					child: TextButton(
						onPressed: () {
							if (_provided) context.read<IdentificationModel>().page = NameForm();
						},
						child: Text("далі")
					)
				)
			]
		);
	}
}


class NameForm extends StatefulWidget {
	@override
	_NameFormState createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
	bool _provided = false;

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.end,
			children: [
				TextField(
					decoration: InputDecoration(
						icon: Icon(Icons.person),
						labelText: "ім'я"
					),
					onSubmitted: (name) {
						setState(() { _provided = name.isNotEmpty; });
						if (_provided) context.read<User>().name = name;
					},
					onTap: () {
						setState(() { _provided = false; });
					},
				),
				AnimatedOpacity(
					opacity: _provided ? 1.0 : 0.0,
					duration: Duration(milliseconds: 400),
					child: TextButton(
						onPressed: () {
							if (_provided) {
								Group group = context.read<Group>();
								AppModel app = context.read<AppModel>();

								group.endIdentification().then((_) {
									app.endIdentification();
								});
							}
						},
						child: Text('далі')
					)
				)
			]
		);
	}
}

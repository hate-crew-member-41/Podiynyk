// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:string_similarity/string_similarity.dart' show StringExtensions;
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../main.dart' show AppModel;
// import '../database/database.dart';
// import '../database/models/user.dart';
// import '../database/models/group.dart' show Group, GroupId;


// class RegistrationModel with ChangeNotifier {
// 	late Database _database;
// 	late Group _group;

// 	late dynamic _page;
// 	dynamic get page => _page;
// 	set page(dynamic page) {
// 		_page = page;
// 		notifyListeners();
// 	}

// 	final List<String> edus;

// 	late List<String> _pureEDUs;
// 	List<String> get pureEDUs => _pureEDUs;

// 	List<String>? _departments;
// 	List<String>? get departments => _departments;

// 	late List<String> _pureDepartments;
// 	List<String> get pureDepartments => _pureDepartments;

// 	Future<void> considerEDU() async {
// 		DocumentSnapshot<Map<String, dynamic>> eduDocument = await _database.edu(_edu!);
// 		_group.id.eduId = eduDocument['id'];
// 		_departments = eduDocument['departments'].cast<String>();
// 		_pureDepartments = _departments!.map(RegistrationModel.purify).toList();
// 		notifyListeners();
// 	}

// 	String? _edu;
// 	String? get edu => _edu;
// 	set edu(String? edu) {
// 		_edu = edu;
// 		considerEDU();
// 	}

// 	String? _department;
// 	String? get department => _department;
// 	set department(String? department) {
// 		_department = department;
// 		notifyListeners();
// 	}

// 	bool _groupNameFilled = false;
// 	bool get groupNameFilled => _groupNameFilled;
// 	set groupNameFilled(bool groupNameFilled) {
// 		_groupNameFilled = groupNameFilled;
// 		notifyListeners();
// 	}

// 	bool _nameFilled = false;
// 	bool get nameFilled => _nameFilled;
// 	set nameFilled(bool nameFilled) {
// 		_nameFilled = nameFilled;
// 		notifyListeners();
// 	}

// 	RegistrationModel(BuildContext context, this.edus) {
// 		_database = context.read<Database>();
// 		_group = context.read<Group>();

// 		if (_group.id.isEmpty) _page = RegistrationIntro();
// 		else {
// 			_page = RegistrationForm();

// 			// _page.eduField.text = _group.id.edu ?? "";
// 			// _page.departmentField.text = _group.id.department ?? "";
// 			// _page.groupNameField.text = _group.id.name ?? "";
// 			// _page.nameField.text = context.read<User>().name ?? "";

// 			// _eduFilled = _page.eduField.text.isNotEmpty;
// 			// _departmentFilled = _page.departmentField.text.isNotEmpty;
// 			// _groupNameFilled = _page.groupNameField.text.isNotEmpty;
// 			// _nameFilled = _page.nameField.text.isNotEmpty;
// 		}

// 		_pureEDUs = edus.map(purify).toList();
// 	}
// 	// bool _eduFilled = false;
// 	// bool get eduFilled => _eduFilled;
// 	// set eduFilled(bool eduFilled) {
// 	// 	_eduFilled = eduFilled;
// 	// 	notifyListeners();
// 	// }

// 	// bool _departmentFilled = false;
// 	// bool get departmentFilled => _departmentFilled;
// 	// set departmentFilled(bool departmentFilled) {
// 	// 	_departmentFilled = departmentFilled;
// 	// 	notifyListeners();
// 	// }

// 	bool get fieldsFilled => _eduFilled && _departmentFilled && _groupNameFilled && _nameFilled;
	
// 	static String purify(String string) {
// 		return string.toLowerCase().replaceAll(' ', '').replaceAll('"', '').replaceAll('-', '');
// 	}
// }


// class Registration extends StatelessWidget {
// 	final List<String> _edus;
// 	Registration(this._edus);

// 	@override
// 	Widget build(BuildContext context) {
// 		return ChangeNotifierProvider<RegistrationModel>(
// 			create: (context) => RegistrationModel(context, _edus),
// 			builder: (context, _) => GestureDetector(
// 				child: Scaffold(
// 					body: Padding(
// 					  	padding: const EdgeInsets.symmetric(horizontal: 20.0),
// 					  	child: Column(
// 					  		mainAxisAlignment: MainAxisAlignment.center,
// 					  		crossAxisAlignment: CrossAxisAlignment.start,
// 					  		children: [
// 					  			Text('Ідентифікація'),
// 					  			AnimatedSwitcher(
// 					  				duration: Duration(milliseconds: 400),
// 					  				child: Selector<RegistrationModel, dynamic>(
// 										selector: (_, registration) => registration.page,
// 					  					builder: (_, page, __) => page
// 					  				)
// 					  			)
// 					  		]
// 					  	),
// 					)
// 				),
// 				onTap: () {
// 					RegistrationModel registration = context.read<RegistrationModel>();

// 					if (registration.page is RegistrationIntro) registration.page = RegistrationForm();
// 					else if (registration.fieldsFilled) {
// 						// These fields are only read now because it is possible to fill them in w/o calling their
// 						// onSubmitted method. This does not let the app consider the provided values. This is the case
// 						// when the user leaves a field by selecting a different one instead of pressing the appropriate
// 						// button on the keyboard.
// 						context.read<Group>().id.name = RegistrationModel.purify(registration.page.groupNameField.text);
// 						context.read<User>().name = registration.page.nameField.text;
// 						context.read<AppModel>().endRegistration();
// 					}
// 				}
// 			)
// 		);
// 	}
// }


// class RegistrationIntro extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		return Column(
// 			children: [
// 				Text(  // todo: consider animating with animated_text_kit package
// 						'Привіт.\n\n'
// 						'Я створив цей застосунок з надією допомогти вашій групі слідкувати за реченцями.\n\n'
// 						'Можливо, не тільки реченцями. Можливо, не тільки слідкувати.\n\n'
// 						"Але після того, як ми з'ясуємо, де ти навчаєшся)\n\n"
// 						"*клік*"
// 					),
// 			],
// 		);
// 	}
// }


// class RegistrationForm extends StatelessWidget {
// 	final TextEditingController eduField = TextEditingController(), departmentField = TextEditingController(),
// 		groupNameField = TextEditingController(), nameField = TextEditingController();

// 	@override
// 	Widget build(BuildContext context) {
// 		return Column(
// 			children: [
// 				TextField(
// 					decoration: InputDecoration(
// 						icon: Icon(Icons.business),
// 						labelText: 'ВНЗ'
// 					),
// 					controller: eduField,
// 					onSubmitted: (edu) {  // todo
// 						// Group group = context.read<Group>();

// 						// RegistrationModel registration = context.read<RegistrationModel>();
// 						// registration.eduFilled = edu.isNotEmpty;


// 						// if (edu.isNotEmpty) {
// 						// 	String pureEDU = RegistrationModel.purify(edu);
// 						// 	int meantEDUIndex = pureEDU.bestMatch(registration.pureEDUs).bestMatchIndex;
// 						// 	String meantEDU = registration.edus[meantEDUIndex];
// 						// 	bool eduIsDifferent = meantEDU != eduField.text;

// 						// 	context.read<Group>().id.edu = meantEDU;
// 						// 	eduField.text = meantEDU;
// 						// }

// 						// // departmentField.clear();
// 						// // registration.departmentFilled = false;
// 					},
// 				),
// 				Selector<RegistrationModel, String?>(
// 					selector: (_, registration) => registration.edu,
// 					builder: (context, edu, __) => AnimatedOpacity(
// 						opacity: edu == null ? 0.0 : 1.0,
// 						duration: Duration(milliseconds: 400),
// 						child: edu == null ? Container() : TextField(
// 							decoration: InputDecoration(
// 								icon: Icon(Icons.device_hub),
// 								labelText: "підрозділ"
// 							),
// 							controller: departmentField,
// 							onSubmitted: (department) {
// 								RegistrationModel registration = context.read<RegistrationModel>();
// 								Group group = context.read<Group>();

// 								String pureDepartment = RegistrationModel.purify(department);
// 								int meantDepartmentIndex = pureDepartment.bestMatch(registration.pureDepartments).bestMatchIndex;
// 								String meantDepartment = registration.departments![meantDepartmentIndex];

// 								departmentField.text = meantDepartment;
// 								registration.department = meantDepartment;

// 								group.id.department = meantDepartment;
// 								group.id.departmentId = meantDepartmentIndex;
// 							}
// 						)
// 					)
// 				),
// 				// Selector<RegistrationModel, bool>(
// 				// 	selector: (_, registration) => registration.eduFilled,
// 				// 	builder: (context, eduFilled, __) => AnimatedOpacity(
// 				// 		opacity: eduFilled ? 1.0 : 0.0,
// 				// 		duration: Duration(milliseconds: 400),
// 				// 		child: !eduFilled ? Container() : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
// 				// 			future: context.read<Database>().edu(eduField.text),
// 				// 			builder: (context, snapshot) {
// 				// 				if (snapshot.connectionState == ConnectionState.waiting) return Text("підрозділи летять із хмари");

// 				// 				if (snapshot.hasData) {
// 				// 					Group group = context.read<Group>();
// 				// 					group.id.eduId = snapshot.data!['id'];

// 				// 					RegistrationModel registration = context.read<RegistrationModel>();
// 				// 					registration.departments = snapshot.data!['departments'].cast<String>();
// 				// 					registration.pureDepartments = registration.departments.map(RegistrationModel.purify).toList();

// 				// 					return TextField(
// 				// 						decoration: InputDecoration(
// 				// 							icon: Icon(Icons.device_hub),
// 				// 							labelText: "підрозділ"
// 				// 						),
// 				// 						controller: departmentField,
// 				// 						onSubmitted: (department) {
// 				// 							if (department.isEmpty) {
// 				// 								registration.departmentFilled = false;
// 				// 								return;
// 				// 							}

// 				// 							String pureDepartment = RegistrationModel.purify(department);
// 				// 							int bestMatchIndex = pureDepartment.bestMatch(registration.pureDepartments).bestMatchIndex;
// 				// 							String bestMatch = registration.departments[bestMatchIndex];

// 				// 							group.id.department = bestMatch;
// 				// 							group.id.departmentId = bestMatchIndex;
// 				// 							departmentField.text = bestMatch;
// 				// 							registration.departmentFilled = true;
// 				// 						}
// 				// 					);
// 				// 				}

// 				// 				return Text("підрозділи загубилися :(");
// 				// 			}
// 				// 		)
// 				// 	)
// 				// ),
// 				Selector<RegistrationModel, String?>(
// 					selector: (_, registration) => registration.department,
// 					builder: (context, department, __) => AnimatedOpacity(
// 						opacity: department == null ? 0.0 : 1.0,
// 						duration: Duration(milliseconds: 400),
// 						child: department == null ? Container() : TextField(
// 							decoration: InputDecoration(
// 								icon: Icon(Icons.people),
// 								labelText: "група"
// 							),
// 							controller: groupNameField,
// 							onSubmitted: (groupName) {
// 								context.read<RegistrationModel>().groupNameFilled = groupName.isNotEmpty;
// 							}
// 						)
// 					)
// 				),
// 				Selector<RegistrationModel, bool>(
// 					selector: (_, registration) => registration.groupNameFilled,
// 					builder: (_, groupNameProvided, __) => AnimatedOpacity(
// 						opacity: groupNameProvided ? 1.0 : 0.0,
// 						duration: Duration(milliseconds: 400),
// 						child: !groupNameProvided ? Container() : TextField(
// 							decoration: InputDecoration(
// 								icon: Icon(Icons.person),
// 								labelText: "ім'я"
// 							),
// 							controller: nameField,
// 							onSubmitted: (name) {
// 								context.read<RegistrationModel>().nameFilled = name.isNotEmpty;
// 							}
// 						)
// 					)
// 				),
// 				Selector<RegistrationModel, bool>(
// 					selector: (_, registration) => registration.fieldsFilled,
// 					builder: (_, nameFilled, __) => AnimatedOpacity(
// 						opacity: nameFilled ? 1.0 : 0.0,
// 						duration: Duration(milliseconds: 400),
// 						child: Text("*клік*"),
// 					)
// 				)
// 			]
// 		);
// 	}
// }

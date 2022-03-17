import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';

import 'common/fields.dart' show InputField;


class Identification extends StatefulWidget {
	const Identification();

	@override
	State<Identification> createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
	bool? _userIsFirst;

	@override
	Widget build(BuildContext context) {
		if (_userIsFirst == null) return _Introduction(
			showNextPage: (userIsFirst) => setState(() => _userIsFirst = userIsFirst)
		);

		return _userIsFirst! ? _IdGeneration() : _IdForm();
	}
}


class _Introduction extends StatelessWidget {
	final void Function(bool userIsFirst) showNextPage;

	const _Introduction({required this.showNextPage});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onLongPress: () => showNextPage(true),
			onDoubleTap: () => showNextPage(false),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Hi', style: Appearance.headlineText).withPadding,
						const Text(
							"If you have the group id, tap twice. Otherwise, tap and hold.\n\n"
							"By the way, whenever you are looking for a button to go forward, just tap twice."
						).withPadding
					]
				)
			)
		);
	}
}


class _IdGeneration extends StatelessWidget {
	final _nameField = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () => _handleName(context),
			child: Scaffold(
				body: FutureBuilder(
					future: Cloud.initGroup(),
					builder: _builder
				)
			)
		);
	}

	Widget _builder(BuildContext context, AsyncSnapshot<String> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting) {
			return const Center(child: Text('generating a new id'));
		}
		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		final id = snapshot.data!;
		Clipboard.setData(ClipboardData(text: id));

		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				SelectableText(
					id,
					style: Appearance.largeTitleText.copyWith(letterSpacing: 3),
				).withPadding,
				const Text(
					"Share this id with your groupmates. It is already on the clipboard.\n\n"
					"They should be here in a moment. While they are making their way...",
					textAlign: TextAlign.start
				).withPadding,
				InputField(
					controller: _nameField,
					name: "your name",
					canGrow: false
				)
			]
		);
	}

	void _handleName(BuildContext context) {
		final name = _nameField.text;
		if (name.isEmpty) return;

		Local.userName = name;
		Cloud.enterGroup();
		context.read<void Function()>()();
	}
}


class _IdForm extends StatelessWidget {
	final _idField = TextEditingController();
	final _nameField = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () => _handleId(context),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						InputField(
							controller: _idField,
							name: "group id",
							canGrow: false
						),
						InputField(
							controller: _nameField,
							name: "your name",
							canGrow: false
						)
					]
				)
			)
		);
	}

	Future<void> _handleId(BuildContext context) async {
		final id = _idField.text;
		final name = _nameField.text;
		if (id.isEmpty || name.isEmpty) return;

		Local.userName = name;
		final exists = await Cloud.groupExists(id);

		if (exists) {
			Local.groupId = id;
			Cloud.enterGroup();
			context.read<void Function()>()();
		}
		else {
			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
				duration: Duration(seconds: 2),
				content: Text("This id does not exist.")
			));
			_idField.clear();
		}
	}
}

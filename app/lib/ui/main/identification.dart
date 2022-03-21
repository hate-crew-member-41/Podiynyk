import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';

import 'common/fields.dart' show InputField;


class Identification extends HookWidget {
	const Identification();

	@override
	Widget build(BuildContext context) {
		final userIsFirst = useState<bool?>(null);

		switch (userIsFirst.value) {
			case true:
				return _IdGeneration();
			case false:
				return _IdForm();
			default:
				return _Introduction(
					showNextPage: (isFirst) => userIsFirst.value = isFirst
				);
		}
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
						Text('Hi', style: Appearance.headlineText).withPadding(),
						const Text(
							"If you have the group id, tap twice. Otherwise, tap and hold.\n\n"
							"By the way, whenever you are looking for a button to go forward, just tap twice."
						).withPadding()
					]
				)
			)
		);
	}
}


class _IdGeneration extends HookWidget {
	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController();

		return GestureDetector(
			onDoubleTap: () => _handleName(context, nameField),
			child: Scaffold(
				body: FutureBuilder<String>(
					future: Cloud.initGroup(),
					builder: (context, snapshot) => _builder(context, snapshot, nameField)
				)
			)
		);
	}

	Widget _builder(BuildContext context, AsyncSnapshot<String> snapshot, TextEditingController nameField) {
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
				).withPadding(),
				const Text(
					"Share this id with your groupmates. It is already on the clipboard.\n\n"
					"They should be here in a moment. While they are making their way, how will they recognize you?",
					textAlign: TextAlign.start
				).withPadding(),
				InputField(
					controller: nameField,
					name: "your name",
				)
			]
		);
	}

	Future<void> _handleName(BuildContext context, TextEditingController nameField) async {
		final name = nameField.text;
		if (name.isEmpty) return;

		Local.userName = name;
		await Cloud.enterGroup();
		context.read<void Function()>()();
	}
}


class _IdForm extends HookWidget {
	@override
	Widget build(BuildContext context) {
		final idField = useTextEditingController();
		final nameField = useTextEditingController();

		return GestureDetector(
			onDoubleTap: () => _handleForm(context, idField, nameField.text),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						InputField(
							controller: idField,
							name: "group id"
						),
						InputField(
							controller: nameField,
							name: "your name"
						)
					]
				)
			)
		);
	}

	Future<void> _handleForm(BuildContext context, TextEditingController idField, String name) async {
		final id = idField.text;
		if (id.isEmpty || name.isEmpty) return;

		Local.userName = name;
		final exists = await Cloud.groupExists(id);

		if (exists) {
			Local.groupId = id;
			await Cloud.enterGroup();
			context.read<void Function()>()();
		}
		else {
			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
				duration: Duration(seconds: 2),
				content: Text("This id does not exist.")
			));
			idField.clear();
		}
	}
}

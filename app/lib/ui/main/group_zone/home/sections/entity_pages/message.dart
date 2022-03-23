import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/message.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import '../section.dart' show CloudEntitiesSectionData;
import 'entity.dart';


class MessagePage extends HookWidget {
	const MessagePage(this.message);

	final Message message;

	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController(text: message.name);
		final contentField = useTextEditingController();

		final hasDetails = useState(message.hasDetails);

		useEffect(() {
			message.addDetails().whenComplete(() {
				hasDetails.value = message.hasDetails;
				contentField.text = message.content;
			});

			return () {
				if (nameField.text != message.name) message.name = nameField.text;
				if (contentField.text != message.content) message.content = contentField.text;
			};
		}, const []);

		final isAuthor = message.author.name == Local.userName;

		return EntityPage(
			children: [
				InputField(
					controller: nameField,
					name: "topic",
					enabled: isAuthor,
					style: Appearance.headlineText
				),
				if (message.hasDetails) InputField(
					controller: contentField,
					name: "content",
					enabled: isAuthor,
					multiline: true,
					style: Appearance.bodyText
				),
				const ListTile(),
				Text(
					message.author.nameRepr,
					style: Appearance.titleText
				).withPadding(),
				Text(
					message.date.fullRepr,
					style: Appearance.titleText
				).withPadding()
			],
			actions: [
				if (isAuthor) EntityActionButton(
					text: "delete",
					action: () => _delete(context)
				)
			]
		);
	}

	Future<void> _delete(BuildContext context) async {
		message.delete();
		Navigator.of(context).pop();
	}
}

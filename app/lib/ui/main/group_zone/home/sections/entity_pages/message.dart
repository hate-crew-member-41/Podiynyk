import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/message.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class MessagePage extends HookConsumerWidget {
	MessagePage(this.initialMessage) :
		isByUser = initialMessage.author.id == Local.userId;

	final Message initialMessage;
	final bool isByUser;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final message = useState(initialMessage);
		final nameField = useTextEditingController(text: initialMessage.nameRepr);
		final contentField = useTextEditingController(text: initialMessage.content);

		useEffect(() {
			initialMessage.withDetails.then((withDetails) {
				message.value = withDetails;
				contentField.text = withDetails.content!;
			});

			return null;
		}, const []);

		return EntityPage(
			children: [
				InputField(
					controller: nameField,
					name: "topic",
					enabled: isByUser,
					style: Appearance.headlineText
				),
				if (message.value.hasDetails) InputField(
					controller: contentField,
					name: "content",
					enabled: isByUser,
					multiline: true,
					style: Appearance.bodyText
				),
				const ListTile(),
				Text(
					initialMessage.author.nameRepr,
					style: Appearance.titleText
				).withPadding(),
				Text(
					initialMessage.date.fullRepr,
					style: Appearance.titleText
				).withPadding()
			],
			// actions: [
			// 	if (isAuthor) EntityActionButton(
			// 		text: "delete",
			// 		action: () => _delete(context, ref)
			// 	)
			// ],
			// sectionShouldRebuild: () {
			// 	bool changed = false;

			// 	if (nameField.text != message.name) {
			// 		message.name = nameField.text;
			// 		changed = true;
			// 	}

			// 	if (contentField.text != message.content) message.content = contentField.text;

			// 	return changed;
			// },
		);
	}

	// Future<void> _delete(BuildContext context, WidgetRef ref) async {
	// 	message.delete();
	// 	Navigator.of(context).pop();
	// 	(ref.read(sectionProvider) as EntitiesSection).update(ref);
	// }
}

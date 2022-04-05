import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/message.dart';

import 'package:podiynyk/ui/widgets/input_field.dart';

import '../providers.dart' show messagesNotifierProvider;
import 'entity.dart';


class MessagePage extends HookConsumerWidget {
	MessagePage(this.initial) :
		isByUser = initial.author.id == Local.userId;

	final Message initial;
	final bool isByUser;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final message = useState(initial);
		final nameField = useTextEditingController(text: initial.nameRepr);
		final contentField = useTextEditingController(text: initial.content);

		useEffect(() {
			if (!initial.hasDetails) initial.withDetails.then((withDetails) {
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
					initial.author.nameRepr,
					style: Appearance.titleText
				).withPadding,
				Text(
					initial.date.fullRepr,
					style: Appearance.titleText
				).withPadding
			],
			// actions: [
			// 	if (isAuthor) EntityActionButton(
			// 		text: "delete",
			// 		action: () => _delete(context, ref)
			// 	)
			// ],
			onClose: () {
				final current = Message.modified(
					message: message.value,
					name: nameField.text,
					content: contentField.text
				);

				if (current.name != initial.name) {
					ref.read(messagesNotifierProvider.notifier).replace(initial, current, preserveState: false);
				}
				else if (current.hasDetails && (!initial.hasDetails || current.content != initial.content)) {
					ref.read(messagesNotifierProvider.notifier).replace(initial, current);
				}
			},
		);
	}

	// Future<void> _delete(BuildContext context, WidgetRef ref) async {
	// 	message.delete();
	// 	Navigator.of(context).pop();
	// 	(ref.read(sectionProvider) as EntitiesSection).update(ref);
	// }
}

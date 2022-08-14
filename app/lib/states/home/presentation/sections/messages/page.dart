import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/message.dart';
import '../../../domain/providers/messages.dart';

import '../../widgets/bars/action_bar.dart';
import '../../widgets/bars/action_button.dart';


class MessagePage extends ConsumerWidget {
	const MessagePage(this.message);

	final Message message;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return Scaffold(body: SafeArea(child: Stack(children: [
			Center(child: ListView(
				shrinkWrap: true,
				children: [
					Text(message.name),
					Text(message.author.fullName),
					Text(message.date.repr),
					Text(message.content),
				]
			)),
			if (ref.watch(userProvider).isAuthor(message)) ActionBar(children: [
				Consumer(builder: (context, ref, _) => ActionButton(
					icon: Icons.delete,
					action: () => _delete(context, ref)
				))
			])
		])));
	}

	// think: confirmation, rename
	void _delete(BuildContext context, WidgetRef ref) {
		// think: await
		ref.read(messagesProvider.notifier).delete(message);
		Navigator.of(context).pop();
	}
}

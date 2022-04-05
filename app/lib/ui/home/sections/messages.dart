import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/message.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'providers.dart' show EntitiesNotifierProvider, messagesNotifierProvider;
import 'section.dart';

import 'entity_pages/message.dart';
import 'new_entity_pages/message.dart';
import 'widgets/entity_tile.dart';
import 'widgets/new_entity_button.dart';


class MessagesSection extends EntitiesSection<Message> {
	const MessagesSection();

	@override
	String get name => "messages";
	@override
	IconData get icon => Icons.messenger;

	@override
	EntitiesNotifierProvider<Message> get provider => messagesNotifierProvider;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final messages = ref.watch(messagesNotifierProvider);

		if (messages == null) return Center(child: Icon(icon));
		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: [
			for (final index in Iterable<int>.generate(messages.length)) EntityTile(
				title: messages[index].name,
				subtitle: messages[index].author.nameRepr,
				trailing: messages[index].date.dateRepr,
				pageBuilder: () => MessagePage(ref.read(messagesNotifierProvider)![index])
			),
			if (Local.userRole != Role.ordinary) const ListTile()
		]);
	}

	@override
	Widget? get actionButton => Local.userRole == Role.ordinary ? null : NewEntityButton(
		pageBuilder: () => NewMessagePage()
	);
}

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
			for (final message in messages) EntityTile(
				title: message.name,
				subtitle: message.author.nameRepr,
				trailing: message.date.dateRepr,
				pageBuilder: () => MessagePage(message)
			),
			if (Local.userRole != Role.ordinary) const ListTile()
		]);
	}

	@override
	Widget? get actionButton => Local.userRole == Role.ordinary ? null : NewEntityButton(
		pageBuilder: () => NewMessagePage()
	);
}

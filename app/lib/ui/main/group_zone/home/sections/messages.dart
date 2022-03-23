import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/message.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'section.dart';
import 'entity_pages/message.dart';
import 'new_entity_pages/message.dart';


class MessagesNotifier extends EntitiesNotifier<Message> {
	@override
	Future<Iterable<Message>> get entities => Cloud.messages;
}

final messagesNotifierProvider = StateNotifierProvider<MessagesNotifier, Iterable<Message>?>((ref) {
	return MessagesNotifier();
});


class MessagesSection extends EntitiesSection<Message> {
	static const name = "messages";
	static const icon = Icons.messenger;

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	StateNotifierProvider<EntitiesNotifier<Message>, Iterable<Message>?> get provider => messagesNotifierProvider;

	@override
	List<Widget> tiles(BuildContext context, Iterable<Message> messages) => [
		for (final message in messages) EntityTile(
			title: message.name,
			subtitle: message.author.nameRepr,
			trailing: message.date.dateRepr,
			pageBuilder: () => MessagePage(message)
		),
		if (Cloud.userRole != Role.ordinary) const ListTile()
	];

	@override
	Widget? get actionButton => Cloud.userRole == Role.ordinary ? null : NewEntityButton(
		pageBuilder: () => NewMessagePage()
	);
}

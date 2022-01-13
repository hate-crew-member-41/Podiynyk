import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/message.dart';

import 'entity_pages/message.dart';
import 'new_entity_pages/message.dart';
import 'section.dart';


class MessagesSection extends ExtendableListSection<Message> {
	@override
	final name = "messages";
	@override
	final icon = Icons.messenger;

	@override
	Future<List<Message>> get entitiesFuture => Cloud.messages();

	@override
	Widget tile(BuildContext context, Message message) => ListTile(
		title: Text(message.subject),
		trailing: Text(message.date.dateRepr),
		onTap: () => Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => MessagePage(message)
		))
	);

	@override
	Widget addEntityButton(BuildContext context) => AddEntityButton(pageBuilder: (_) => NewMessagePage());
}

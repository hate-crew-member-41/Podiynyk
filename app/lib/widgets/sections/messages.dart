import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Message;

import 'section.dart';
import 'new_entity_pages/message.dart';


class MessagesSection extends ExtendableListSection<Message> {
	@override
	final name = "messages";
	@override
	final icon = Icons.messenger;

	MessagesSection() {
		futureEntities = Cloud.messages();
	}

	@override
	ListTile tile(BuildContext context, Message message) => ListTile(
		title: Text(message.subject),
		trailing: Text(message.date.dateRepr)
	);

	@override
	Widget addEntityButton(BuildContext context) => AddEntityButton(newEntityPage: NewMessagePage());
}




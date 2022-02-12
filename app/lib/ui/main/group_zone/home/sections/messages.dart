import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/message.dart';

import 'section.dart';
import 'entity_pages/message.dart';
import 'new_entity_pages/message.dart';


class MessagesSectionCloudData extends CloudEntitiesSectionData<Message> {
	final messages = Cloud.messages;

	@override
	Future<List<Message>> get counted => messages;
}


class MessagesSection extends CloudEntitiesSection<MessagesSectionCloudData, Message> {
	static const name = "messages";
	static const icon = Icons.messenger;

	MessagesSection() : super(MessagesSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;
	@override
	Widget get actionButton => NewEntityButton(
		pageBuilder: (_) => NewMessagePage()
	);

	@override
	Future<List<Message>> get entities => data.messages;

	@override
	List<Widget> tiles(BuildContext context, List<Message> messages) => [
		for (final message in messages) ListTile(
			title: Text(message.topic),
			trailing: Text(message.date.dateRepr),
			onTap: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (context) => MessagePage(message)
			))
		),
		const ListTile()
	];
}

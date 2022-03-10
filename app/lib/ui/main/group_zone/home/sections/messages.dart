import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/message.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

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
	Widget? get actionButton => Cloud.role == Role.ordinary ? super.actionButton : NewEntityButton(
		pageBuilder: (_) => NewMessagePage()
	);

	@override
	Future<List<Message>> get entities => data.messages;

	// todo: include the author in the subtitle
	@override
	List<Widget> tiles(BuildContext context, List<Message> messages) => [
		for (final message in messages) EntityTile(
			title: message.name,
			subtitle: message.author,
			trailing: message.date.dateRepr,
			pageBuilder: () => MessagePage(message)
		),
		const ListTile()
	];
}

import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/message.dart';

import 'section.dart';
import 'entity_pages/message.dart';


class MessagesSectionCloudData {
	final messages = Cloud.messages;
}


class MessagesSection extends CloudSection {
	static const name = "messages";
	static const icon = Icons.messenger;

	MessagesSection() : super(MessagesSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Message>>(
			future: cloudData.messages,
			builder: (context, snapshot) {
				// todo: what is shown while awaiting
				if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(icon));
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				return ListView(
					children: [
						for (final message in snapshot.data!) ListTile(
							title: Text(message.subject),
							trailing: Text(message.date.dateRepr),
							onTap: () => Navigator.of(context).push(MaterialPageRoute(
								builder: (context) => MessagePage(message)
							))
						),
						const ListTile()
					]
				);
			}
		);
	}

	// @override
	// Widget addEntityButton(BuildContext context) => NewEntityButton(
	// 	pageBuilder: (_) => NewMessagePage()
	// );
}

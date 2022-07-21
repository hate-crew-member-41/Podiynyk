import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/message.dart';
import '../../../domain/providers/messages.dart';

import '../../widgets/entities_list.dart';
import '../../widgets/entity_tile.dart';
import '../../widgets/home_section_bar.dart';

import '../section.dart';
import 'message_form.dart';
import 'message_page.dart';


class MessagesSection extends HomeSection {
	const MessagesSection();

	@override
	final String name = "messages";
	@override
	final IconData icon = Icons.chat;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final messages = ref.watch(messagesProvider);

		return Scaffold(
			appBar: HomeSectionBar(
				name: name,
				icon: icon,
				count: messages?.length
			),
			body: EntitiesList<Message>(
				messages,
				tile: (message) => EntityTile(
					title: message.name,
					subtitle: message.author.fullName,
					trailing: message.date.shortRepr,
					pageBuilder: (context) => MessagePage(message)
				),
				formBuilder: (context) => const MessageForm()
			)
		);
	}
}

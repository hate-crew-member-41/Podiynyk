import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/message.dart';
import '../../../domain/providers/messages.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/bars/home_section_bar.dart';
import '../../widgets/tiles/entity_tile.dart';

import '../section.dart';
import 'form.dart';
import 'page.dart';


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
			body: EntityList<Message>(
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

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/presentation/open_page.dart';

import '../../../domain/entities/message.dart';
import '../../../domain/providers/messages.dart';

import '../../widgets/entities_list.dart';
import '../../widgets/home_section_bar.dart';

import '../section.dart';
import 'message_form.dart';


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
				tile: (message) => ListTile(
					title: Text(message.name),
					subtitle: Text(message.author.fullName),
					trailing: Text(message.date.shortRepr)
				)
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () => openPage(
					context: context,
					builder: (context, _) => const MessageForm()
				),
				child: const Icon(Icons.add)
			)
		);
	}
}

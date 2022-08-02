import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/message.dart';
import '../../../domain/providers/messages.dart';

import '../../state.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/bars/section_bar.dart';
import '../../widgets/tiles/entity_tile.dart';

import 'form.dart';
import 'page.dart';


class MessagesSection extends ConsumerWidget {
	const MessagesSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final messages = ref.watch(messagesProvider);

		return Scaffold(
			appBar: SectionBar(
				section: Section.messages,
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

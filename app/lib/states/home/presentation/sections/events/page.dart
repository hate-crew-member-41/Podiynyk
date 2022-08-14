import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/event.dart';
import '../../../domain/providers/events.dart';

import '../../widgets/bars/action_bar.dart';
import '../../widgets/bars/action_button.dart';


// think: define EntityPage
class EventPage extends ConsumerWidget {
	const EventPage(this.event);

	final Event event;

	// think: remove the Stack
	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);
		final isRelevant = user.eventIsRelevant(event);

		return Scaffold(body: SafeArea(child: Stack(children: [
			Center(child: ListView(
				shrinkWrap: true,
				children: [
					Text(event.name),
					if (event.subject != null) Text(event.subject!.name),
					Text(event.date.repr),
					if (event.note != null) Text(event.note!)
				]
			)),
			ActionBar(children: [
				ActionButton(
					icon: isRelevant ? Icons.check : Icons.undo,
					action: () => ref.read(userProvider.notifier).toggleEventIsRelevant(event)
				),
				Consumer(builder: (context, ref, _) => ActionButton(
					icon: Icons.delete,
					action: () => _delete(context, ref)
				))
			])
		])));
	}

	// think: confirmation, rename
	void _delete(BuildContext context, WidgetRef ref) {
		// think: await
		ref.read(eventsProvider.notifier).delete(event);
		Navigator.of(context).pop();
	}
}

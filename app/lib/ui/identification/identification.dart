import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/local.dart';

import 'intro_page.dart';


final pageProvider = StateProvider<Widget>((ref) {
	return const IdentificationIntroPage();
});


class Identification extends ConsumerWidget {
	const Identification();

	static bool get isInProcess => Local.groupId == null || Local.userId == null;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return ref.watch(pageProvider);
	}
}
















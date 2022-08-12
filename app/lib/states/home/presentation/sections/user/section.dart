import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../state.dart';
import '../../widgets/bars/section_bar.dart';
import 'editing_page.dart';
import 'page.dart';


final userIsEditingProvider = StateProvider.autoDispose<bool>((ref) => false);

class UserSection extends HookConsumerWidget {
	const UserSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final pages = usePageController();
		ref.listen(userIsEditingProvider, (_, bool isEditing) {
			// do: take from the theme
			pages.animateToPage(
				isEditing ? 1 : 0,
				duration: const Duration(milliseconds: 200),
				curve: Curves.easeInOutCubic
			);
		});

		return Scaffold(
			appBar: const SectionBar(section: Section.settings),
			body: PageView(
				controller: pages,
				physics: const NeverScrollableScrollPhysics(),
				children: const [
					UserPage(),
					UserEditingPage()
				]
			)
		);
	}
}

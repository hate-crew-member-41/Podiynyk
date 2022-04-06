import 'package:flutter/material.dart';

import 'package:podiynyk/storage/appearance.dart';


class FollowedPage extends StatelessWidget {
	const FollowedPage({
		required this.title,
		required this.children,
		required this.onGoForward,
		this.onLongPress
	});

	final String title;
	final List<Widget> children;
	final void Function() onGoForward;
	final void Function()? onLongPress;

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: onGoForward,
			onLongPress: onLongPress,
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(title, style: Appearance.headlineText).withPadding,
					...children
				]
			))
		);
	}
}

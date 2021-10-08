import 'package:flutter/material.dart';
import 'package:animations/animations.dart';


class DedicatedWidget extends StatelessWidget {
	final Widget Function(BuildContext, void Function()) closedBuilder;
	final Widget Function() pageHeadBuilder;
	final Widget Function() pageBodyBuilder;
	DedicatedWidget({
		required this.closedBuilder,
		required this.pageHeadBuilder,
		required this.pageBodyBuilder
	});

	@override
	Widget build(BuildContext context) {
		return OpenContainer(
			transitionDuration: Duration(seconds: 1),
			closedBuilder: closedBuilder,
			openBuilder: (_, __) => Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					pageHeadBuilder(),
					SizedBox(height: 50),
					pageBodyBuilder()
				]
			)
		);
	}
}

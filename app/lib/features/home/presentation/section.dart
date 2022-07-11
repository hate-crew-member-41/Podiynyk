import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


abstract class HomeSection extends ConsumerWidget {
	const HomeSection();

	abstract final String name;
	abstract final IconData icon;

	int? count(WidgetRef ref) => null;

	// think: capture common logic
	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return Center(child: Icon(icon));
	}
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


// think: define HomeSection.build
abstract class HomeSection extends ConsumerWidget {
	const HomeSection();

	// think: define enum HomeState, move these fields to it, assign its values instead of HomeSections
	abstract final String name;
	abstract final IconData icon;
}

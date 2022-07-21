import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


// think: define HomeSection.build
abstract class HomeSection extends ConsumerWidget {
	const HomeSection();

	abstract final String name;
	abstract final IconData icon;
}

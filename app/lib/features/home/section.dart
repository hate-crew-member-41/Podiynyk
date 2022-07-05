import 'package:flutter/material.dart';


abstract class HomeSection extends StatelessWidget {
	const HomeSection();

	abstract final String name;
	abstract final IconData icon;
	abstract final IconData inactiveIcon;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(child: Icon(icon))
		);
	}
}

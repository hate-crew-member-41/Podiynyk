import 'package:flutter/material.dart';


abstract class Section extends StatelessWidget {
	abstract final String name;
	abstract final IconData icon;

	const Section();
}

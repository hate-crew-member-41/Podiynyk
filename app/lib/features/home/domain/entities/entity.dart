import 'package:flutter/material.dart';


@immutable
abstract class Entity implements Comparable {
	const Entity({required this.id});

	final String id;

	@override
	bool operator ==(Object other) => other is Entity && id == other.id;
	
	@override
	int get hashCode => id.hashCode;
}

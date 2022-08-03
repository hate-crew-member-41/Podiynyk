import 'package:flutter/material.dart';


// think: add a constructor for new entity objects
@immutable
abstract class Entity implements Comparable {
	const Entity({required this.id});

	final String id;

	@override
	bool operator ==(Object other) => other is Entity && id == other.id;
	
	@override
	int get hashCode => id.hashCode;
}

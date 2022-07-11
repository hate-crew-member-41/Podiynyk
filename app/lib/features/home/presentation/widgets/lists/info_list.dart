import 'package:flutter/material.dart';

import '../../../domain/entities/info.dart';

import 'entities_list.dart';


class InfoList extends EntitiesList<Info> {
	const InfoList(super.entities);

	@override
	Widget tile(Info item) => ListTile(
		title: Text(item.name)
	);
}

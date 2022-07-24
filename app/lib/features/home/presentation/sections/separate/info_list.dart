import 'package:flutter/material.dart';

import '../../../domain/entities/info.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/entity_tile.dart';

import 'info_form.dart';
import 'page.dart';


class InfoList extends StatelessWidget {
	const InfoList(this.info);

	final Iterable<Info>? info;

	@override
	Widget build(BuildContext context) {
		return EntityList<Info>(
			info,
			tile: (item) => EntityTile(
				title: item.name,
				pageBuilder: (context) => InfoPage(item)
			),
			formBuilder: (context) => const InfoForm(),
		);
	}
}

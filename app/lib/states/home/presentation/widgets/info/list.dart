import 'package:flutter/material.dart';

import '../../../domain/entities/info.dart';
import '../../../domain/entities/subject.dart';

import '../entity_list.dart';
import '../tiles/entity_tile.dart';

import 'form.dart';
import 'page.dart';


class InfoList extends StatelessWidget {
	const InfoList(
		this.info, {
			this.subject,
			this.isExtendable = true
		}
	);

	final Iterable<Info>? info;
	final Subject? subject;
	final bool isExtendable;

	@override
	Widget build(BuildContext context) {
		return EntityList<Info>(
			info,
			tile: (item) => EntityTile(
				title: item.name,
				pageBuilder: (context) => InfoPage(item)
			),
			formBuilder: isExtendable ?
				(context) => InfoForm(subject: subject) : null,
		);
	}
}

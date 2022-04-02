import 'package:flutter/material.dart';

import 'package:podiynyk/storage/appearance.dart';


class EntityTile extends StatelessWidget {
	const EntityTile({
		required this.title,
		this.subtitle,
		this.trailing,
		this.opaque = true,
		required this.pageBuilder
	});

	final String title;
	final String? subtitle;
	final String? trailing;
	final bool opaque;
	final Widget Function() pageBuilder;

	@override
	Widget build(BuildContext context) {
		return Opacity(
			opacity: opaque ? 1 : .5,
			child: ListTile(
				title: Text(title),
				subtitle: subtitle != null ? Text(subtitle!, style: Appearance.labelText) : null,
				trailing: trailing != null ? Text(trailing!, style: Appearance.titleText) : null,
				onTap: () => Navigator.of(context).push(MaterialPageRoute(
					builder: (_) => pageBuilder()
				))
			),
		);
	}
}

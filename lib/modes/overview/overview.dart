import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/database/models/appearance.dart';


class Overview extends StatelessWidget {
	final Map<String, List>? _updates;  // todo: complete List generic

	Overview(this._updates);

	static Map<String, List> detectUpdates(Map<String, List<dynamic>> oldData, Map<String, List<dynamic>> newData) {
		return {};
		// Map<String, List> updates = {
		// 	'added_info': [], 'deleted_info': [],
		// };

		// Set<String> oldInfo = oldData['info'].toSet(), newInfo = newData['info'].toSet();
		// updates['added_info'] = newInfo.difference(oldInfo).toList();
		// updates['deleted_info'] = oldInfo.difference(newInfo).toList();

		// updates.removeWhere( (_, value) => value.isEmpty );
		// return updates;
	}

	@override
	Widget build(BuildContext context) {
		if (_updates != null) {
			// return Overview with updates
			return Scaffold(
				backgroundColor: context.read<Appearance>().background,
				body: Center(
					child: Text(
						'Overview($_updates)',
						style: TextStyle(fontSize: 20, color: Colors.green)
					)
				)
			);
		}
		// return Overview with error, include last sync time
	return Scaffold(
			body: Center(
				child: Text(
					'Overview(error)',
					style: TextStyle(color: Colors.red)
				)
			)
		);
	}
}

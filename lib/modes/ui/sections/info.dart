// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:animations/animations.dart';

// import '../../../database/entities/info_record.dart' show InfoRecord;
// import '../../../database/models/group.dart';
// import '../dedicated_page.dart';


// class InfoSection extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		List<InfoRecord> info = context.select<Group, List<InfoRecord>>( (group) => group.info );
// 		if (info.isEmpty) return Center(child: Text('інформації немає :('));
// 		return ListView(children: info.map<OpenContainer>(_tile).toList());
// 	}

// 	OpenContainer _tile(InfoRecord record) => OpenContainer<ListTile>(
// 		closedBuilder: (_, __) => ListTile(title: Text(record.title)),
// 		openBuilder: (_, __) => DedicatedPage(
// 			title: Text(record.title),
// 			child: Text(record.content)
// 		),
// 	);
// }

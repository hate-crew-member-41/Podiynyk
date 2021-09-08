// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../database/models/user.dart';
// import '../../database/models/group.dart';


// class LeaderDeterminationModel with ChangeNotifier {
// 	late Widget _page;

// 	LeaderDeterminationModel(BuildContext context) {
// 		bool? claimsToBeLeader = context.read<User>().claimsToBeLeader;
// 		if (claimsToBeLeader == null) _page = LeaderDeterminationAnswering();
// 		else _page = claimsToBeLeader ? LeaderDeterminationWaiting() : LeaderDeterminationIndicating();
// 	}

// 	Widget get page => _page;
// 	set part(Widget page) {
// 		_page = page;
// 		notifyListeners();
// 	}
// }


// class LeaderDetermination extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		return Scaffold(
// 			body: Padding(
// 				padding: EdgeInsets.all(20.0),
// 				child: ChangeNotifierProvider<LeaderDeterminationModel>(
// 					create: (context) => LeaderDeterminationModel(context),
// 					child: Consumer<LeaderDeterminationModel>(
// 						builder: (_, leaderConfirmation, __) => Column(
// 							children: [
// 								Text('Визначення старости'),
// 								AnimatedSwitcher(
// 									child: leaderConfirmation.page,
// 									duration: Duration(milliseconds: 500),
// 								)
// 							]
// 						)
// 					)
// 				)
// 			)
// 		);
// 	}
// }


// class LeaderDeterminationAnswering extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		return Column(
// 			children: [
// 				Text('Це ти?'),
// 				Row(
// 					mainAxisAlignment: MainAxisAlignment.spaceBetween,
// 					children: [
// 						TextButton(
// 							child: Text('так'),
// 							onPressed: () {
// 								context.read<User>().claimsToBeLeader = true;
// 								context.read<LeaderDeterminationModel>().part = LeaderDeterminationWaiting();
// 							},
// 						),
// 						TextButton(
// 							child: Text('ні'),
// 							onPressed: () {
// 								context.read<User>().claimsToBeLeader = false;
// 								context.read<LeaderDeterminationModel>().part = LeaderDeterminationIndicating();
// 							},
// 						)
// 					],
// 				)
// 			],
// 		);
// 	}
// }


// class LeaderDeterminationIndicating extends StatelessWidget {  // todo: make new students fly in nicely
// 	final List<String> _groupmates = [];

// 	@override
// 	Widget build(BuildContext context) {
// 		return Scaffold(
// 			body: Column(
// 				children: [
// 					Text('А хто з них?'),
// 					StreamBuilder<List<String>>(
// 						stream: context.read<Group>().updates.map<List<String>>( (document) => document['students'].keys.toList() ),
// 						builder: (context, snapshot) {
// 							String name = context.read<User>().name;
// 							List<String> students = snapshot.data!;  // tofix: consider that initial snapshot does not have data

// 							students..remove(name)..removeWhere( (groupmate) => _groupmates.contains(groupmate) );
// 							_groupmates.insertAll(0, students);

// 							return ListView(
// 								children: _groupmates.map((groupmate) => ListTile(
// 									title: Text(groupmate))
// 								).toList()
// 							);
// 						}
// 					)
// 				]
// 			)
// 		);
// 	}
// }


// class LeaderDeterminationWaiting extends StatelessWidget {
// 	const LeaderDeterminationWaiting({ Key? key }) : super(key: key);

// 	@override
// 	Widget build(BuildContext context) {
// 		return Text('очікування');
// 	}
// }

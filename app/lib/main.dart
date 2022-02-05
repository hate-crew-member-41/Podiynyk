import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'storage/cloud.dart' show Cloud;
import 'storage/local.dart' show Local;

import 'ui/loading.dart';
import 'ui/main/main.dart';


void main() {
	runApp(App());
}


// todo: sync the role
class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeData(
				useMaterial3: true,
				brightness: Brightness.dark,
				canvasColor: const HSVColor.fromAHSV(1, 0, 0, .1).toColor(),
				appBarTheme: AppBarTheme(
					backgroundColor: const HSVColor.fromAHSV(1, 0, 0, .2).toColor(),
				),
				textTheme: TextTheme(
					headline6: GoogleFonts.montserrat(),  // app bar
					subtitle1: GoogleFonts.montserrat(),  // list tile's title
					bodyText1: GoogleFonts.montserrat(),  // emphasized text
					bodyText2: GoogleFonts.montserrat()  // plain text
				),
				floatingActionButtonTheme: FloatingActionButtonThemeData(
					backgroundColor: const HSVColor.fromAHSV(1, 0, 0, .2).toColor(),
					foregroundColor: Colors.white
				)
			),
			title: 'Podiynyk',
			home: FutureBuilder(
				future: Future.wait([Local.init(), Cloud.init()]),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) return const Loading();
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
					return const AppMain();
				}
			)
		);
	}
}

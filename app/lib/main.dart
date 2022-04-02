import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'storage/appearance.dart';
import 'storage/cloud.dart';
import 'storage/local.dart';

import 'ui/loading.dart';
import 'ui/home/home.dart';


void main() {
	runApp(ProviderScope(
		child: App()
	));
}


class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Podiynyk',
			home: FutureBuilder(
				future: Future.wait([Local.init(), Cloud.init()]),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) return const Loading();
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
					return const Home();
				}
			),
			themeMode: ThemeMode.dark,
			darkTheme: ThemeData(
				colorScheme: const ColorScheme.dark().copyWith(
					surface: Appearance.secondaryBackgroundColor,
					primary: Appearance.primaryColor,
					onPrimary: Appearance.backgroundColor,
					secondary: Appearance.secondaryBackgroundColor,
					onSecondary: Appearance.primaryColor
				),
				canvasColor: Appearance.backgroundColor,
				textTheme: GoogleFonts.montserratTextTheme().copyWith(
					bodySmall: Appearance.labelText,  // date picker dates
					bodyMedium: Appearance.bodyText,
					bodyLarge: Appearance.labelText,  // time picker hours/minutes
					titleSmall: Appearance.bodyText,  // date picker month
					titleMedium: Appearance.titleText,
					headlineMedium: Appearance.headlineText,
					labelMedium: Appearance.labelText
				),
				appBarTheme: AppBarTheme(
					titleTextStyle: Appearance.largeTitleText
				),
				listTileTheme: ListTileThemeData(
					textColor: Appearance.primaryColor
				),
				inputDecorationTheme: InputDecorationTheme(
					border: InputBorder.none,
					fillColor: Appearance.secondaryBackgroundColor,
					contentPadding: Appearance.padding,
					hintStyle: TextStyle(color: Appearance.primaryColor.withOpacity(.5))
				),
				textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
					padding: Appearance.padding,
					textStyle: Appearance.titleText
				)),
				elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
					minimumSize: const Size.fromHeight(0),
					padding: Appearance.padding,
					textStyle: Appearance.titleText
				)),
				dialogTheme: DialogTheme(
					backgroundColor: Appearance.backgroundColor,
					titleTextStyle: Appearance.largeTitleText
				),
				snackBarTheme: SnackBarThemeData(
					backgroundColor: Appearance.secondaryBackgroundColor,
					contentTextStyle: Appearance.bodyText
				),
				timePickerTheme: TimePickerThemeData(
					backgroundColor: Appearance.backgroundColor,
					hourMinuteColor: Appearance.secondaryBackgroundColor,
					hourMinuteTextStyle: Appearance.displayText,
					dayPeriodColor: Appearance.secondaryBackgroundColor,
					dayPeriodBorderSide: BorderSide.none,
					dialBackgroundColor: Appearance.secondaryBackgroundColor
				)
			)
		);
	}
}

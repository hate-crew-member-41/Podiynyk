import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:podiynyk/database/entities/role.dart' show Role;


class Appearance {
	static late Box<dynamic> _box;

	static bool get isDark => _box.get('isDark');
	static Color get background => isDark ? _color(0.1) : _color(1.0);
	static Color get appBar => isDark ? _color(0.3) : _color(0.4);
	static Color get highlight => isDark ? _color(0.2) : _color(0.9);
	static Color get contrast => isDark ? _color(0.8) : _color(0.2);

	static Future<void> open(BuildContext context) async {
		bool boxExists = await Hive.boxExists('appearance');
		_box = await Hive.openBox<dynamic>('appearance');
		if (!boxExists) _init(context);
	}

	static Future<void> _init(BuildContext context) async {
		bool isDark = Theme.of(context).brightness == Brightness.dark;
		double hue, saturation;

		if (isDark) {
			hue = 230.0;
			saturation = 0.0;
		}
		else {
			hue = 30.0;
			saturation = 0.0;
		}

		await _box.putAll({
			'isDark': isDark,
			'hue': hue,
			'saturation': saturation,
		});
	}
	
	static Color studentColor(Role role) => role == Role.ordinary ? background : highlight;

	static Color _color(double value) => HSVColor.fromAHSV(
		1.0, _box.get('hue'), _box.get('saturation'), value
	).toColor();
}

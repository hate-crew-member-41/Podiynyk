import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:podiynyk/database/entities/role.dart' show Role;


class Appearance {
	late Box<dynamic> _box;

	bool get isDark => _box.get('isDark');
	Color get background => isDark ? _color(0.1) : _color(1.0);
	Color get appBar => isDark ? _color(0.3) : _color(0.4);
	Color get highlight => isDark ? _color(0.2) : _color(0.9);
	Color get contrast => isDark ? _color(0.8) : _color(0.2);

	Future<void> open(BuildContext context) async {
		bool boxExists = await Hive.boxExists('appearance');
		_box = await Hive.openBox<dynamic>('appearance');
		if (!boxExists) _init(context);
	}

	Future<void> _init(BuildContext context) async {
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
	
	Color studentColor(Role role) => role == Role.ordinary ? background : highlight;

	Color _color(double value) => HSVColor.fromAHSV(
		1.0, _box.get('hue'), _box.get('saturation'), value
	).toColor();
}

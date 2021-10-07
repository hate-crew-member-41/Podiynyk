import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class Appearance {
	late Box<dynamic> _box;

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

	bool get isDark => _box.get('isDark');
	Color get background => isDark ? _color(0.1) : _color(1.0);
	Color get appBar => isDark ? _color(0.3) : _color(0.4);
	Color get enabled => isDark ? _color(0.8) : _color(0.9);
	Color get contrast => isDark ? _color(0.8) : _color(0.2);
	
	Color _color(double value) => HSVColor.fromAHSV(
		1.0, _box.get('hue'), _box.get('saturation'), value
	).toColor();
}

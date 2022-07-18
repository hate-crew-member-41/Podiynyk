import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'open_page.dart';


class OptionField<O> extends HookWidget {
	const OptionField({
		// think: accept InputDecoration
		required this.label,
		required this.options,
		// think: replace with [ObjectRef<O?> value/current/option]
		required this.onPick,
		this.isRequired = true
	});

	final String label;
	final Iterable<MapEntry<String, O>> options;
	final void Function(O?) onPick;
	final bool isRequired;

	@override
	Widget build(BuildContext context) {
		final field = useTextEditingController();
		final current = useRef<O?>(null);
		if (isRequired) _onPick(current, options.first.value, field, options.first.key);

		return GestureDetector(
			onTap: () => _handleTap(context, field, current),
			child: TextField(
				controller: field,
				enabled: false,
				decoration: InputDecoration(labelText: label)
			)
		);
	}

	void _handleTap(
		BuildContext context,
		TextEditingController field,
		ObjectRef<O?> current
	) {
		final shown = options.where((o) => o.value != current.value).toList();
		final nullIsShown = current.value != null && !isRequired;

		if (shown.length == 1 && !nullIsShown) {
			_onPick(current, shown.first.value, field, shown.first.key);
			return;
		}

		openPage(
			context: context,
			// think: define a widget for the page
			builder: (context, close) => Scaffold(body: Center(child: ListView(
				shrinkWrap: true,
				children: [
					for (final option in shown) ListTile(
						onTap: () {
							_onPick(current, option.value, field, option.key);
							close();
						},
						title: Text(option.key)
					),
					// think: add a gap or decorate
					if (nullIsShown) ListTile(
						onTap: () {
							_onPick(current, null, field, '');
							close();
						},
						title: const Text('none')
					)
				]
			)))
		);
	}

	void _onPick(
		ObjectRef<O?> current,
		O? option,
		TextEditingController field,
		String fieldRepr
	) {
		current.value = option;
		field.text = fieldRepr;
		onPick(option);
	}
}

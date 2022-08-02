import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiinyk/core/presentation/open_page.dart';


// think: redefine
class OptionField<O> extends HookWidget {
	const OptionField({
		required this.label,
		required this.options,
		required this.onPick,
		this.isRequired = true
	});

	// think: accept InputDecoration
	final String label;
	final Iterable<MapEntry<String, O>> options;
	// think: replace with ObjectRef<O?>
	final void Function(O?) onPick;
	final bool isRequired;

	@override
	Widget build(BuildContext context) {
		final field = useTextEditingController();
		final current = useRef<O?>(null);
		if (isRequired) _onPick(field, options.first.key, current, options.first.value);

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
			_onPick(field, shown.first.key, current, shown.first.value);
			return;
		}

		openPage(context: context, builder: (context) => _OptionsPage<O>(
			options: shown,
			nullIsShown: nullIsShown,
			onPick: (repr, option) => _onPick(field, repr, current, option)
		));
	}

	void _onPick(TextEditingController field, String repr, ObjectRef<O?> current, O? option) {
		field.text = repr;
		current.value = option;
		onPick(option);
	}
}


class _OptionsPage<O> extends StatelessWidget {
	const _OptionsPage({
		required this.options,
		required this.nullIsShown,
		required this.onPick
	});

	final Iterable<MapEntry<String, O>> options;
	final bool nullIsShown;
	final void Function(String, O?) onPick;

	@override
	Widget build(BuildContext context) {
		final close = Navigator.of(context).pop;

		return Scaffold(body: Center(child: ListView(
			shrinkWrap: true,
			children: [
				for (final option in options) ListTile(
					onTap: () {
						onPick(option.key, option.value);
						close();
					},
					title: Text(option.key)
				),
				// think: add a gap or decorate
				if (nullIsShown) ListTile(
					onTap: () {
						onPick('', null);
						close();
					},
					title: const Text('none')
				)
			]
		)));
	}
}

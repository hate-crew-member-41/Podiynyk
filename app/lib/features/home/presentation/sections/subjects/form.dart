import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/entity.dart';
import '../../../domain/entities/subject.dart';
import '../../../domain/providers/subjects.dart';

import '../../widgets/fields/option_field.dart';


// do: TextField.(textInputType, textInputAction)
class SubjectForm extends HookConsumerWidget {
	const SubjectForm();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController();
		final isCommon = useRef<bool?>(null);

		return GestureDetector(
			onDoubleTap: () => _handleAdd(context, ref, nameField.text, isCommon.value),
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					TextField(
						controller: nameField,
						decoration: const InputDecoration(labelText: 'name')
					),
					// think: a switch
					OptionField<bool>(
						label: 'type',
						options: const [
							MapEntry('common', true),
							MapEntry('chosen', false)
						],
						onPick: (value) => isCommon.value = value
					)
				]
			))
		);
	}

	void _handleAdd(BuildContext context, WidgetRef ref, String name, bool? isCommon) {
		// do: inform the user
		if (name.isEmpty || isCommon == null) return;

		// think: await to show success or a failure
		ref.read(subjectsProvider.notifier).add(Subject(
			id: Entity.newId(),
			name: name,
			isCommon: isCommon
		));
		Navigator.of(context).pop();
	}
}

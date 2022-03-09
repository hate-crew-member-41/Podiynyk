import '../fields.dart';
import '../local.dart';

import 'entity.dart';


abstract class LabelableEntity extends Entity {
	final String name;
	String? _label;

	String get nameRepr => _label ?? name;

	LabelableEntity({required this.name}) {
		_label = Local.entityLabel(labelCollection, id);
	}

	set label(String label) {
		if (label == _label) return;

		if (label.isEmpty || label == name) {
			Local.deleteEntityLabel(labelCollection, id);
			_label = null;
		}
		else {
			Local.setEntityLabel(labelCollection, id, label);
			_label = label;
		}
	}

	Field get labelCollection;
}

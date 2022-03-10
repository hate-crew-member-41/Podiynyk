import '../fields.dart';
import '../local.dart';

import 'entity.dart';


abstract class LabelableEntity extends Entity {
	String name;
	String? _label;

	String get nameRepr => _label ?? name;

	LabelableEntity({
		required List<Object?> idComponents,
		required this.name
	}) : super(idComponents: idComponents) {
		_label = Local.entityLabel(labelCollection, id);
	}

	LabelableEntity.fromCloud({
		required String id,
		required this.name
	}) : super.fromCloud(id: id) {
		_label = Local.entityLabel(labelCollection, id);
	}

	set label(String label) {
		if (label == _label) return;

		if (label != name && label.isNotEmpty) {
			Local.setEntityLabel(labelCollection, id, label);
			_label = label;
		}
		else {
			Local.deleteEntityLabel(labelCollection, id);
			_label = null;
		}
	}

	Field get labelCollection;
}

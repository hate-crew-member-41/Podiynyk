import '../fields.dart';
import '../local.dart';

import 'entity.dart';


abstract class LabelableEntity extends Entity {
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

	String name;
	String? _label;

	String get nameRepr => _label ?? name;
	set nameRepr(String repr) {
		if (repr != name && repr.isNotEmpty) {
			_label = repr;
			Local.setEntityLabel(labelCollection, id, repr);
		}
		else if (_label != null) {
			_label = null;
			Local.deleteEntityLabel(labelCollection, id);
		}
	}

	Field get labelCollection;
}

import '../fields.dart';
import '../local.dart';
import 'storable.dart';


abstract class LabelableEntity implements StorableEntity {
	final String initialName;
	String? _label;

	String get name => _label ?? initialName;

	LabelableEntity({required this.initialName}) {
		_label = Local.entityLabel(labelCollection, essence);
	}

	set label(String label) {
		if (label == _label) return;

		if (label.isEmpty || label == name) {
			Local.deleteEntityLabel(labelCollection, essence);
			_label = null;
		}
		else {
			Local.setEntityLabel(labelCollection, essence, label);
			_label = label;
		}
	}

	Field get labelCollection;

	@override
	String get essence => initialName;
}

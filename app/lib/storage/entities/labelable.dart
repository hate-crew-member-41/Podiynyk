import '../fields.dart';
import '../local.dart';


abstract class LabelableEntity {
	final String initialName;
	String? _label;

	String get name => _label ?? initialName;

	LabelableEntity({required this.initialName}) {
		_label = Local.entityLabel(Field.events, essence);
	}

	set label(String label) {
		if (label == _label) return;

		if (label.isEmpty || label == name) {
			Local.deleteEntityLabel(Field.events, essence);
			_label = null;
		}
		else {
			Local.setEntityLabel(Field.events, essence, label);
			_label = label;
		}
	}

	Field get labelCollection;

	String get essence => initialName;
}

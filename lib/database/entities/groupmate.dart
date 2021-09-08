import 'package:hive/hive.dart';

import 'role.dart' show Role;


class Groupmate {
	final String name;
	final Role role;
	final String? label;

	const Groupmate({
    	required this.name,
    	required this.role,
    	required this.label
	});
}

class GroupmateAdapter extends TypeAdapter<Groupmate> {
	@override
	final typeId = 1;

	@override
	Groupmate read(BinaryReader reader) {
		List<dynamic> fields = reader.readList();
		return Groupmate(
			name: fields[0],
			role: fields[1],
			label: fields[2]
		);
	}

	@override
	void write(BinaryWriter writer, Groupmate groupmate) {
		writer.writeList([ groupmate.name, groupmate.role, groupmate.label ]);
	}
}

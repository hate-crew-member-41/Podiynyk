import 'package:hive/hive.dart';


enum Role {
	ordinary,  // multiple in a group | views events, info, messages; answers questions
	trusted,  // multiple in a group | [ordinary] + adds/deletes events, info; sends messages; asks questions
	leader  // one in a group | [trusted] + adds/removes [trusted] students
}

class RoleAdapter extends TypeAdapter<Role> {
	@override
	final typeId = 0;

	@override
	Role read(BinaryReader reader) => Role.values[reader.readInt32()];

	@override
	void write(BinaryWriter writer, Role role) {
		writer.writeInt32(role.index);
	}
}

import 'package:hive/hive.dart';


enum Role {
	ordinary,  // views events, info, messages | answers questions
	trusted,  // ordinary + adds/deletes events, info | sends messages | asks questions
	leader  // trusted + adds/removes trusted students
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

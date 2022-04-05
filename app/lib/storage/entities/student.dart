import '../cloud.dart';
import '../identifiers.dart';
import '../local.dart';

import 'entity.dart';


class Student extends Entity {
	Student.user() :
		role = Local.userRole!,
		super(id: Local.userId!, name: Local.userName!);

	Student.fromCloud({required String id, required CloudMap object}) :
		role = Role.values[object[Identifier.role.name] as int],
		super.fromCloud(id: id, object: object);

	Student.author(CloudMap object) :
		role = null,
		super.fromObject(object);
	
	Student.modified({
		required Student student,
		String? nameRepr,
		Role? role
	}) :
		role = role ?? student.role,
		super.modified(entity: student, nameRepr: nameRepr);

	final Role? role;

	@override
	CloudMap get inCloudFormat => {
		Identifier.name.name: name,
		Identifier.role.name: role!.index
	};

	@override
	Collection get cloudCollection => Collection.students;
	@override
	Identifier get labelCollection => Identifier.students;
}


/// The [Role] of a [Student] in the group.
enum Role {
	/// Views the group's content. Multiple [Student]s in the group can have this [Role].
	ordinary,
	/// Manages the group's content. Multiple [Student]s in the group can have this [Role].
	trusted,
	/// Manages the group's [trusted] [Student]s. A single [Student] in the group has this [Role].
	leader,
}

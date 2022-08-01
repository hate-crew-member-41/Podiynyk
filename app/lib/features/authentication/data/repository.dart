import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/data/functions/user_doc_ref.dart';
import 'package:podiinyk/core/data/types/field.dart';
import 'package:podiinyk/core/domain/user.dart';


// do: failures
class AuthRepository {
	const AuthRepository();

	Future<void> initUser(StudentUser user) async {
		await userDocRef(user.id).set({
			Field.name.name: [user.name, user.surname],
			// do: remove after EnteringGroup is implemented
			Field.groupId.name: user.groupId,
			Field.subjects.name: user.chosenSubjectIds!.toList()
		});
	}

	Future<StudentUser> user(String id) async {
		final snapshot = await userDocRef(id).get();
		final map = snapshot.data()!;
		return StudentUser(
			id: id,
			name: map[Field.name.name].first,
			surname: map[Field.name.name].last,
			groupId: map[Field.groupId.name],
			chosenSubjectIds: map.containsKey(Field.subjects.name) ?
				Set<String>.from(map[Field.subjects.name]) :
				null
		);
	}
}

final authRepositoryProvider = Provider<AuthRepository>(
	(ref) => const AuthRepository()
);

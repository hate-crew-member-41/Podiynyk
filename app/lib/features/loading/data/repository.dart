import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/data/functions/user_doc_ref.dart';
import 'package:podiinyk/core/data/types/field.dart';
import 'package:podiinyk/core/domain/user.dart';


// do: failures
class LoadingRepository {
	const LoadingRepository();

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

final loadingRepositoryProvider = Provider<LoadingRepository>(
	(ref) => const LoadingRepository()
);

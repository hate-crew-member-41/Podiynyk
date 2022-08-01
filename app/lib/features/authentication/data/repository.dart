import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/data/functions/user_doc_ref.dart';
import 'package:podiinyk/core/data/types/field.dart';
import 'package:podiinyk/core/domain/user.dart';


// do: failures
class AuthRepository {
	const AuthRepository();

	Future<void> initUser(StudentUser user) async {
		await userDocRef(user.id).set({
			Field.name.name: [user.name, user.surname]
		});
	}
}

final authRepositoryProvider = Provider<AuthRepository>(
	(ref) => const AuthRepository()
);

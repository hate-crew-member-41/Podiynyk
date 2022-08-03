
import 'user/user.dart';


String newId({required User user}) {
	final timeComponent = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
	final userComponent = user.id.substring(0, 2);
	return ('$timeComponent$userComponent'.split('')..shuffle()).join().toUpperCase();
}

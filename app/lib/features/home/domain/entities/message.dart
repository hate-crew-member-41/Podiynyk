import 'package:podiinyk/core/domain/types/date.dart';
import 'package:podiinyk/core/domain/user.dart';

import 'entity.dart';
import 'student.dart';


class Message extends Entity {
	const Message({
		required String id,
		required this.name,
		required this.content,
		required this.author,
		required this.date,
	}) :
		super(id: id);

	final String name;
	final String content;
	final Student author;
	final Date date;

	bool get isByUser => author.id == User.id;

	@override
	int compareTo(covariant Message other) => -date.compareTo(other.date);
}

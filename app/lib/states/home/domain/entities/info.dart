import 'entity.dart';
import 'subject.dart';


class Info extends Entity {
	const Info({
		required String id,
		required this.name,
		this.subject,
		required this.content
	}) :
		super(id: id);

	final String name;
	final Subject? subject;
	final String content;

	@override
	int compareTo(covariant Info other) => name.compareTo(other.name);
}

import '../cloud.dart' show Cloud;

import 'entity.dart';


typedef MessageEssence = String;


class Message implements DetailedEntity, StoredEntity<MessageEssence> {
	final String id;
	final String subject;
	final DateTime date;

	String? author;
	String? content;

	Message({
		required this.id,
		required this.subject,
		required this.date
	});

	@override
	Future<void> addDetails() => Cloud.addMessageDetails(this);

	@override
	MessageEssence get essence => subject;

	@override
	bool essenceIs(MessageEssence comparedTo) => subject == comparedTo;
}

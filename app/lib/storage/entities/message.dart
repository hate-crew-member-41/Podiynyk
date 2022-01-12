import 'package:podiynyk/storage/cloud.dart' show Cloud;


class Message {
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

	Future<void> addDetails() => Cloud.addMessageDetails(this);
}

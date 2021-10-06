import 'package:hive/hive.dart';


class Event {
	final int id;
	final String content;
	final DateTime datetime;
	final String? note;

	const Event({
		required this.id, 
		required this.content,
		required this.datetime,
		required this.note
	});
}

class EventAdapter extends TypeAdapter<Event> {
	@override
	final typeId = 2;

	@override
	Event read(BinaryReader reader) {
		List<dynamic> fields = reader.readList();
		return Event(
			id: fields[0],
			content: fields[1],
			datetime: fields[2],
			note: fields[3]
		);
	}

	@override
	void write(BinaryWriter writer, Event event) {
		writer.writeList([ event.id, event.content, event.datetime, event.note ]);
	}
}

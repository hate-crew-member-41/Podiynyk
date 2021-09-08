import 'package:hive/hive.dart';


class InfoRecord {
	final String title, content;

	const InfoRecord({
		required this.title,
		required this.content
	});
}

class InfoRecordAdapter extends TypeAdapter<InfoRecord> {
	@override
	final typeId = 3;

	@override
	InfoRecord read(BinaryReader reader) {
		List<dynamic> fields = reader.readStringList();
		return InfoRecord(
			title: fields[0],
			content: fields[1]
		);
	}

	@override
	void write(BinaryWriter writer, InfoRecord infoRecord) {
		writer.writeStringList([ infoRecord.title, infoRecord.content ]);
	}
}

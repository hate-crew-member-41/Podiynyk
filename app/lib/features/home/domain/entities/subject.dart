class Subject {
	Subject({
		required this.id,
		required this.name,
		required this.isCommon
	});

	final String id;
	final String name;
	final bool isCommon;

	@override
	bool operator ==(Object other) => other is Subject && id == other.id;
	
	@override
	int get hashCode => id.hashCode;
}

class Subject {
	final String id, name;
	final String? label;
	final int numEvents, numEventsSoFar;

	const Subject({
		required this.id,
		required this.name,
		required this.label,
		required this.numEvents,
		required this.numEventsSoFar
	});
}

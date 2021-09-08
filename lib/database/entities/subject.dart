class Subject {
	final String id, name;
	final int numEvents, percentage, numEventsSoFar;
  final String? label;

	const Subject({
		required this.id,
		required this.name,
		required this.numEvents,
    required this.percentage,
		required this.numEventsSoFar,
		required this.label
	});
}

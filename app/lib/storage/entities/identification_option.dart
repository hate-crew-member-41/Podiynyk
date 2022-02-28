abstract class IdentificationOption implements Comparable {
	abstract final String id;
	abstract final String name;

	@override
	int compareTo(dynamic other) => name.compareTo(other.name);
}

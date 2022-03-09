abstract class IdentificationOption implements Comparable {
	abstract final String id;
	abstract final String name;

	@override
	int compareTo(covariant IdentificationOption other) => name.compareTo(other.name);
}

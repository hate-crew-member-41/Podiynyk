/// An entity that is stored locally.
abstract class StoredEntity<E> {
	/// What makes the entity itself.
	/// The [E]ssence is used in [essenceIs] for this [StoredEntity] to be compared to.
	E get essence;

	/// Whether this entity's [essence] is the same as the [comparedTo] one.
	bool essenceIs(E comparedTo);
}


/// An entity with details that are not fetched immediately.
abstract class DetailedEntity {
	/// Fetches the entity's details.
	Future<void> addDetails();
}

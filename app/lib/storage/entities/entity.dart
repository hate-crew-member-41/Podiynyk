import '../cloud.dart' show CloudId;


abstract class Entity {
	final String id;

	Entity({required List<Object?> idComponents}) : id = idComponents.join(':').safeId;

	Entity.fromCloud({required this.id});
}

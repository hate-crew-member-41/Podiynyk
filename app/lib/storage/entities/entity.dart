import '../cloud.dart' show CloudId;


abstract class Entity {
	String get id => idComponents.join(':').safeId;
	List<dynamic> get idComponents;
}

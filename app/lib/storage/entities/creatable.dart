import '../cloud.dart' show CloudMap;

import 'entity.dart';


abstract class CreatableEntity implements Entity {
	CloudMap get inCloudFormat;

	CloudMap get detailsInCloudFormat;
}

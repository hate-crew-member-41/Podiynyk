extension IntExtension on int {
	String get twoDigitRepr => toString().padLeft(2, '0');
}

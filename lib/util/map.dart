extension MapExtensions on Map<dynamic, dynamic> {
  Map<String, dynamic> ensureStringKeys() => cast<String, dynamic>()
      .map((key, value) => MapEntry(key, value is Map ? value.ensureStringKeys() : value));
}

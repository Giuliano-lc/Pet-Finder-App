import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class SpottedAnimalModel {
  String? species;
  String? color;
  String? size;
  String? additionalDescription;
  String? picture;
  GeoPoint? localization;

  SpottedAnimalModel(this.species, this.color, this.size, this.additionalDescription, this.picture, this.localization);

  SpottedAnimalModel.empty();
}
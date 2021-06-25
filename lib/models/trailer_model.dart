import 'dart:convert';

TrailersModel trailersModelFromMap(String str) =>
    TrailersModel.fromMap(json.decode(str));

class TrailersModel {
  TrailersModel({
    this.id,
    this.results,
  });

  int id;
  List<Trailer> results;

  factory TrailersModel.fromMap(Map<String, dynamic> json) => TrailersModel(
        id: json["id"],
        results:
            List<Trailer>.from(json["results"].map((x) => Trailer.fromMap(x))),
      );
}

class Trailer {
  Trailer({
    this.id,
    this.iso6391,
    this.iso31661,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

  String id;
  String iso6391;
  String iso31661;
  String key;
  String name;
  String site;
  int size;
  String type;

  factory Trailer.fromMap(Map<String, dynamic> json) => Trailer(
        id: json["id"],
        iso6391: json["iso_639_1"],
        iso31661: json["iso_3166_1"],
        key: json["key"],
        name: json["name"],
        site: json["site"],
        size: json["size"],
        type: json["type"],
      );
}

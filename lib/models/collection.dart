class BelongsToCollection {
  BelongsToCollection({
    this.id,
    this.name,
    this.posterPath,
    this.backdropPath,
  });

  int id;
  String name;
  String posterPath;
  String backdropPath;

  factory BelongsToCollection.fromMap(Map<String, dynamic> json) {
    if (json == null) return BelongsToCollection();
    return BelongsToCollection(
      id: json["id"],
      name: json["name"],
      posterPath: json["poster_path"],
      backdropPath: json["backdrop_path"],
    );
  }
}

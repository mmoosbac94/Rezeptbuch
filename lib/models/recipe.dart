import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';


@JsonSerializable()
class Result {
  Hits hits;

  Result({this.hits});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Hits {
  Total total;
  List<Document> hits;

  Hits({this.total, this.hits});

  factory Hits.fromJson(Map<String, dynamic> json) => _$HitsFromJson(json);

  Map<String, dynamic> toJson() => _$HitsToJson(this);
}

@JsonSerializable()
class Total {
  int value;

  Total({this.value});

  factory Total.fromJson(Map<String, dynamic> json) => _$TotalFromJson(json);

  Map<String, dynamic> toJson() => _$TotalToJson(this);
}

@JsonSerializable()
class Document {
  @JsonKey(name: '_index')
  String index;
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: '_source')
  Recipe recipe;

  Document(this.index, this.id, this.recipe);

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}

@JsonSerializable()
class Recipe {
  String name;
  String category;
  List<String> ingredients;
  String preparation;
  int persons;
  int time;
  String tip;

  Recipe(
      {this.name,
      this.category,
      this.ingredients,
      this.preparation,
      this.persons,
      this.time,
      this.tip});

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}

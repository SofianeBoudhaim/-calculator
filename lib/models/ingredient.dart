import 'package:calculator/models/model.dart';

const String tableIngredients = 'ingredients';

class IngredientFields {
  static final List<String> values = [
    id, nomIngredient, kcal, lipides, glucides, proteines
  ];

  static const String id = '_id';
  static const String nomIngredient = 'nomIngredient';
  static const String kcal = 'kcal';
  static const String lipides = 'lipides';
  static const String glucides = 'glucides';
  static const String proteines = 'proteines';
}

class Ingredient {
  final int? id;
  final String nomIngredient;
  final double kcal;
  final double lipides;
  final double glucides;
  final double proteines;

  Ingredient({this.id,
    required this.nomIngredient,
    required this.kcal,
    required this.lipides,
    required this.glucides,
    required this.proteines});

  static Ingredient fromJson(Map<String, Object?> json) =>
      Ingredient(
        id: json[IngredientFields.id] as int?,
        nomIngredient: json[IngredientFields.nomIngredient] as String,
        kcal: json[IngredientFields.kcal] as double,
        lipides: json[IngredientFields.lipides] as double,
        glucides: json[IngredientFields.glucides] as double,
        proteines: json[IngredientFields.proteines] as double,
      );

/*
    return Ingredient(
        id: map['id'],
        nomIngredient: map['nomIngredient'],
        kcal: map['kcal'],
        lipides: map['lipides'],
        glucides: map['glucides'],
        proteines: map['proteines']);

   */


  @override
  Map<String, Object?> toJson() =>
      {
        IngredientFields.id: id,
        IngredientFields.nomIngredient: nomIngredient,
        IngredientFields.kcal: kcal,
        IngredientFields.lipides: lipides,
        IngredientFields.glucides: glucides,
        IngredientFields.proteines: proteines,
      };

  Ingredient copy({
    int? id,
    String? nomIngredient,
    double? kcal,
    double? lipides,
    double? glucides,
    double? proteines,
  }) =>
      Ingredient(
        id: id ?? this.id,
        nomIngredient: nomIngredient ?? this.nomIngredient,
        kcal: kcal ?? this.kcal,
        lipides: lipides ?? this.lipides,
        glucides: glucides ?? this.glucides,
        proteines: proteines ?? this.proteines,
      );
}
/*
    Map<String, dynamic> map = {
      'nomIngredient': nomIngredient,
      'kcal': kcal,
      'lipides': lipides,
      'glucides': glucides,
      'proteines': proteines
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

   */

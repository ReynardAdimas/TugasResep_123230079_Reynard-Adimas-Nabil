class Resep {
  final String id; 
  final String name; 
  final String image;

  Resep({
    required this.id, 
    required this.name, 
    required this.image, 
  });

  factory Resep.fromJson(Map<String, dynamic> json) {
    return Resep(
      id: json['idMeal'], 
      name: json['strMeal'], 
      image: json['strMealThumb'], 
    );
  }
}
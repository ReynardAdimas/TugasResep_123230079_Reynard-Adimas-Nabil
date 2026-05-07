class ResepDetail {
  final String id; 
  final String name; 
  final String category; 
  final String area; 
  final String instruction; 
  final String image; 
  final List<Map<String, String>> ingredients;

  ResepDetail({
    required this.id, 
    required this.name, 
    required this.category, 
    required this.area, 
    required this.instruction, 
    required this.image, 
    required this.ingredients
  }); 

  factory ResepDetail.fromJson(Map<String, dynamic> json) {
    final List<Map<String, String>> ingredients = []; 
    for(int i=1;i<=20;i++)
    {
      final ingredient = json['strIngredient$i']?.toString().trim() ?? ''; 
      final measure = json['strMeasure$i']?.toString().trim() ?? ''; 

      if(ingredient.isNotEmpty) {
        ingredients.add({
          'ingredient': ingredient, 
          'measure':measure
        }
        );
      }
    }
    return ResepDetail(
      id: json['idMeal'], 
      name: json['strMeal'], 
      category: json['strCategory'], 
      area: json['strArea'], 
      instruction: json['strInstructions'], 
      image: json['strMealThumb'], 
      ingredients: ingredients
    );
  }
} 
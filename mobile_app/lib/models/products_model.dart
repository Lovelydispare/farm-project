class ProductsModel {
  final int id;
  final String name;
  final double price;
  final String image;
  final String description;
  final String categoryName;
  final int availability;

  const ProductsModel({
  required this.id,
  required this.name,
  required this.price,
  required this.image,
  required this.description,
  required this.categoryName,
  required this.availability,
  
});

factory ProductsModel.fromJson(Map<String, dynamic> json){
  return ProductsModel(
    id: json['id'],
    name: json["name"], 
    price: json["price"], 
    image: json["image"], 
    description: json["description"], 
    categoryName: json["category"]["name"], 
    availability: json["availability"],
    );
  }

}

class CategoryModel{
  final int id;
  final String name;

  CategoryModel({
  required this.id,
  required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    return CategoryModel(
      id: json['id'], 
      name: json['name'],
    );
  }
}
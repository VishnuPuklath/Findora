// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:alak/models/rating.dart';

class Product {
  final String? id;
  final String name;
  final String description;
  final double quantity;
  final List<String> images;
  final String category;
  final double price;
  final List<Rating>? rating;

  Product(
      {this.id,
      this.rating,
      required this.name,
      required this.description,
      required this.quantity,
      required this.images,
      required this.category,
      required this.price});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'rating': rating
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['_id'],
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        quantity: map['quantity']?.toDouble() ?? 0.0,
        images: List<String>.from(map['images']),
        category: map['category'] ?? '',
        price: map['price']?.toDouble() ?? 0.0,
        rating: map['ratings'] != null
            ? List<Rating>.from(map['ratings']?.map((x) => Rating.fromMap(x)))
            : null);
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}

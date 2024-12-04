// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String userId;
  String? id;
  String product;
  num prize;
  int stock;
  Timestamp createdAt;
  ProductModel({
    required this.userId,
    this.id,
    required this.product,
    required this.prize,
    required this.stock,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'product': product,
      'prize': prize,
      'stock': stock,
      'createdAt': createdAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      userId: map['userId'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      product: map['product'] as String,
      prize: map['prize'] as num,
      stock: map['stock'] as int,
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  ProductModel copyWith({
    String? userId,
    String? id,
    String? product,
    num? prize,
    int? stock,
    Timestamp? createdAt,
  }) {
    return ProductModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      product: product ?? this.product,
      prize: prize ?? this.prize,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

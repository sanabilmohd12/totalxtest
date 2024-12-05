// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String name;
  int age;
  Timestamp createdAt;
  List<String> searchKeywords;

  UserModel({
    this.id,
    required this.name,
    required this.age,
    required this.createdAt,
    this.searchKeywords = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'createdAt': createdAt,
      'searchKeywords': searchKeywords,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      age: map['age'] as int,
      createdAt: map['createdAt'] as Timestamp,
      searchKeywords: List<String>.from(map['searchKeywords'] ?? []),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    int? age,
    Timestamp? createdAt,
    List<String>? searchKeywords,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
      searchKeywords: searchKeywords ?? this.searchKeywords,
    );
  }
}

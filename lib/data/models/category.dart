import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final IconData icon;
  final String state;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.state,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'icon': icon.codePoint,
    'fontFamily': icon.fontFamily,
    'state': state,
  };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'],
    name: map['name'],
    icon: IconData(map['icon'], fontFamily: map['fontFamily']),
    state: map['state'],
  );
}

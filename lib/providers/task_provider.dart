import 'package:flutter/material.dart';

class Discipline {
  final int id;
  final String title;
  final String titleUa;
  final String imageUrl;
  final String label;
  final String titleRu;

  Discipline({
    @required this.id,
    @required this.title,
    @required this.titleUa,
    @required this.imageUrl,
    this.label,
    this.titleRu,
  });
}

import 'package:flutter/material.dart';

class Mood {
  final String name;
  final String emoji;
  final String description;
  final IconData icon;
  final Color color;
  final String recipeCategory; // Maps to recipe API category filter

  const Mood({
    required this.name,
    required this.emoji,
    required this.description,
    required this.icon,
    required this.color,
    required this.recipeCategory,
  });

  static const List<Mood> allMoods = [
    Mood(
      name: 'Comfort',
      emoji: '🍲',
      description: 'Warm, hearty comfort food',
      icon: Icons.soup_kitchen,
      color: Color(0xFFFF6B2C),
      recipeCategory: 'Indian',
    ),
    Mood(
      name: 'Fresh',
      emoji: '🥗',
      description: 'Light, clean and refreshing',
      icon: Icons.eco,
      color: Color(0xFF4CAF50),
      recipeCategory: 'Mediterranean',
    ),
    Mood(
      name: 'Energetic',
      emoji: '⚡',
      description: 'High-protein power meals',
      icon: Icons.flash_on,
      color: Color(0xFFFFC107),
      recipeCategory: 'American',
    ),
    Mood(
      name: 'Sweet',
      emoji: '🍰',
      description: 'Desserts & sweet treats',
      icon: Icons.cake,
      color: Color(0xFFE91E63),
      recipeCategory: 'French',
    ),
    Mood(
      name: 'Adventure',
      emoji: '🌶️',
      description: 'Bold, exotic flavors',
      icon: Icons.travel_explore,
      color: Color(0xFF9C27B0),
      recipeCategory: 'East Asian',
    ),
    Mood(
      name: 'Quick',
      emoji: '⏱️',
      description: 'Fast & easy under 15 min',
      icon: Icons.timer,
      color: Color(0xFF2196F3),
      recipeCategory: 'Italian',
    ),
  ];
}

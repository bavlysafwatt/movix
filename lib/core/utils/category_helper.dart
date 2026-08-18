import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryHelper {
  static const Map<String, IconData> _categories = {
    // Expense Categories
    'Food': FontAwesomeIcons.pizzaSlice,
    'Transportation': FontAwesomeIcons.busSide,
    'Shopping': FontAwesomeIcons.shoppingBag,
    'Entertainment': FontAwesomeIcons.film,
    'Health & Medical': FontAwesomeIcons.heartPulse,
    'Bills & Utilities': FontAwesomeIcons.receipt,
    'Education': FontAwesomeIcons.graduationCap,
    'Groceries': FontAwesomeIcons.basketShopping,
    'Travel': FontAwesomeIcons.planeDeparture,
    'Transfer': FontAwesomeIcons.moneyBillTransfer,
    'Housing': FontAwesomeIcons.house,
    'Personal Care': FontAwesomeIcons.spa,
    'Other': FontAwesomeIcons.ellipsis,

    // Income Categories
    'Salary': FontAwesomeIcons.moneyBillWave,
    'Freelance': FontAwesomeIcons.laptop,
    'Investment': FontAwesomeIcons.chartLine,
    'Business': FontAwesomeIcons.briefcase,
    'Gifts & Donations': FontAwesomeIcons.gift,
  };

  static IconData getCategoryIcon(String category) {
    return _categories[category] ?? FontAwesomeIcons.circleDollarToSlot;
  }
}

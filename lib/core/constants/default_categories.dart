import 'package:expenso/data/models/category.dart';
import 'package:flutter/material.dart';

final List<Category> categories = [
  // Food & Drinks
  Category(id: 1, name: 'Food', icon: Icons.restaurant_menu_outlined, state: 'inactive'),
  Category(id: 2, name: 'Drink', icon: Icons.local_drink_outlined, state: 'inactive'),
  Category(id: 3, name: 'Coffee', icon: Icons.coffee_outlined, state: 'inactive'),
  Category(id: 4, name: 'Tea', icon: Icons.local_cafe_outlined, state: 'inactive'),
  Category(id: 5, name: 'Snack', icon: Icons.fastfood_outlined, state: 'inactive'),
  Category(id: 6, name: 'Lunch', icon: Icons.lunch_dining_outlined, state: 'inactive'),
  Category(id: 7, name: 'Dinner', icon: Icons.dinner_dining_outlined, state: 'inactive'),
  Category(id: 8, name: 'Breakfast', icon: Icons.breakfast_dining_outlined, state: 'inactive'),
  Category(id: 9, name: 'Fruit', icon: Icons.emoji_food_beverage_outlined, state: 'inactive'),
  Category(id: 10, name: 'Veg', icon: Icons.grass_outlined, state: 'inactive'),
  Category(id: 100, name: 'Biscuit', icon: Icons.cookie_outlined, state: 'inactive'),

  // Transport
  Category(id: 11, name: 'Bus', icon: Icons.directions_bus_outlined, state: 'inactive'),
  Category(id: 12, name: 'Taxi', icon: Icons.local_taxi_outlined, state: 'inactive'),
  Category(id: 13, name: 'Fuel', icon: Icons.local_gas_station_outlined, state: 'inactive'),
  Category(id: 14, name: 'Parking', icon: Icons.local_parking_outlined, state: 'inactive'),
  Category(id: 15, name: 'Train', icon: Icons.train_outlined, state: 'inactive'),
  Category(id: 16, name: 'Flight', icon: Icons.flight_outlined, state: 'inactive'),
  Category(id: 17, name: 'Bike', icon: Icons.pedal_bike_outlined, state: 'inactive'),
  Category(id: 18, name: 'Car', icon: Icons.directions_car_outlined, state: 'inactive'),
  Category(id: 19, name: 'Ride', icon: Icons.emoji_transportation_outlined, state: 'inactive'),
  Category(id: 20, name: 'Ship', icon: Icons.directions_boat_outlined, state: 'inactive'),

  // Bills & Utilities
  Category(id: 21, name: 'Electric', icon: Icons.electrical_services_outlined, state: 'inactive'),
  Category(id: 22, name: 'Water', icon: Icons.water_outlined, state: 'inactive'),
  Category(id: 23, name: 'Internet', icon: Icons.wifi_outlined, state: 'inactive'),
  Category(id: 24, name: 'Gas', icon: Icons.local_gas_station_outlined, state: 'inactive'),
  Category(id: 25, name: 'Rent', icon: Icons.house_outlined, state: 'inactive'),
  Category(id: 26, name: 'Phone', icon: Icons.phone_outlined, state: 'inactive'),
  Category(id: 27, name: 'Cable', icon: Icons.tv_outlined, state: 'inactive'),
  Category(id: 28, name: 'Trash', icon: Icons.delete_outline, state: 'inactive'),
  Category(id: 29, name: 'Loan', icon: Icons.account_balance_outlined, state: 'inactive'),
  Category(id: 30, name: 'Tax', icon: Icons.receipt_long_outlined, state: 'inactive'),

  // Shopping
  Category(id: 31, name: 'Clothes', icon: Icons.checkroom_outlined, state: 'inactive'),
  Category(id: 32, name: 'Shoes', icon: Icons.shopping_bag_outlined, state: 'inactive'),
  Category(id: 33, name: 'Gifts', icon: Icons.card_giftcard_outlined, state: 'inactive'),
  Category(id: 34, name: 'Books', icon: Icons.menu_book_outlined, state: 'inactive'),
  Category(id: 35, name: 'Grocery', icon: Icons.shopping_cart_outlined, state: 'inactive'),
  Category(id: 36, name: 'Tech', icon: Icons.devices_outlined, state: 'inactive'),
  Category(id: 37, name: 'Jewelry', icon: Icons.watch_outlined, state: 'inactive'),
  Category(id: 38, name: 'Beauty', icon: Icons.brush_outlined, state: 'inactive'),
  Category(id: 39, name: 'Toy', icon: Icons.toys_outlined, state: 'inactive'),
  Category(id: 40, name: 'Music', icon: Icons.music_note_outlined, state: 'inactive'),

  // Entertainment
  Category(id: 41, name: 'Movie', icon: Icons.movie_outlined, state: 'inactive'),
  Category(id: 42, name: 'Games', icon: Icons.sports_esports_outlined, state: 'inactive'),
  Category(id: 43, name: 'Sport', icon: Icons.sports_soccer_outlined, state: 'inactive'),
  Category(id: 44, name: 'Show', icon: Icons.tv_outlined, state: 'inactive'),
  Category(id: 45, name: 'Park', icon: Icons.park_outlined, state: 'inactive'),
  Category(id: 46, name: 'Event', icon: Icons.event_outlined, state: 'inactive'),
  Category(id: 47, name: 'Party', icon: Icons.cake_outlined, state: 'inactive'),
  Category(id: 48, name: 'Bar', icon: Icons.local_bar_outlined, state: 'inactive'),
  Category(id: 49, name: 'Club', icon: Icons.sports_bar_outlined, state: 'inactive'),
  Category(id: 50, name: 'Beach', icon: Icons.beach_access_outlined, state: 'inactive'),

  // Health & Fitness
  Category(id: 51, name: 'Gym', icon: Icons.fitness_center_outlined, state: 'inactive'),
  Category(id: 52, name: 'Doctor', icon: Icons.medical_services_outlined, state: 'inactive'),
  Category(id: 53, name: 'Pharma', icon: Icons.local_pharmacy_outlined, state: 'inactive'),
  Category(id: 54, name: 'Yoga', icon: Icons.self_improvement_outlined, state: 'inactive'),
  Category(id: 55, name: 'Dentist', icon: Icons.health_and_safety_outlined, state: 'inactive'),
  Category(id: 56, name: 'Spa', icon: Icons.spa_outlined, state: 'inactive'),
  Category(id: 57, name: 'Mask', icon: Icons.masks_outlined, state: 'inactive'),
  Category(id: 58, name: 'Therapy', icon: Icons.psychology_outlined, state: 'inactive'),
  Category(id: 59, name: 'Walk', icon: Icons.directions_walk_outlined, state: 'inactive'),
  Category(id: 60, name: 'Run', icon: Icons.directions_run_outlined, state: 'inactive'),

  // Finance & Money
  Category(id: 61, name: 'Salary', icon: Icons.attach_money_outlined, state: 'inactive'),
  Category(id: 62, name: 'Bonus', icon: Icons.money_outlined, state: 'inactive'),
  Category(id: 63, name: 'Saving', icon: Icons.account_balance_wallet_outlined, state: 'inactive'),
  Category(id: 64, name: 'Bank', icon: Icons.account_balance_outlined, state: 'inactive'),
  Category(id: 65, name: 'Cash', icon: Icons.money_off_outlined, state: 'inactive'),
  Category(id: 66, name: 'Card', icon: Icons.credit_card_outlined, state: 'inactive'),
  Category(id: 67, name: 'Debt', icon: Icons.cancel_outlined, state: 'inactive'),
  Category(id: 68, name: 'Pay', icon: Icons.payment_outlined, state: 'inactive'),
  Category(id: 69, name: 'Loan', icon: Icons.account_balance_outlined, state: 'inactive'),
  Category(id: 70, name: 'Tax', icon: Icons.receipt_long_outlined, state: 'inactive'),

  // Travel
  Category(id: 71, name: 'Hotel', icon: Icons.hotel_outlined, state: 'inactive'),
  Category(id: 72, name: 'Trip', icon: Icons.card_travel_outlined, state: 'inactive'),
  Category(id: 73, name: 'Flight', icon: Icons.flight_outlined, state: 'inactive'),
  Category(id: 74, name: 'Train', icon: Icons.train_outlined, state: 'inactive'),
  Category(id: 75, name: 'Bus', icon: Icons.directions_bus_outlined, state: 'inactive'),
  Category(id: 76, name: 'Taxi', icon: Icons.local_taxi_outlined, state: 'inactive'),
  Category(id: 77, name: 'Bike', icon: Icons.pedal_bike_outlined, state: 'inactive'),
  Category(id: 78, name: 'Car', icon: Icons.directions_car_outlined, state: 'inactive'),
  Category(id: 79, name: 'Beach', icon: Icons.beach_access_outlined, state: 'inactive'),
  Category(id: 80, name: 'Park', icon: Icons.park_outlined, state: 'inactive'),

  // Pets
  Category(id: 81, name: 'Dog', icon: Icons.pets_outlined, state: 'inactive'),
  Category(id: 82, name: 'Cat', icon: Icons.pets_outlined, state: 'inactive'),
  Category(id: 83, name: 'PetCare', icon: Icons.health_and_safety_outlined, state: 'inactive'),
  Category(id: 84, name: 'Vet', icon: Icons.medical_services_outlined, state: 'inactive'),

  // Education
  Category(id: 85, name: 'School', icon: Icons.school_outlined, state: 'inactive'),
  Category(id: 86, name: 'College', icon: Icons.menu_book_outlined, state: 'inactive'),
  Category(id: 87, name: 'Tuition', icon: Icons.book_outlined, state: 'inactive'),
  Category(id: 88, name: 'Study', icon: Icons.menu_book_outlined, state: 'inactive'),
  Category(id: 89, name: 'Exam', icon: Icons.fact_check_outlined, state: 'inactive'),

  // Miscellaneous
  Category(id: 90, name: 'Gift', icon: Icons.card_giftcard_outlined, state: 'inactive'),
  Category(id: 91, name: 'Charity', icon: Icons.volunteer_activism_outlined, state: 'inactive'),
  Category(id: 92, name: 'Tool', icon: Icons.build_outlined, state: 'inactive'),
  Category(id: 93, name: 'Art', icon: Icons.brush_outlined, state: 'inactive'),
  Category(id: 94, name: 'Photo', icon: Icons.camera_alt_outlined, state: 'inactive'),
  Category(id: 95, name: 'Music', icon: Icons.music_note_outlined, state: 'inactive'),
  Category(id: 96, name: 'Event', icon: Icons.event_outlined, state: 'inactive'),
  Category(id: 97, name: 'Party', icon: Icons.cake_outlined, state: 'inactive'),
  Category(id: 98, name: 'Office', icon: Icons.apartment_outlined, state: 'inactive'),
  Category(id: 99, name: 'Work', icon: Icons.work_outline, state: 'inactive'),

  Category(id: 101, name: 'Shopping', icon: Icons.shopping_bag_outlined, state: 'inactive'),


  Category(id: 102, name: 'Other', icon: Icons.query_stats_outlined, state: 'inactive'),
];
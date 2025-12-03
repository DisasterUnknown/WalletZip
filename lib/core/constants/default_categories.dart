import 'package:expenso/data/models/category.dart';
import 'package:flutter/material.dart';

final List<Category> categories = [
  // ID 1-12: Food & Drinks
  Category(id: 1, name: 'Food', icon: Icons.restaurant_menu_outlined, state: 'inactive'),
  Category(id: 2, name: 'Coffee', icon: Icons.coffee_outlined, state: 'inactive'),
  Category(id: 3, name: 'Tea', icon: Icons.local_cafe_outlined, state: 'inactive'),
  Category(id: 4, name: 'Snack', icon: Icons.fastfood_outlined, state: 'inactive'),
  Category(id: 5, name: 'Dinner', icon: Icons.dinner_dining_outlined, state: 'inactive'),
  Category(id: 6, name: 'Breakfast', icon: Icons.breakfast_dining_outlined, state: 'inactive'),
  Category(id: 7, name: 'Biscuit', icon: Icons.cookie_outlined, state: 'inactive'),
  Category(id: 8, name: 'IceCream', icon: Icons.icecream_outlined, state: 'inactive'),
  Category(id: 9, name: 'Pizza', icon: Icons.local_pizza_outlined, state: 'inactive'),
  Category(id: 10, name: 'Dessert', icon: Icons.cake_outlined, state: 'inactive'),
  Category(id: 11, name: 'Seafood', icon: Icons.set_meal_outlined, state: 'inactive'),
  Category(id: 12, name: 'Meat', icon: Icons.egg_alt_outlined, state: 'inactive'),

  // ID 13-22: Transport
  Category(id: 13, name: 'Bus', icon: Icons.directions_bus_outlined, state: 'inactive'),
  Category(id: 14, name: 'Taxi', icon: Icons.local_taxi_outlined, state: 'inactive'),
  Category(id: 15, name: 'Fuel', icon: Icons.local_gas_station_outlined, state: 'inactive'),
  Category(id: 16, name: 'Parking', icon: Icons.local_parking_outlined, state: 'inactive'),
  Category(id: 17, name: 'Train', icon: Icons.train_outlined, state: 'inactive'),
  Category(id: 18, name: 'Flight', icon: Icons.flight_outlined, state: 'inactive'),
  Category(id: 19, name: 'Bike', icon: Icons.pedal_bike_outlined, state: 'inactive'),
  Category(id: 20, name: 'Car', icon: Icons.directions_car_outlined, state: 'inactive'),
  Category(id: 21, name: 'Metro', icon: Icons.subway_outlined, state: 'inactive'),
  Category(id: 22, name: 'Scooter', icon: Icons.electric_scooter_outlined, state: 'inactive'),

  // ID 23-28: Bills & Utilities
  Category(id: 23, name: 'Electric', icon: Icons.electrical_services_outlined, state: 'inactive'),
  Category(id: 24, name: 'Water', icon: Icons.water_outlined, state: 'inactive'),
  Category(id: 25, name: 'Internet', icon: Icons.wifi_outlined, state: 'inactive'),
  Category(id: 26, name: 'Rent', icon: Icons.house_outlined, state: 'inactive'),
  Category(id: 27, name: 'Phone', icon: Icons.phone_outlined, state: 'inactive'),
  Category(id: 28, name: 'Trash', icon: Icons.delete_outline, state: 'inactive'),

  // ID 29-35: Shopping
  Category(id: 29, name: 'Clothes', icon: Icons.checkroom_outlined, state: 'inactive'),
  Category(id: 30, name: 'Gifts', icon: Icons.card_giftcard_outlined, state: 'inactive'),
  Category(id: 31, name: 'Books', icon: Icons.menu_book_outlined, state: 'inactive'),
  Category(id: 32, name: 'Tech', icon: Icons.devices_outlined, state: 'inactive'),
  Category(id: 33, name: 'Jewelry', icon: Icons.watch_outlined, state: 'inactive'),
  Category(id: 34, name: 'Beauty', icon: Icons.brush_outlined, state: 'inactive'),
  Category(id: 35, name: 'Toy', icon: Icons.toys_outlined, state: 'inactive'),

  // ID 36-42: Entertainment
  Category(id: 36, name: 'Movie', icon: Icons.movie_outlined, state: 'inactive'),
  Category(id: 37, name: 'Games', icon: Icons.sports_esports_outlined, state: 'inactive'),
  Category(id: 38, name: 'Sport', icon: Icons.sports_soccer_outlined, state: 'inactive'),
  Category(id: 39, name: 'Event', icon: Icons.event_outlined, state: 'inactive'),
  Category(id: 40, name: 'Bar', icon: Icons.local_bar_outlined, state: 'inactive'),
  Category(id: 41, name: 'Concert', icon: Icons.music_note_outlined, state: 'inactive'),
  Category(id: 42, name: 'Museum', icon: Icons.museum_outlined, state: 'inactive'),

  // ID 43-48: Health & Fitness
  Category(id: 43, name: 'Gym', icon: Icons.fitness_center_outlined, state: 'inactive'),
  Category(id: 44, name: 'Yoga', icon: Icons.self_improvement_outlined, state: 'inactive'),
  Category(id: 45, name: 'Dentist', icon: Icons.health_and_safety_outlined, state: 'inactive'),
  Category(id: 46, name: 'Spa', icon: Icons.spa_outlined, state: 'inactive'),
  Category(id: 47, name: 'Therapy', icon: Icons.psychology_outlined, state: 'inactive'),
  Category(id: 48, name: 'Run', icon: Icons.directions_run_outlined, state: 'inactive'),

  // ID 49-54: Finance & Money
  Category(id: 49, name: 'Salary', icon: Icons.attach_money_outlined, state: 'inactive'),
  Category(id: 50, name: 'Card', icon: Icons.credit_card_outlined, state: 'inactive'),
  Category(id: 51, name: 'Debt', icon: Icons.cancel_outlined, state: 'inactive'),
  Category(id: 52, name: 'Loan', icon: Icons.account_balance_outlined, state: 'inactive'),
  Category(id: 53, name: 'Tax', icon: Icons.receipt_long_outlined, state: 'inactive'),
  Category(id: 54, name: 'Crypto', icon: Icons.currency_bitcoin_outlined, state: 'inactive'),

  // ID 55-60: Travel
  Category(id: 55, name: 'Hotel', icon: Icons.hotel_outlined, state: 'inactive'),
  Category(id: 56, name: 'Trip', icon: Icons.card_travel_outlined, state: 'inactive'),
  Category(id: 57, name: 'Beach', icon: Icons.beach_access_outlined, state: 'inactive'),
  Category(id: 58, name: 'Park', icon: Icons.park_outlined, state: 'inactive'),
  Category(id: 59, name: 'Mountain', icon: Icons.terrain_outlined, state: 'inactive'),
  Category(id: 60, name: 'Backpack', icon: Icons.hiking_outlined, state: 'inactive'),

  // ID 61-65: Pets
  Category(id: 61, name: 'Dog', icon: Icons.pets_outlined, state: 'inactive'),
  Category(id: 62, name: 'PetCare', icon: Icons.health_and_safety_outlined, state: 'inactive'),
  Category(id: 63, name: 'Vet', icon: Icons.medical_services_outlined, state: 'inactive'),
  Category(id: 64, name: 'Fish', icon: Icons.foundation_outlined, state: 'inactive'),
  Category(id: 65, name: 'PetFood', icon: Icons.restaurant_menu_outlined, state: 'inactive'),

  // ID 66-70: Education
  Category(id: 66, name: 'School', icon: Icons.school_outlined, state: 'inactive'),
  Category(id: 67, name: 'College', icon: Icons.menu_book_outlined, state: 'inactive'),
  Category(id: 68, name: 'Tuition', icon: Icons.book_outlined, state: 'inactive'),
  Category(id: 69, name: 'Exam', icon: Icons.fact_check_outlined, state: 'inactive'),
  Category(id: 70, name: 'NetCourse', icon: Icons.computer_outlined, state: 'inactive'),

  // ID 71-81: Miscellaneous
  Category(id: 71, name: 'Charity', icon: Icons.volunteer_activism_outlined, state: 'inactive'),
  Category(id: 72, name: 'Art', icon: Icons.brush_outlined, state: 'inactive'),
  Category(id: 73, name: 'Photo', icon: Icons.camera_alt_outlined, state: 'inactive'),
  Category(id: 74, name: 'Work', icon: Icons.work_outline, state: 'inactive'),
  Category(id: 75, name: 'Family', icon: Icons.family_restroom_outlined, state: 'inactive'),
  Category(id: 76, name: 'Subscribe', icon: Icons.subscriptions_outlined, state: 'inactive'),
  Category(id: 77, name: 'Repair', icon: Icons.handyman_outlined, state: 'inactive'),
  Category(id: 78, name: 'Garden', icon: Icons.yard_outlined, state: 'inactive'),
  Category(id: 79, name: 'Cleaning', icon: Icons.cleaning_services_outlined, state: 'inactive'),
  Category(id: 80, name: 'Insurance', icon: Icons.verified_user_outlined, state: 'inactive'),
  Category(id: 81, name: 'Medicine', icon: Icons.medication_outlined, state: 'inactive'),

  // ID 82-88: Electronics & Tech
  Category(id: 82, name: 'Laptop', icon: Icons.laptop_mac_outlined, state: 'inactive'),
  Category(id: 83, name: 'Mobile', icon: Icons.smartphone_outlined, state: 'inactive'),
  Category(id: 84, name: 'Stationery', icon: Icons.create_outlined, state: 'inactive'),
  Category(id: 85, name: 'Furniture', icon: Icons.weekend_outlined, state: 'inactive'),
  Category(id: 86, name: 'Lighting', icon: Icons.light_outlined, state: 'inactive'),
  Category(id: 87, name: 'Streaming', icon: Icons.live_tv_outlined, state: 'inactive'),
  Category(id: 88, name: 'Podcast', icon: Icons.podcasts_outlined, state: 'inactive'),

  // ID 89-95: Outdoor & Hobby
  Category(id: 89, name: 'Hiking', icon: Icons.hiking_outlined, state: 'inactive'),
  Category(id: 90, name: 'Camping', icon: Icons.cabin_outlined, state: 'inactive'),
  Category(id: 91, name: 'Hobby', icon: Icons.camera_roll_outlined, state: 'inactive'),
  Category(id: 92, name: 'Laundry', icon: Icons.local_laundry_service_outlined, state: 'inactive'),
  Category(id: 93, name: 'Delivery', icon: Icons.delivery_dining_outlined, state: 'inactive'),
  Category(id: 94, name: 'Software', icon: Icons.developer_mode_outlined, state: 'inactive'),
  Category(id: 95, name: 'Ads', icon: Icons.campaign_outlined, state: 'inactive'),

  // ID 96-97: Home & Lifestyle
  Category(id: 96, name: 'Bathroom', icon: Icons.bathtub_outlined, state: 'inactive'),
  Category(id: 97, name: 'Garage', icon: Icons.garage_outlined, state: 'inactive'),

  // ID 98-102: Fitness & Sports
  Category(id: 98, name: 'Basketball', icon: Icons.sports_basketball_outlined, state: 'inactive'),
  Category(id: 99, name: 'Tennis', icon: Icons.sports_tennis_outlined, state: 'inactive'),
  Category(id: 100, name: 'Cricket', icon: Icons.sports_cricket_outlined, state: 'inactive'),
  Category(id: 101, name: 'Painting', icon: Icons.format_paint_outlined, state: 'inactive'),
  Category(id: 102, name: 'Hunting', icon: Icons.forest_outlined, state: 'inactive'),

  // Final 'Other' Category
  Category(id: 999, name: 'Other', icon: Icons.query_stats_outlined, state: 'inactive'),
];
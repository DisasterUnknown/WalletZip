import 'package:expenso/data/models/category.dart';
import 'package:flutter/material.dart';

final List<Category> categories = [
  // Food & Drinks
  Category(id: 1, name: 'Food', icon: Icons.restaurant_menu_outlined, state: 'inactive'),
  Category(id: 3, name: 'Coffee', icon: Icons.coffee_outlined, state: 'inactive'),
  Category(id: 4, name: 'Tea', icon: Icons.local_cafe_outlined, state: 'inactive'),
  Category(id: 5, name: 'Snack', icon: Icons.fastfood_outlined, state: 'inactive'),
  Category(id: 7, name: 'Dinner', icon: Icons.dinner_dining_outlined, state: 'inactive'),
  Category(id: 8, name: 'Breakfast', icon: Icons.breakfast_dining_outlined, state: 'inactive'),
  Category(id: 11, name: 'Biscuit', icon: Icons.cookie_outlined, state: 'inactive'),
  Category(id: 12, name: 'IceCream', icon: Icons.icecream_outlined, state: 'inactive'),
  Category(id: 16, name: 'Pizza', icon: Icons.local_pizza_outlined, state: 'inactive'),
  Category(id: 18, name: 'Dessert', icon: Icons.cake_outlined, state: 'inactive'),
  Category(id: 20, name: 'Seafood', icon: Icons.set_meal_outlined, state: 'inactive'),
  Category(id: 21, name: 'Meat', icon: Icons.set_meal_outlined, state: 'inactive'),

  // Transport
  Category(id: 22, name: 'Bus', icon: Icons.directions_bus_outlined, state: 'inactive'),
  Category(id: 23, name: 'Taxi', icon: Icons.local_taxi_outlined, state: 'inactive'),
  Category(id: 24, name: 'Fuel', icon: Icons.local_gas_station_outlined, state: 'inactive'),
  Category(id: 25, name: 'Parking', icon: Icons.local_parking_outlined, state: 'inactive'),
  Category(id: 26, name: 'Train', icon: Icons.train_outlined, state: 'inactive'),
  Category(id: 27, name: 'Flight', icon: Icons.flight_outlined, state: 'inactive'),
  Category(id: 28, name: 'Bike', icon: Icons.pedal_bike_outlined, state: 'inactive'),
  Category(id: 29, name: 'Car', icon: Icons.directions_car_outlined, state: 'inactive'),
  Category(id: 32, name: 'Metro', icon: Icons.subway_outlined, state: 'inactive'),
  Category(id: 33, name: 'Scooter', icon: Icons.electric_scooter_outlined, state: 'inactive'),

  // Bills & Utilities
  Category(id: 37, name: 'Electric', icon: Icons.electrical_services_outlined, state: 'inactive'),
  Category(id: 38, name: 'Water', icon: Icons.water_outlined, state: 'inactive'),
  Category(id: 39, name: 'Internet', icon: Icons.wifi_outlined, state: 'inactive'),
  Category(id: 41, name: 'Rent', icon: Icons.house_outlined, state: 'inactive'),
  Category(id: 42, name: 'Phone', icon: Icons.phone_outlined, state: 'inactive'),
  Category(id: 44, name: 'Trash', icon: Icons.delete_outline, state: 'inactive'),

  // Shopping
  Category(id: 45, name: 'Clothes', icon: Icons.checkroom_outlined, state: 'inactive'),
  Category(id: 47, name: 'Gifts', icon: Icons.card_giftcard_outlined, state: 'inactive'),
  Category(id: 48, name: 'Books', icon: Icons.menu_book_outlined, state: 'inactive'),
  Category(id: 50, name: 'Tech', icon: Icons.devices_outlined, state: 'inactive'),
  Category(id: 51, name: 'Jewelry', icon: Icons.watch_outlined, state: 'inactive'),
  Category(id: 52, name: 'Beauty', icon: Icons.brush_outlined, state: 'inactive'),
  Category(id: 53, name: 'Toy', icon: Icons.toys_outlined, state: 'inactive'),

  // Entertainment
  Category(id: 57, name: 'Movie', icon: Icons.movie_outlined, state: 'inactive'),
  Category(id: 58, name: 'Games', icon: Icons.sports_esports_outlined, state: 'inactive'),
  Category(id: 59, name: 'Sport', icon: Icons.sports_soccer_outlined, state: 'inactive'),
  Category(id: 61, name: 'Event', icon: Icons.event_outlined, state: 'inactive'),
  Category(id: 63, name: 'Bar', icon: Icons.local_bar_outlined, state: 'inactive'),
  Category(id: 65, name: 'Concert', icon: Icons.music_note_outlined, state: 'inactive'),
  Category(id: 67, name: 'Museum', icon: Icons.museum_outlined, state: 'inactive'),

  // Health & Fitness
  Category(id: 68, name: 'Gym', icon: Icons.fitness_center_outlined, state: 'inactive'),
  Category(id: 71, name: 'Yoga', icon: Icons.self_improvement_outlined, state: 'inactive'),
  Category(id: 72, name: 'Dentist', icon: Icons.health_and_safety_outlined, state: 'inactive'),
  Category(id: 73, name: 'Spa', icon: Icons.spa_outlined, state: 'inactive'),
  Category(id: 75, name: 'Therapy', icon: Icons.psychology_outlined, state: 'inactive'),
  Category(id: 77, name: 'Run', icon: Icons.directions_run_outlined, state: 'inactive'),

  // Finance & Money
  Category(id: 84, name: 'Salary', icon: Icons.attach_money_outlined, state: 'inactive'),
  Category(id: 89, name: 'Card', icon: Icons.credit_card_outlined, state: 'inactive'),
  Category(id: 90, name: 'Debt', icon: Icons.cancel_outlined, state: 'inactive'),
  Category(id: 92, name: 'Loan', icon: Icons.account_balance_outlined, state: 'inactive'),
  Category(id: 93, name: 'Tax', icon: Icons.receipt_long_outlined, state: 'inactive'),
  Category(id: 97, name: 'Crypto', icon: Icons.currency_bitcoin_outlined, state: 'inactive'),

  // Travel
  Category(id: 98, name: 'Hotel', icon: Icons.hotel_outlined, state: 'inactive'),
  Category(id: 99, name: 'Trip', icon: Icons.card_travel_outlined, state: 'inactive'),
  Category(id: 100, name: 'Beach', icon: Icons.beach_access_outlined, state: 'inactive'),
  Category(id: 101, name: 'Park', icon: Icons.park_outlined, state: 'inactive'),
  Category(id: 104, name: 'Mountain', icon: Icons.terrain_outlined, state: 'inactive'),
  Category(id: 106, name: 'Backpack', icon: Icons.hiking_outlined, state: 'inactive'),

  // Pets
  Category(id: 107, name: 'Dog', icon: Icons.pets_outlined, state: 'inactive'),
  Category(id: 109, name: 'PetCare', icon: Icons.health_and_safety_outlined, state: 'inactive'),
  Category(id: 110, name: 'Vet', icon: Icons.medical_services_outlined, state: 'inactive'),
  Category(id: 112, name: 'Fish', icon: Icons.foundation_outlined, state: 'inactive'),
  Category(id: 113, name: 'PetFood', icon: Icons.restaurant_menu_outlined, state: 'inactive'),

  // Education
  Category(id: 114, name: 'School', icon: Icons.school_outlined, state: 'inactive'),
  Category(id: 115, name: 'College', icon: Icons.menu_book_outlined, state: 'inactive'),
  Category(id: 116, name: 'Tuition', icon: Icons.book_outlined, state: 'inactive'),
  Category(id: 118, name: 'Exam', icon: Icons.fact_check_outlined, state: 'inactive'),
  Category(id: 119, name: 'NetCourse', icon: Icons.computer_outlined, state: 'inactive'),

  // Miscellaneous
  Category(id: 122, name: 'Charity', icon: Icons.volunteer_activism_outlined, state: 'inactive'),
  Category(id: 124, name: 'Art', icon: Icons.brush_outlined, state: 'inactive'),
  Category(id: 125, name: 'Photo', icon: Icons.camera_alt_outlined, state: 'inactive'),
  Category(id: 128, name: 'Work', icon: Icons.work_outline, state: 'inactive'),
  Category(id: 130, name: 'Family', icon: Icons.family_restroom_outlined, state: 'inactive'),
  Category(id: 132, name: 'Subscribe', icon: Icons.subscriptions_outlined, state: 'inactive'),
  Category(id: 133, name: 'Repair', icon: Icons.handyman_outlined, state: 'inactive'),
  Category(id: 136, name: 'Garden', icon: Icons.yard_outlined, state: 'inactive'),
  Category(id: 137, name: 'Cleaning', icon: Icons.cleaning_services_outlined, state: 'inactive'),
  Category(id: 142, name: 'Insurance', icon: Icons.verified_user_outlined, state: 'inactive'),
  Category(id: 144, name: 'Medicine', icon: Icons.medication_outlined, state: 'inactive'),

  // Electronics & Tech
  Category(id: 152, name: 'Laptop', icon: Icons.laptop_mac_outlined, state: 'inactive'),
  Category(id: 153, name: 'Mobile', icon: Icons.smartphone_outlined, state: 'inactive'),
  Category(id: 156, name: 'Stationery', icon: Icons.create_outlined, state: 'inactive'),
  Category(id: 158, name: 'Furniture', icon: Icons.weekend_outlined, state: 'inactive'),
  Category(id: 160, name: 'Lighting', icon: Icons.light_outlined, state: 'inactive'),
  Category(id: 161, name: 'Streaming', icon: Icons.live_tv_outlined, state: 'inactive'),
  Category(id: 163, name: 'Podcast', icon: Icons.podcasts_outlined, state: 'inactive'),

  // Outdoor & Hobby
  Category(id: 164, name: 'Hiking', icon: Icons.hiking_outlined, state: 'inactive'),
  Category(id: 165, name: 'Camping', icon: Icons.cabin_outlined, state: 'inactive'),
  Category(id: 167, name: 'Hobby', icon: Icons.camera_roll_outlined, state: 'inactive'),
  Category(id: 171, name: 'Laundry', icon: Icons.local_laundry_service_outlined, state: 'inactive'),
  Category(id: 173, name: 'Delivery', icon: Icons.delivery_dining_outlined, state: 'inactive'),
  Category(id: 177, name: 'Software', icon: Icons.developer_mode_outlined, state: 'inactive'),
  Category(id: 178, name: 'Ads', icon: Icons.campaign_outlined, state: 'inactive'),

  // Home & Lifestyle
  Category(id: 184, name: 'Bathroom', icon: Icons.bathtub_outlined, state: 'inactive'),
  Category(id: 185, name: 'Garage', icon: Icons.garage_outlined, state: 'inactive'),

  // Fitness & Sports (Unique/Shortened)
  Category(id: 192, name: 'Basketball', icon: Icons.sports_basketball_outlined, state: 'inactive'),
  Category(id: 193, name: 'Tennis', icon: Icons.sports_tennis_outlined, state: 'inactive'),
  Category(id: 194, name: 'Cricket', icon: Icons.sports_cricket_outlined, state: 'inactive'),
  Category(id: 201, name: 'Painting', icon: Icons.format_paint_outlined, state: 'inactive'),
  Category(id: 212, name: 'Hunting', icon: Icons.forest_outlined, state: 'inactive'),

  // Final 'Other' Category
  Category(id: 999, name: 'Other', icon: Icons.query_stats_outlined, state: 'inactive'),
];
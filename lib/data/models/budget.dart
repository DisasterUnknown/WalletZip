class Budget {
  int? id;
  double amount; // amount according to type
  int month;
  int year;
  String type; // "Monthly", "Yearly", or "Daily"

  Budget({
    this.id,
    required this.amount,
    required this.month,
    required this.year,
    this.type = "monthly", // default to Monthly
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "amount": amount,
      "month": month,
      "year": year,
      "type": type,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map["id"],
      amount: map["amount"],
      month: map["month"],
      year: map["year"],
      type: map["type"] ?? "monthly",
    );
  }
}

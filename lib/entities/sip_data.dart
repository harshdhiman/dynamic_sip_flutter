import 'dart:convert';

class SIPData {
  final String date;
  final int equity;
  final String point;
  final String sensex;
  SIPData({
    required this.date,
    required this.equity,
    required this.point,
    required this.sensex,
  });

  /* Generated Code */

  SIPData copyWith({
    String? date,
    int? equity,
    String? point,
    String? sensex,
  }) {
    return SIPData(
      date: date ?? this.date,
      equity: equity ?? this.equity,
      point: point ?? this.point,
      sensex: sensex ?? this.sensex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'equity': equity,
      'point': point,
      'sensex': sensex,
    };
  }

  factory SIPData.fromMap(Map rmap) {
    final map = Map.from(rmap).cast<String, dynamic>();
    return SIPData(
      date: map['date'] ?? '',
      equity: int.tryParse(map['equity']) ?? 0,
      point: map['point'] ?? '',
      sensex: map['sensex'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SIPData.fromJson(String source) => SIPData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SIPData(date: $date, equity: $equity, point: $point, sensex: $sensex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SIPData &&
        other.date == date &&
        other.equity == equity &&
        other.point == point &&
        other.sensex == sensex;
  }

  @override
  int get hashCode {
    return date.hashCode ^ equity.hashCode ^ point.hashCode ^ sensex.hashCode;
  }
}

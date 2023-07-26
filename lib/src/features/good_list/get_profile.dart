import 'dart:developer' as developer;

class GetProfile {
  GetProfile(
      {required this.id,
      required this.brand,
      required this.item_type,
      required this.size,
      required this.count,
      required this.inven_count,
      required this.good_pic,
      required this.total_count});

  final String id; // email
  final String brand;
  final String item_type;
  final String total_count;
  final String count;
  final String inven_count;
  final String good_pic;
  final String size;

  factory GetProfile.fromMap(Map<String, dynamic> data) {
    final result = data['result'];

    return GetProfile(
      id: result['id'].toString(),
      brand: result['brand'],
      item_type: result['item_type'],
      total_count: result['total_count'].toString(),
      size: result['size'].toString(),
      good_pic: result['good_pic'],
      count: result['count'].toString(),
      inven_count: result['inven_count'].toString(),
    );
  }
  @override
  String toString() =>
      'GetProfile(id: $id, brand: $brand, item_type: $item_type, total_count: $total_count , size: $size, good_pic: $good_pic, count: $count, inven_count: $inven_count)';
}

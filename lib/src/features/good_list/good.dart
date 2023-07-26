import 'package:intl/intl.dart';

import 'package:recleatapp/src/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class Good {
  const Good({
    required this.id,
    required this.brand,
    required this.size,
    required this.item_type,
    required this.good_pic,
    required this.count,
    required this.name,
    required this.email,
    required this.school_id,
    required this.inven_count,
    required this.total_count,
    required this.list_id,
  });

  final String id;
  final String brand;
  final String size;
  final String item_type;
  final String good_pic;
  final String count;
  final String name;
  final String email;
  final String school_id;
  final String inven_count;
  final String total_count;
  final String list_id;

  factory Good.fromMap(Map<String, dynamic> data) {
    return Good(
      id: data['id'].toString(),
      brand: data['brand'].toString(),
      size: data['size'].toString(),
      item_type: data['item_type'].toString(),
      good_pic: data['good_pic'].toString(),
      count: data['count'].toString(),
      name: data['name'].toString(),
      email: data['email'].toString(),
      school_id: data['school_id'].toString(),
      inven_count: data['inven_count'].toString(),
      total_count: data['total_count'].toString(),
      list_id: data['list_id'].toString(),
    );
  }

  @override
  String toString() => 'Inventory(id: $id, size: $size, '
      'count: $count, inven_count: $inven_count, total_count: $total_count, '
      'brand: $brand, size: $size, item_type: $item_type, good_pic: $good_pic,school_id: $school_id)'
      'name:$name, email:$email, list_id:$list_id';
}

typedef GoodList = List<Good>;

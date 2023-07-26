import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recleatapp/src/features/good_list/inventory.dart';
import 'package:recleatapp/src/model/dio_client.dart';
import 'package:recleatapp/src/features/auth/auth_repository.dart';
import 'package:recleatapp/src/widgets/dialogs.dart';

class InventoryRepository {
  InventoryRepository({required this.authRepo});

  final AuthRepository authRepo;
  InventoryList _inventorys = []; //InMemoryStore<NotifList>([]);

  Future<InventoryList> doFetchNotifs() async {
    //if (_notifs.isNotEmpty) {
    //  // notifications fetched already.
    //  return _notifs;
    //}

    dynamic data = await DioClient.postInventoryAll(authRepo.uid!);

    final result = data['result'];

    if (result is List) {
      _inventorys = result.map((data) => Inventory.fromMap(data)).toList();
      print('doFetchNotifs() src=${_inventorys.toString()}');

      return _inventorys;
    } else {
      return _inventorys;
    }
  }

  Future<InventoryList> getGoodDetail(String good_id) async {
    //if (_notifs.isNotEmpty) {
    //  // notifications fetched already.
    //  return _notifs;
    //}

    dynamic data = await DioClient.getGoodDetail(good_id);
    // print('listFetchNotifs() returned: $data');

    final result = data['result'];

    if (result is List) {
      try {
        _inventorys = result.map((data) => Inventory.fromMap(data)).toList();
        print('doFetchNotifs() src=${_inventorys.toString()}');
      } catch (e) {
        print('doFetchNotifs() error=$e');
      }
      return _inventorys;
    } else {
      showToastMessage("No data");

      throw UnimplementedError;
    }
  }
}

final InventroyProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(authRepo: ref.watch(authRepositoryProvider));
});

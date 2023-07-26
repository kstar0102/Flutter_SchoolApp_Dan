import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recleatapp/src/features/good_list/good.dart';
import 'package:recleatapp/src/model/dio_client.dart';
import 'package:recleatapp/src/features/auth/auth_repository.dart';
import 'package:recleatapp/src/widgets/dialogs.dart';

class GoodRepository {
  GoodRepository({required this.authRepo});

  final AuthRepository authRepo;
  GoodList _goods = []; //InMemoryStore<NotifList>([]);

  Future<GoodList> doGoodList() async {
    dynamic data = await DioClient.postGoodList(authRepo.aid!);

    final result = data['result'];

    if (result is List) {
      _goods = result.map((data) => Good.fromMap(data)).toList();

      return _goods;
    } else {
      return _goods;
    }
  }
}

final GoodProvider = Provider<GoodRepository>((ref) {
  return GoodRepository(authRepo: ref.watch(authRepositoryProvider));
});

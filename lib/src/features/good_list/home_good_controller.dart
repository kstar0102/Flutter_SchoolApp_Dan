import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recleatapp/src/features/good_list/inventory_repository.dart';
import 'package:recleatapp/src/features/good_list/inventory.dart';
import 'package:recleatapp/src/features/good_list/inventory_repository.dart';

class HomeGoodController extends StateNotifier<AsyncValue<InventoryList>> {
  HomeGoodController({required this.notifRepo}) : super(const AsyncData([]));

  final InventoryRepository notifRepo;

  Future<void> doFetchNotifs() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doFetchNotifs());
    if (mounted) {
      state = newState;
    }
    return;
  }

  Future<void> getGoodDetail(String good_id) async {
    state = const AsyncValue.loading();
    final newState =
        await AsyncValue.guard(() => notifRepo.getGoodDetail(good_id));
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final homeGoodProvider = StateNotifierProvider.autoDispose<HomeGoodController,
    AsyncValue<InventoryList>>((ref) {
  return HomeGoodController(notifRepo: ref.watch(InventroyProvider));
});

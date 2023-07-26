import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recleatapp/src/features/good_list/good_repository.dart';
import 'package:recleatapp/src/features/good_list/good.dart';

class AdminGoodController extends StateNotifier<AsyncValue<GoodList>> {
  AdminGoodController({required this.notifRepo}) : super(const AsyncData([]));

  final GoodRepository notifRepo;

  Future<void> doGoodList() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doGoodList());
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final AdminGoodProvider = StateNotifierProvider.autoDispose<AdminGoodController,
    AsyncValue<GoodList>>((ref) {
  return AdminGoodController(notifRepo: ref.watch(GoodProvider));
});

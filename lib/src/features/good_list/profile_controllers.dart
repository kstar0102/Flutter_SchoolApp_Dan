import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recleatapp/src/features/good_list/get_profile.dart';
import 'package:recleatapp/src/features/good_list/profile_repository.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

// * ---------------------------------------------------------------------------
// * HomeAccountController
// * ---------------------------------------------------------------------------

class HomeAccountController extends StateNotifier<AsyncValue<GetProfile?>> {
  HomeAccountController({required this.profileRepo})
      : super(const AsyncData(null));

  final ProfileRepository profileRepo;
  GetProfile? get currProfile => profileRepo.currProfile;

  Future<void> doGetProfile(String good_id) async {
    state = const AsyncValue.loading();
    final newState =
        await AsyncValue.guard(() => profileRepo.doGetProfile(good_id));
    if (mounted) {
      state = newState;
    }
  }
}

final homeAccountCtrProvider = StateNotifierProvider.autoDispose<
    HomeAccountController, AsyncValue<GetProfile?>>((ref) {
  return HomeAccountController(
      profileRepo: ref.watch(profileRepositoryProvider));
});

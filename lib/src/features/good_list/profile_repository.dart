import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recleatapp/src/exceptions/app_exception.dart';
import 'package:recleatapp/src/features/auth/auth_repository.dart';
import 'package:recleatapp/src/features/good_list/get_profile.dart';
import 'package:recleatapp/src/model/dio_client.dart';
import 'package:recleatapp/src/utils/in_memory_store.dart';

class ProfileRepository {
  ProfileRepository({required this.authRepo});

  final AuthRepository authRepo;
  //Profile? _profile;

  GetProfile? get currProfile => _profileState.value;

  final _profileState = InMemoryStore<GetProfile?>(null);
  Stream<GetProfile?> profileStateChanges() => _profileState.stream;

  // * -------------------------------------------------------------------------

  Future<GetProfile?> doGetProfile(String good_id) async {
    final data = await DioClient.getGoodDetail(good_id);

    try {
      GetProfile profileData = GetProfile.fromMap(data);
      print('doGetProfile222() returned: $profileData');
    } catch (e) {
      print('doGetProfile222() error=$e');
    }
    try {
      _profileState.value = GetProfile.fromMap(data);
    } catch (e) {
      developer.log('doGetProfile() error=$e');
    }
    return _profileState.value;
  }
}

final profileRepositoryProvider = StateProvider<ProfileRepository>((ref) {
  return ProfileRepository(authRepo: ref.watch(authRepositoryProvider));
});

final profileStateChangesProvider = StreamProvider<GetProfile?>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.profileStateChanges();
});

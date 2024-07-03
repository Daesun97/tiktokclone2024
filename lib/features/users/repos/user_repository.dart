import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/model/user_profile_model.dart';

//프로필 생성, get ,수정
class UserRepository {
  //데이터베이스에 접근
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection('users').doc(profile.uid).set(profile.toJson());
  }

  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> upLoadAvatar(File file, String fileName) async {
    //파일 넣을 공간(reference)만들고
    final fileRef = _storage.ref().child('avatars/$fileName');

    //파일 올림
    await fileRef.putFile(file);
  }

  Future<void> upUpdateAvatar(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }
}

final userRepo = Provider((ref) => UserRepository());

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/model/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineviewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _repository;
  List<VideoModel> _list = [];

  // void upLoadVideo() async {
  //   state = const AsyncValue.loading();
  //   await Future.delayed(const Duration(seconds: 3));
  //   // final newVideo = VideoModel(title: '${DateTime.now()}');
  //   _list = [..._list];
  //   state = AsyncValue.data(_list);
  // }

  Future<List<VideoModel>> _fetchVideos({int? lastItemCreatedAt}) async {
    final result = await _repository.fetchVideo(lastItemCreatedAt: null);
    //map은 리턴하는 모든 요소들로 부터 새로운 리스트를 생성해줌
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(json: doc.data(), videoId: doc.id),
    );
    return videos.toList();
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);

    _list = await _fetchVideos(lastItemCreatedAt: null);
    return _list;
  }

  Future<void> fetchNextPAge() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    state = AsyncValue.data([..._list, ...nextPage]);
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos(lastItemCreatedAt: null);
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final timeLineProvider =
    AsyncNotifierProvider<TimelineviewModel, List<VideoModel>>(
  () => TimelineviewModel(),
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/view/video_post.dart';
import 'package:tiktok_clone/features/videos/viewmodel/video_timeline_vm.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  final PageController _pageController = PageController();
  int _itemCount = 0;

  final Duration _scroolDuration = const Duration(microseconds: 300);
  final Curve _scrollCurve = Curves.linear;

  void _onPageChange(int page) {
    _pageController.animateToPage(
      page,
      duration: _scroolDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      ref.watch(timeLineProvider.notifier).fetchNextPAge();
    }
  }

//비디오가 긑나면 다시재생
  _onVideoFinshed() {
    return;
    //영상이 끝나면 다음으로 넘어가게 함
    // _pageController.nextPage(
    //   duration: _scroolDuration,
    //   curve: _scrollCurve,
    // );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    return ref.watch(timeLineProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timeLineProvider).when(
        error: (error, stackTrace) => Center(
              child: Text(
                '영상을 불러올수 없슴: $error',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (videos) {
          _itemCount = videos.length;
          return RefreshIndicator(
            displacement: 50,
            edgeOffset: 10,
            color: Theme.of(context).primaryColor,
            onRefresh: _onRefresh,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChange,
              itemCount: videos.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final videoData = videos[index];
                return VideoPost(
                    onVideoFinished: _onVideoFinshed,
                    index: index,
                    videoData: videoData);
              },
            ),
          );
        });
  }
}

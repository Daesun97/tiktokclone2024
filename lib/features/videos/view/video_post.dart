import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/common/widgets/video_config.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/model/video_model.dart';
import 'package:tiktok_clone/features/videos/viewmodel/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/viewmodel/video_post_vm.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comment.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  final int index;
  final Function onVideoFinished;
  final VideoModel videoData;
  const VideoPost(
      {super.key,
      required this.videoData,
      required this.onVideoFinished,
      required this.index});

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;

  late final AnimationController _animationController;

  bool _isPaused = false;
  // final bool _isMuted = false;

//1단계 : 초기화
  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/movieflix.mp4");

    await _videoPlayerController.initialize();

    //비디오 무한반복 Future를 반환해서 await달아줌
    await _videoPlayerController.setLooping(true);
    // _videoPlayerController.play();
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  void _onVideoChange() {
    //비디오 컨트롤러가 초기화 되었고,
    if (_videoPlayerController.value.isInitialized) {
      //비디오의 길이와 사용자의 영상 내의 위치가 같다면
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        //영상을 끝내라
        widget.onVideoFinished();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
  }

  void _onPlaybackConfigChanged() {
    if (!mounted) return;

    if (ref.read(playbackConfigProvider).muted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    //statefull위젯에게만 있는 mounted프로퍼티
    if (!mounted) return;
    //비디오가 전부 화면에 보이고,pause상태도 아니며 비디오가 실행중이 아닐때
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      if (ref.read(playbackConfigProvider).autoplay) {
        //비디오 재생
        _videoPlayerController.play();
      }
    }
    //비디오가 재생중인데 화면에 보이지 않을때
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      //비디오 멈춤
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    //
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      //재생버튼 크기 줄이기
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    //동영상이 재생중이면 멈추고
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    //comment창 오픈
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      //comment창 크기 조절
      isScrollControlled: true,
      context: context,
      builder: (context) => const VideoCommnets(),
    );
    //comment창 끄면 다시 동영상 재생
    _onTogglePause();
  }

  void _onLikedTap() {
    ref.read(videoPostProvider(widget.videoData.id).notifier).likeVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final videoConfig = context.dependOnInheritedWidgetOfExactType<VideoConfig>();
    // VideoConfig.of(context).autoMute;
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          //비디오 화면에 꽉 채우기 아님 teal색깔로 나오게
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Image.network(
                    widget.videoData.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          //화면 터치하면 동영상이 정지 및 재생되게 함
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          //재생버튼 애니메이션
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isPaused ? 1 : 0,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              left: 20,
              top: 80,
              child: IconButton(
                onPressed: () {},
                icon: FaIcon(
                  color: Colors.white,
                  ref.watch(playbackConfigProvider).muted
                      ? FontAwesomeIcons.volumeOff
                      : FontAwesomeIcons.volumeHigh,
                ),
              )),
          Positioned(
            bottom: 50,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@${widget.videoData.creator}",
                  style: const TextStyle(
                      fontSize: Sizes.size24,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold),
                ),
                Gaps.v12,
                Text(
                  widget.videoData.title,
                  style: const TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.amber,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/tiktokclone-dbseotjs.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media'),
                  child: Text(widget.videoData.creator),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onLikedTap,
                  child: VideoButton(
                      icon: FontAwesomeIcons.solidHeart,
                      text: '${widget.videoData.likes}'),
                ),
                Gaps.v24,
                GestureDetector(
                    onTap: () => _onCommentsTap(context),
                    child: VideoButton(
                        icon: FontAwesomeIcons.solidComment,
                        text: '${widget.videoData.comments}')),
                Gaps.v24,
                const VideoButton(icon: FontAwesomeIcons.share, text: 'Share')
              ],
            ),
          )
        ],
      ),
    );
  }
}

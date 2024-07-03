import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = 'postVideo';
  static const String routeURL = '/upload';
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  late final bool _nocamera = kDebugMode && Platform.isIOS;

  late FlashMode _flashMode;

  late CameraController _cameraController;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(microseconds: 200),
  );

  late final Animation<double> _buttonAnimation = Tween<double>(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
          vsync: this,
          duration: const Duration(seconds: 5),
          lowerBound: 0.0,
          upperBound: 1.0);

  Future<void> initCamera() async {
    //카메라가 몇개인가를 리스트로 알려줌
    final cameras = await availableCameras();
    //만약 카메라가 없다면 다끔
    if (cameras.isEmpty) {
      return;
    }
    _cameraController =
        //카메라 중 0번째(후면)만
        CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    //초기화
    await _cameraController.initialize();

    //ios 전용
    await _cameraController.prepareForVideoRecording();

    //카메라 컨트롤러에 플레쉬 정보 전달
    _flashMode = _cameraController.value.flashMode;
  }

  Future<void> initPermissions() async {
    // 권한 승인
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micaDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micaDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_nocamera) return;
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      await initCamera();
      // setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_nocamera) {
      initPermissions();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    WidgetsBinding.instance.addObserver(this);
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;
    //카메라 비디오 레코딩 시작
    await _cameraController.startVideoRecording();
    //애니메이션 시작
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!mounted) return;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPreviewScreen(
            video: video,
            isPicked: false,
          ),
        ));
  }

//갤러리에서 비디오 들고오기
  Future<void> _onpickVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    if (!mounted) return;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPreviewScreen(
            video: video,
            isPicked: true,
          ),
        ));
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();

    _progressAnimationController.dispose();
    if (!_nocamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        //카메라가 없거나 있어도 초기화 돼지 않았다면 카메라 안나옴
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: !_hasPermission
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '카메라 권한이 없습니다.',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_nocamera && _cameraController.value.isInitialized)
                      CameraPreview(_cameraController),
                    const Positioned(
                      top: Sizes.size64,
                      left: Sizes.size20,
                      child: CloseButton(
                        color: Colors.white,
                      ),
                    ),
                    if (!_nocamera)
                      Positioned(
                        top: Sizes.size64,
                        right: Sizes.size20,
                        child: Column(
                          children: [
                            IconButton(
                              color: Colors.white,
                              onPressed: _toggleSelfieMode,
                              icon: const Icon(
                                Icons.cameraswitch,
                                size: Sizes.size40,
                              ),
                            ),
                            Gaps.v10,
                            IconButton(
                              color: _flashMode == FlashMode.off
                                  ? Colors.yellow
                                  : Colors.white,
                              onPressed: () => _setFlashMode(FlashMode.off),
                              icon: const Icon(
                                Icons.flash_off_rounded,
                                size: Sizes.size40,
                              ),
                            ),
                            Gaps.v10,
                            IconButton(
                              color: _flashMode == FlashMode.always
                                  ? Colors.yellow
                                  : Colors.white,
                              onPressed: () => _setFlashMode(FlashMode.always),
                              icon: const Icon(
                                Icons.flash_on_rounded,
                                size: Sizes.size40,
                              ),
                            ),
                            Gaps.v10,
                            IconButton(
                              color: _flashMode == FlashMode.auto
                                  ? Colors.yellow
                                  : Colors.white,
                              onPressed: () => _setFlashMode(FlashMode.auto),
                              icon: const Icon(
                                Icons.flash_auto_rounded,
                                size: Sizes.size40,
                              ),
                            ),
                            Gaps.v10,
                            IconButton(
                              color: _flashMode == FlashMode.torch
                                  ? Colors.yellow
                                  : Colors.white,
                              onPressed: () => _setFlashMode(FlashMode.torch),
                              icon: const Icon(
                                Icons.flashlight_on_rounded,
                                size: Sizes.size40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Positioned(
                        bottom: Sizes.size20,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTapDown: _startRecording,
                              onTapUp: (details) => _stopRecording(),
                              child: ScaleTransition(
                                scale: _buttonAnimation,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: Sizes.size96,
                                      height: Sizes.size96,
                                      child: CircularProgressIndicator(
                                        color: Colors.red,
                                        value:
                                            _progressAnimationController.value,
                                      ),
                                    ),
                                    Container(
                                      width: Sizes.size80,
                                      height: Sizes.size80,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.shade500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                    onPressed: _onpickVideoPressed,
                                    icon: const FaIcon(
                                      FontAwesomeIcons.image,
                                      color: Colors.white,
                                    )),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
        ));
  }
}

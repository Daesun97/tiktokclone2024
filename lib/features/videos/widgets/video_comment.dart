import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class VideoCommnets extends StatefulWidget {
  const VideoCommnets({super.key});

  @override
  State<VideoCommnets> createState() => _VideoCommnetsState();
}

class _VideoCommnetsState extends State<VideoCommnets> {
  bool _isWriting = false;
  final ScrollController _scrollController = ScrollController();

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    //유저가 글안쓰고 나가려 한다.
    setState(() {
      _isWriting = false;
    });
  }

//유저가 글 쓰려한다!
  void _startWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Sizes.size16,
        ),
      ),
      child: Scaffold(
        backgroundColor: isDark ? null : Colors.grey.shade50,
        appBar: AppBar(
          //뒤로가기 버튼 안뜨게 하기
          backgroundColor: isDark ? null : Colors.grey.shade50,
          automaticallyImplyLeading: false,
          title: Text(
            '150개의 댓글',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: _onClosePressed,
                icon: const FaIcon(FontAwesomeIcons.xmark))
          ],
        ),
        body: GestureDetector(
          onTap: _stopWriting,
          child: Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                    left: Sizes.size16,
                    right: Sizes.size16,
                    top: Sizes.size10,
                    bottom: Sizes.size96,
                  ),
                  itemCount: 10,
                  separatorBuilder: (context, index) => Gaps.v20,
                  itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        child: Text('유저'),
                      ),
                      Gaps.h10,
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '유저 1',
                            style: TextStyle(
                              fontSize: Sizes.size14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Gaps.v5,
                          const Text(
                              '엄청나게 긴 TMI 엄청나게 긴 TMI 엄청나게 긴 TMI 엄청나게 긴 TMI')
                        ],
                      )),
                      Gaps.h10,
                      Column(
                        children: [
                          FaIcon(FontAwesomeIcons.heart,
                              size: Sizes.size28, color: Colors.grey.shade500),
                          Gaps.v2,
                          Text(
                            '30',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                //처음에는 안보이게 밑에 박아둠
                bottom: 0,
                //사용기기의 가로 크기
                width: size.width,
                child: BottomAppBar(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: Sizes.size4,
                        right: Sizes.size10,
                        bottom: Sizes.size3,
                        top: Sizes.size6),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 18,
                          child: Text('유저2'),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              onTap: _startWriting,
                              //두줄쓰기 가능해짐
                              expands: true,
                              //done을 엔터로
                              textInputAction: TextInputAction.newline,
                              //둘다 null주면 textfield가 무한으로 늘어날수 잇음
                              minLines: null,
                              maxLines: null,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                hintText: '댓글을 작성해 주세요...',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(Sizes.size12),
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size20,
                                  vertical: Sizes.size10,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      right: Sizes.size14),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.at,
                                        color: isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade800,
                                      ),
                                      Gaps.h14,
                                      FaIcon(
                                        FontAwesomeIcons.gift,
                                        color: isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade800,
                                      ),
                                      Gaps.h14,
                                      FaIcon(
                                        FontAwesomeIcons.faceSmile,
                                        color: isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade800,
                                      ),
                                      Gaps.h14,
                                      if (_isWriting)
                                        GestureDetector(
                                          onTap: _stopWriting,
                                          child: FaIcon(
                                            FontAwesomeIcons.circleArrowUp,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

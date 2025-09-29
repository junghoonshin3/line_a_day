import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/widgets/animated_button_widget.dart';

class EmojiSelectView extends ConsumerStatefulWidget {
  const EmojiSelectView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _EmojiSelectViewState();
  }
}

class _EmojiSelectViewState extends ConsumerState<EmojiSelectView> {
  final double width = 60;
  final double height = 60;
  final String assetsPath = "assets/images";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text("원하는 스타일의 이모지를 선택하세요!"),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("3D"),
                      Image.asset(
                        "$assetsPath/free_icon_love_1791311.png",
                        width: width,
                        height: height,
                      ),
                      Image.asset(
                        "$assetsPath/free_icon_smile_1791293.png",
                        width: width,
                        height: height,
                      ),
                      Image.asset(
                        "$assetsPath/free-icon-sad-1791330.png",
                        width: width,
                        height: height,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("플렛"),
                      Image.asset(
                        "$assetsPath/free_icon_love_1791391.png",
                        width: width,
                        height: height,
                      ),
                      Image.asset(
                        "$assetsPath/free_icon_smile_1791342.png",
                        width: width,
                        height: height,
                      ),
                      Image.asset(
                        "$assetsPath/free-icon-sad-1791429.png",
                        width: width,
                        height: height,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("스케치"),
                      Image.asset(
                        "$assetsPath/free_icon_love_1794777.png",
                        width: width,
                        height: height,
                      ),
                      Image.asset(
                        "$assetsPath/free_icon_smile_1794767.png",
                        width: width,
                        height: height,
                      ),
                      Image.asset(
                        "$assetsPath/free-icon-sad-1794787.png",
                        width: width,
                        height: height,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                height: 60,
                alignment: AlignmentGeometry.center,
                child: const Text("선택", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

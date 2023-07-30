import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt_clone/constants/constants.dart';
import 'package:chat_gpt_clone/providers/chat_provider.dart';
import 'package:chat_gpt_clone/services/assets_manager.dart';
import 'package:chat_gpt_clone/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatelessWidget {
  final ChatProvider chatProvider;
  final String message;
  final int index;
  final bool animate;
  const ChatWidget(
      {super.key,
      required this.message,
      required this.index,
      required this.animate,
      required this.chatProvider});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: index % 2 == 0 ? scaffoldBackGroundColor : cardColor,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              index % 2 == 0 ? AssetsManager.userImage : AssetsManager.botImage,
              height: 30,
              width: 30,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: index % 2 != 0 && animate && chatProvider.Typing
                    ? AnimatedTextKit(
                        onFinished: () {
                          chatProvider.toggleTyping();
                        },
                        isRepeatingAnimation: false,
                        repeatForever: false,
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                        animatedTexts: [
                            TyperAnimatedText(message.trim(),
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20))
                          ])
                    : TextWidget(
                        label: message,
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

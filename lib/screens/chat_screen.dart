import 'package:chat_gpt_clone/constants/constants.dart';
import 'package:chat_gpt_clone/providers/chat_provider.dart';
import 'package:chat_gpt_clone/providers/models_provider.dart';
import 'package:chat_gpt_clone/services/assets_manager.dart';
import 'package:chat_gpt_clone/services/services.dart';
import 'package:chat_gpt_clone/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textEditingController;
  FocusNode focusNode = FocusNode();

  sendMessage({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
  }) async {
    if (textEditingController.text.isNotEmpty) {
      try {
        String msg = textEditingController.text.trim();
        textEditingController.clear();
        chatProvider.addUserMessage(msg);
        focusNode.unfocus();
        chatProvider.toggleTyping();

        await chatProvider.sendMessagesAndGetAnswers(
            message: msg, modelId: modelsProvider.currentModel);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final isTyping = chatProvider.isTyping;
    final chatList = chatProvider.getChatList;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat GPT'),
          centerTitle: true,
          elevation: 5,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openAiLogo),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await Services.modalBottomSheet(context);
                },
                icon: const Icon(Icons.more_vert_outlined))
          ],
        ),
        body: chatProvider.loadingChat
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: ChatWidget(
                            chatProvider: chatProvider,
                            message: chatList[chatList.length - index - 1].msg,
                            index:
                                chatList[chatList.length - index - 1].chatIndex,
                            animate: index == 0,
                          ),
                        );
                      },
                      itemCount: chatList.length,
                    ),
                  ),
                  if (isTyping) ...[
                    const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                  const SizedBox(
                    height: 1,
                  ),
                  Material(
                    color: cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            focusNode: focusNode,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              hintText: 'how can i help you',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 236, 232, 232)),
                            ),
                            controller: textEditingController,
                          )),
                          !isTyping
                              ? IconButton(
                                  onPressed: () {
                                    sendMessage(
                                        chatProvider: chatProvider,
                                        modelsProvider: modelsProvider);
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ))
                              : const Icon(Icons.refresh)
                        ],
                      ),
                    ),
                  )
                ],
              )));
  }
}

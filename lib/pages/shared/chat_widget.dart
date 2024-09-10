import 'package:flutter/material.dart';
import 'package:lista_de_conversa/model/chat_model.dart';

class ChatWidget extends StatelessWidget {
  final ChatModel textModel;
  final bool souEu;
  const ChatWidget({super.key, required this.textModel, required this.souEu});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: souEu ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: souEu ? Colors.blue : Colors.orange,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            souEu
                ? const Wrap()
                : Text(
                    textModel.nickName,
                    style: const TextStyle(color: Colors.white),
                  ),
            Text(
              textModel.text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

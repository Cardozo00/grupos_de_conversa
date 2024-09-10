import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  DateTime dataHora = DateTime.now();
  String text = "";
  String userId = "";
  String nickName = "";

  ChatModel({
    required this.text,
    required this.userId,
    required this.nickName,
  });
  ChatModel.criarUser({required this.nickName, required this.userId});

  ChatModel.vazio();

  ChatModel.fromJson(Map<String, dynamic> json) {
    dataHora = (json['data_hora'] as Timestamp).toDate();
    text = json['text'];
    userId = json['user_id'];
    nickName = json['nickName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data_hora'] = Timestamp.fromDate(dataHora);
    data['text'] = text;
    data['user_id'] = userId;
    data['nickName'] = nickName;
    return data;
  }
}

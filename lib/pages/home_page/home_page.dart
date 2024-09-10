import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_conversa/model/chat_model.dart';
import 'package:lista_de_conversa/model/salas_model.dart';
import 'package:lista_de_conversa/pages/chatpage/chat_page.dart';
import 'package:lista_de_conversa/pages/shared/show_modal_add_sala.dart';
import 'package:lista_de_conversa/pages/shared/show_modal_add_usuario.dart';
import 'package:lista_de_conversa/pages/shared/show_modal_remover_grupo.dart';
import 'package:lista_de_conversa/repository/dark_mode_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var db = FirebaseFirestore.instance;
  var chatModel = ChatModel.vazio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 136, 136, 136),
          title: const Text("Lista de Salas"),
          leading: const Showmodaladdsala(),
          actions: [
            Consumer<DarkModeRepository>(
                builder: (_, darkModeRepository, widget) {
              return Switch(
                  value: darkModeRepository.darkMode,
                  onChanged: (bool value) {
                    darkModeRepository.darkMode = value;
                  });
            })
          ],
        ),
        body: Consumer<DarkModeRepository>(
            builder: (_, darkModeRepository, widget) {
          return StreamBuilder<QuerySnapshot>(
              stream: db.collection('chats').snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const CircularProgressIndicator()
                    : ListView(
                        children: snapshot.data!.docs.map((e) {
                        var textModel = SalasModel.fromJson(
                            e.data() as Map<String, dynamic>);
                        return Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                child: InkWell(
                                    child: textModel.imagemGrupo.isEmpty
                                        ? const Icon(Icons.groups)
                                        : ClipOval(
                                            child: Image.network(
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                textModel.imagemGrupo),
                                          )),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: InkWell(
                                    onLongPress: () async {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ShowModalRemoverGrupo(
                                              nomeSala: textModel.nomeSala,
                                              imagemGrupo:
                                                  textModel.imagemGrupo,
                                            );
                                          });
                                    },
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      bool isLoggedIn =
                                          prefs.getBool('isLoggedIn') ?? false;

                                      if (isLoggedIn) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ChatPage(
                                                      nomeUsuario:
                                                          chatModel.nickName,
                                                      nomeSala:
                                                          textModel.nomeSala,
                                                    )));
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ShowModalAddUsuario(
                                              nomeSala: textModel.nomeSala,
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: StreamBuilder<QuerySnapshot>(
                                        stream: db
                                            .collection('chats')
                                            .doc(textModel.nomeSala)
                                            .collection('usuarios')
                                            .orderBy('data_hora',
                                                descending: true)
                                            .limit(1)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Text('');
                                          }
                                          var documents = snapshot.data!.docs;

                                          var lastMessageText = documents
                                                  .isNotEmpty
                                              ? ChatModel.fromJson(documents
                                                          .first
                                                          .data()
                                                      as Map<String, dynamic>)
                                                  .text
                                              : '';

                                          var lastMessageTextHour = documents
                                                  .isNotEmpty
                                              ? ChatModel.fromJson(documents
                                                          .last
                                                          .data()
                                                      as Map<String, dynamic>)
                                                  .dataHora
                                                  .hour
                                              : '';
                                          var lastMessageTextMinute = documents
                                                  .isNotEmpty
                                              ? ChatModel.fromJson(documents
                                                          .last
                                                          .data()
                                                      as Map<String, dynamic>)
                                                  .dataHora
                                                  .minute
                                              : '';

                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        textModel.nomeSala,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        lastMessageText,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: darkModeRepository
                                                                    .darkMode
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    196,
                                                                    196,
                                                                    196)
                                                                : const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    99,
                                                                    99,
                                                                    99)),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: documents.isEmpty
                                                          ? const Text('')
                                                          : Text(
                                                              '$lastMessageTextHour:$lastMessageTextMinute'))
                                                ],
                                              ),
                                              const Divider()
                                            ],
                                          );
                                        })),
                              ),
                            ],
                          ),
                        );
                      }).toList());
              });
        }));
  }
}

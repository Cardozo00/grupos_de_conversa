import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_de_conversa/model/chat_model.dart';
import 'package:lista_de_conversa/model/salas_model.dart';
import 'package:lista_de_conversa/pages/shared/chat_widget.dart';
import 'package:lista_de_conversa/pages/shared/show_modal_exluir_img_grupo.dart';
import 'package:lista_de_conversa/repository/crop_image_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String nomeUsuario;
  final String nomeSala;
  const ChatPage(
      {super.key, required this.nomeUsuario, required this.nomeSala});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var cropImageRepository = CropImageRepository();
  final textController = TextEditingController(text: "");
  var db = FirebaseFirestore.instance;
  String userId = "";

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Não se esqueça de liberar o controlador
    super.dispose();
  }

  carregarUsuario() async {
    final share = await SharedPreferences.getInstance();
    userId = share.getString('user_id')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text(widget.nomeSala),
        actions: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder<DocumentSnapshot>(
                  stream:
                      db.collection('chats').doc(widget.nomeSala).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      var textModel = SalasModel.fromJson(
                          snapshot.data!.data() as Map<String, dynamic>);
                      return Column(children: [
                        InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Wrap(
                                      children: [
                                        Column(
                                          children: [
                                            ListTile(
                                                leading: const FaIcon(
                                                    FontAwesomeIcons.camera),
                                                title: const Text("Camera"),
                                                onTap: () async {
                                                  cropImageRepository
                                                      .salvarFoto(
                                                          ImageSource.camera,
                                                          widget.nomeSala);
                                                }),
                                            const Divider(),
                                            ListTile(
                                              leading: const FaIcon(
                                                  FontAwesomeIcons.image),
                                              title: const Text("Galeria"),
                                              onTap: () async {
                                                cropImageRepository.salvarFoto(
                                                    ImageSource.gallery,
                                                    widget.nomeSala);
                                              },
                                            ),
                                            const Divider(),
                                            ListTile(
                                              leading: const FaIcon(
                                                  FontAwesomeIcons.trashCan),
                                              title:
                                                  const Text("Remover Imagem"),
                                              onTap: () {
                                                if (textModel
                                                    .imagemGrupo.isNotEmpty) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return ShowModalExluirImagemGrupo(
                                                          nomeSala:
                                                              widget.nomeSala,
                                                        );
                                                      });
                                                  // Navigator.pop(context);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "O grupo não possui imagem")));
                                                  Navigator.pop(context);
                                                  return;
                                                }
                                              },
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: CircleAvatar(
                                radius: 25,
                                child: textModel.imagemGrupo.isEmpty
                                    ? const Icon(Icons.groups)
                                    : ClipOval(
                                        child: Image.network(
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                            textModel.imagemGrupo),
                                      ),
                              ),
                            ))
                      ]);
                    }
                  }))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: db
                      .collection('chats')
                      .doc(widget.nomeSala)
                      .collection('usuarios')
                      .orderBy('data_hora', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      });
                      return ListView(
                          controller: _scrollController,
                          children: snapshot.data!.docs.map((e) {
                            var textModel = ChatModel.fromJson(
                                e.data() as Map<String, dynamic>);
                            return ChatWidget(
                                textModel: textModel,
                                souEu: textModel.userId == userId);
                          }).toList());
                    }
                  })),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            color: Colors.grey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: TextField(
                  cursorHeight: 18,
                  controller: textController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                        vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  style: const TextStyle(fontSize: 18),
                )),
                InkWell(
                    onTap: () async {
                      if (textController.text.isEmpty) {
                        return;
                      }
                      var chat = ChatModel(
                        text: textController.text,
                        userId: userId,
                        nickName: widget.nomeUsuario,
                      );
                      await db
                          .collection('chats')
                          .doc(widget.nomeSala)
                          .collection('usuarios')
                          .add(chat.toJson());

                      textController.text = "";
                    },
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 10, 46, 108),
                      radius: 25,
                      child: Icon(
                        Icons.send,
                        size: 20,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
              height: viewInsetsBottom > 0 ? 0 : 20,
              child: Container(
                color: Colors.grey,
              ))
        ],
      ),
    );
  }
}

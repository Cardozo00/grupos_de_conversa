import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowModalExluirImagemGrupo extends StatelessWidget {
  final String nomeSala;
  const ShowModalExluirImagemGrupo({super.key, required this.nomeSala});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    return StreamBuilder<DocumentSnapshot>(
        stream: db.collection('chats').doc(nomeSala).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return AlertDialog(
              content: Wrap(
                children: [
                  Column(
                    children: [
                      const Text(
                        "Deseja deletar a imagem?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 10, 46, 108),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                    onPressed: () async {
                                      await db
                                          .collection('chats')
                                          .doc(nomeSala)
                                          .update({
                                        'imagem_grupo': '',
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Excluir",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ))),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
        });
  }
}

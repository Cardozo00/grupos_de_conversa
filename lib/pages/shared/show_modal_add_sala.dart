import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_conversa/model/salas_model.dart';

class Showmodaladdsala extends StatelessWidget {
  const Showmodaladdsala({super.key});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;

    var nomeSala = TextEditingController();

    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: Wrap(
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Criar uma sala",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black)),
                          child: TextField(
                            controller: nomeSala,
                            decoration: const InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintText: "Nome da sala"),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 20,
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
                                      color: const Color.fromARGB(
                                          255, 10, 46, 108),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextButton(
                                      onPressed: () async {
                                        var salas =
                                            SalasModel(nomeSala.text, "");
                                        await db
                                            .collection('chats')
                                            .doc(nomeSala.text)
                                            .set(salas.toJson());
                                        // .add(salas.toJson());
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Criar",
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
            });
      },
      icon: const Icon(Icons.add),
    );
  }
}

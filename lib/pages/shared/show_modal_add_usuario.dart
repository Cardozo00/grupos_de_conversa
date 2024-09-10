// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_conversa/pages/chatpage/chat_page.dart';

class ShowModalAddUsuario extends StatelessWidget {
  final String nomeSala;
  const ShowModalAddUsuario({super.key, required this.nomeSala});

  @override
  Widget build(BuildContext context) {
    var nomeUsuario = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return AlertDialog(
      content: Wrap(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Entrar na sala",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black)),
                  child: TextFormField(
                    controller: nomeUsuario,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserir um nome';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorStyle: TextStyle(
                          fontSize: 13,
                        ),
                        hintText: "Nome do usuário"),
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
                                color: const Color.fromARGB(255, 10, 46, 108),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ChatPage(
                                                  nomeUsuario: nomeUsuario.text,
                                                  nomeSala: nomeSala,
                                                )));
                                  }
                                },
                                child: const Text(
                                  "Entrar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

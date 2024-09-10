class SalasModel {
  String nomeSala = "";
  String imagemGrupo = "";

  SalasModel(this.nomeSala, this.imagemGrupo);
  SalasModel.vazio();

  SalasModel.fromJson(Map<String, dynamic> json) {
    nomeSala = json['nome_sala'];
    imagemGrupo = json['imagem_grupo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['nome_sala'] = nomeSala;
    data['imagem_grupo'] = imagemGrupo;

    return data;
  }
}

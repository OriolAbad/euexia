class Consejo {
  int idconsejo;
  String descripcion;

  Consejo({
    required this.idconsejo,
    required this.descripcion,
  });

  factory Consejo.fromJson(Map<String, dynamic> json) {
    return Consejo(
      idconsejo: json['idconsejo'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idconsejo': idconsejo,
      'descripcion': descripcion,
    };
  }
}
class Consejos {
  int idconsejo;
  String descripcion;

  Consejos({
    required this.idconsejo,
    required this.descripcion,
  });

  factory Consejos.fromJson(Map<String, dynamic> json) {
    return Consejos(
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
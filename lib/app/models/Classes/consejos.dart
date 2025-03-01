class Consejos {
  int idConsejo;
  String descripcion;

  Consejos({
    required this.idConsejo,
    required this.descripcion,
  });

  factory Consejos.fromJson(Map<String, dynamic> json) {
    return Consejos(
      idConsejo: json['idConsejo'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idConsejo': idConsejo,
      'descripcion': descripcion,
    };
  }
}
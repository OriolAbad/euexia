class RecordsPersonales {
  int idUsuario;
  int idEjercicio;
  double record;

  RecordsPersonales({
    required this.idUsuario,
    required this.idEjercicio,
    required this.record,
  });

  factory RecordsPersonales.fromJson(Map<String, dynamic> json) {
    return RecordsPersonales(
      idUsuario: json['idUsuario'],
      idEjercicio: json['idEjercicio'],
      record: json['record'].toDouble(),
    );
  }
}
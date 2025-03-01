class DiasEntrenados {
  int idUsuario;
  int idRutina;
  DateTime fechaEntrenamiento;
  Duration tiempoEntrenamiento;

  DiasEntrenados({
    required this.idUsuario,
    required this.idRutina,
    required this.fechaEntrenamiento,
    required this.tiempoEntrenamiento,
  });

  factory DiasEntrenados.fromJson(Map<String, dynamic> json) {
    return DiasEntrenados(
      idUsuario: json['idUsuario'],
      idRutina: json['idRutina'],
      fechaEntrenamiento: DateTime.parse(json['fechaEntrenamiento']),
      tiempoEntrenamiento: Duration(
        hours: int.parse(json['tiempoEntrenamiento'].split(':')[0]),
        minutes: int.parse(json['tiempoEntrenamiento'].split(':')[1]),
        seconds: int.parse(json['tiempoEntrenamiento'].split(':')[2]),
      ),
    );
  }
}
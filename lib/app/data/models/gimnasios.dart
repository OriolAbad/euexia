class Gimnasio {
  int idGimnasio;
  String nombre;
  String ubicacion;
  double? longitud;
  double? latitud;
  String? paginaWeb;
  String? fotoGimnasio;

  Gimnasio({
    required this.idGimnasio,
    required this.nombre,
    required this.ubicacion,
    this.longitud,
    this.latitud,
    this.paginaWeb,
    this.fotoGimnasio,
  });

  factory Gimnasio.fromJson(Map<String, dynamic> json) {
    return Gimnasio(
      idGimnasio: json['idgimnasio'],
      nombre: json['nombre'],
      ubicacion: json['ubicacion'],
      longitud: json['longitud']?.toDouble(),
      latitud: json['latitud']?.toDouble(),
      paginaWeb: json['paginaweb'],
      fotoGimnasio: json['fotogimnasio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idgimnasio': idGimnasio,
      'nombre': nombre,
      'ubicacion': ubicacion,
      'longitud': longitud,
      'latitud': latitud,
      'paginaweb': paginaWeb,
      'fotogimnasio': fotoGimnasio,
    };
  }
}
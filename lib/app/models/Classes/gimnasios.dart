class Gimnasios {
  int idGimnasio;
  String nombre;
  String ubicacion;
  double? longitud;
  double? latitud;
  String? paginaWeb;
  String? fotoGimnasio;

  Gimnasios({
    required this.idGimnasio,
    required this.nombre,
    required this.ubicacion,
    this.longitud,
    this.latitud,
    this.paginaWeb,
    this.fotoGimnasio,
  });

  factory Gimnasios.fromJson(Map<String, dynamic> json) {
    return Gimnasios(
      idGimnasio: json['idGimnasio'],
      nombre: json['nombre'],
      ubicacion: json['ubicacion'],
      longitud: json['longitud']?.toDouble(),
      latitud: json['latitud']?.toDouble(),
      paginaWeb: json['paginaWeb'],
      fotoGimnasio: json['fotoGimnasio'],
    );
  }
}
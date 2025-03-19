class Usuario {
  String? uuid;
  int? idUsuario;
  String nombre;
  String apellido1;
  String? apellido2;
  String email;
  String nombreUsuario;
  DateTime? created_at;
  String? imagenPerfil;
  int puntos;
  String location;

  Usuario({
    this.uuid,
    this.idUsuario,
    required this.nombre,
    required this.apellido1,
    this.apellido2,
    required this.email,
    required this.nombreUsuario,
    this.created_at,
    this.imagenPerfil,
    this.puntos = 0,
    required this.location,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      uuid: json['uuid'],
      idUsuario: json['idusuario'],
      nombre: json['name'],
      apellido1: json['apellido1'],
      apellido2: json['apellido2'],
      email: json['email'],
      nombreUsuario: json['nombreusuario'],
      created_at: DateTime.parse(json['created_at']),
      imagenPerfil: json['imagenperfil'],
      puntos: json['puntos'] ?? 0,
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'idusuario': idUsuario,
      'name': nombre,
      'apellido1': apellido1,
      'apellido2': apellido2,
      'email': email,
      'nombreusuario': nombreUsuario,
      'created_at': created_at?.toIso8601String(),
      'imagenperfil': imagenPerfil,
      'puntos': puntos,
      'location': location,
    };
  }
}
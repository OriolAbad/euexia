class Usuarios {
  int idUsuario;
  String nombre;
  String apellido1;
  String? apellido2;
  String correoElectronico;
  String nombreUsuario;
  String contrasena;
  DateTime fechaCreacion;
  String? imagenPerfil;
  int puntos;

  Usuarios({
    required this.idUsuario,
    required this.nombre,
    required this.apellido1,
    this.apellido2,
    required this.correoElectronico,
    required this.nombreUsuario,
    required this.contrasena,
    required this.fechaCreacion,
    this.imagenPerfil,
    this.puntos = 0,
  });

  factory Usuarios.fromJson(Map<String, dynamic> json) {
    return Usuarios(
      idUsuario: json['idUsuario'],
      nombre: json['nombre'],
      apellido1: json['apellido1'],
      apellido2: json['apellido2'],
      correoElectronico: json['correoElectronico'],
      nombreUsuario: json['nombreUsuario'],
      contrasena: json['contrasena'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      imagenPerfil: json['imagenPerfil'],
      puntos: json['puntos'] ?? 0,
    );
  }
}
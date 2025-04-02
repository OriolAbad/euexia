class Consejo {
  int? idconsejo; // Ahora es opcional
  String descripcion;

  Consejo({
    this.idconsejo, // No es obligatorio
    required this.descripcion,
  });

  factory Consejo.fromJson(Map<String, dynamic> json) {
    return Consejo(
      idconsejo: json['idconsejo'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'descripcion': descripcion,
    };

    if (idconsejo != null) {
      data['idconsejo'] = idconsejo.toString();
    }

    return data;
  }
}

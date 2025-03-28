import 'package:euexia/app/data/models/amigos.dart';
import 'package:euexia/app/data/models/categorias.dart';
import 'package:euexia/app/data/models/consejos.dart';
import 'package:euexia/app/data/models/dias_entrenados.dart';
import 'package:euexia/app/data/models/dificultades.dart';
import 'package:euexia/app/data/models/ejercicios.dart';
import 'package:euexia/app/data/models/ejercicios_rutinas.dart';
import 'package:euexia/app/data/models/fotos.dart';
import 'package:euexia/app/data/models/gimnasios.dart';
import 'package:euexia/app/data/models/recompensa_canjeada.dart';
import 'package:euexia/app/data/models/recompensas.dart';
import 'package:euexia/app/data/models/records_personales.dart';
import 'package:euexia/app/data/models/retos.dart';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/data/models/tipos_retos.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/usuarios_gimnasios.dart';
import 'package:euexia/app/data/models/usuarios_retos.dart';
import 'package:euexia/app/data/models/usuarios_rutinas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient client = Supabase.instance.client;

class SupabaseService {
  
  final _AmigosService amigos;
  final _CategoriasService categorias;
  final _ConsejosServices consejos;
  final _DiasEntrenadosService dias_entrenados;
  final _DificultadesService dificultades;
  final _EjerciciosRutinasService ejercicios_rutinas;
  final _EjerciciosService ejercicios;
  final _FotosService fotos;
  final _GimnasiosService gimnasios;
  final _RecompensasCanjeadasService recompensas_canjeadas;
  final _RecompensasService recompensas;
  final _RecordsPersonalesService records_personales;
  final _RetosService retos;
  final _RutinasService rutinas;
  final _TiposRetosService tipos_retos;
  final _UsuariosGimnasiosService usuarios_gimnasios;
  final _UsuariosRetosService usuarios_retos;
  final _UsuariosRutinasService usuarios_rutinas;
  final _UsuariosService usuarios;

  SupabaseService()
      : amigos = _AmigosService(),
        categorias = _CategoriasService(),
        consejos = _ConsejosServices(),
        dias_entrenados = _DiasEntrenadosService(),
        dificultades = _DificultadesService(),
        ejercicios_rutinas = _EjerciciosRutinasService(),
        ejercicios = _EjerciciosService(),
        fotos = _FotosService(),
        gimnasios = _GimnasiosService(),
        recompensas_canjeadas = _RecompensasCanjeadasService(),
        recompensas = _RecompensasService(),
        records_personales = _RecordsPersonalesService(),
        retos = _RetosService(),
        rutinas = _RutinasService(),
        tipos_retos = _TiposRetosService(),
        usuarios_gimnasios = _UsuariosGimnasiosService(),
        usuarios_retos = _UsuariosRetosService(),
        usuarios_rutinas = _UsuariosRutinasService(),
        usuarios = _UsuariosService();
}


class _AmigosService {
  Future<custom_response.Response> getFriends(int idUsuario) async {
    List<Amigo> friends = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('amigos')
          .select()
          .or('idusuario1.eq.$idUsuario,idusuario2.eq.$idUsuario'); // Corrige el formato de la cláusula or

      friends = (data as List).map<Amigo>((json) => Amigo.fromJson(json)).toList();

      result.success = true;
      result.data = friends;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> getFriendsWith(int idUsuario) async {
    List<Amigo> friends = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('amigos')
          .select('idusuario1, idusuario2, usuarios1:usuarios!idusuario1(*), usuarios2:usuarios!idusuario2(*)')
          .or('idusuario1.eq.$idUsuario,idusuario2.eq.$idUsuario'); // Filtra por idUsuario en ambos campos

      friends = data.map<Amigo>((json) {
        Amigo friend = Amigo.fromJson(json);
        if (json['usuarios1'] != null) {
          friend.usuario1 = Usuario.fromJson(json['usuarios1']);
        }
        if (json['usuarios2'] != null) {
          friend.usuario2 = Usuario.fromJson(json['usuarios2']);
        }
        return friend;
      }).toList();

      result.success = true;
      result.data = friends;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> addFriend(int idUsuario1, int idUsuario2) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
          .from('amigos')
          .insert({
            'idusuario1': idUsuario1,
            'idusuario2': idUsuario2,
          });

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
    }
  Future<custom_response.Response> deleteFriend(int idUsuario1, int idUsuario2) async {
      custom_response.Response result = custom_response.Response(success: false);

      try {
        await client
            .from('amigos')
            .delete()
            .or('and(idusuario1.eq.$idUsuario1,idusuario2.eq.$idUsuario2),and(idusuario1.eq.$idUsuario2,idusuario2.eq.$idUsuario1)');

        result.success = true;
      } catch (e) {
        result.success = false;
        result.errorMessage = e.toString();
      }

      return result;
    }
}

class _CategoriasService {
  Future<custom_response.Response> getCategories() async {
    List<Categoria> categories = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('categorias')
        .select();
        
      categories = data.map<Categoria>((json) => Categoria.fromJson(json)).toList();

      result.success = true;
      result.data = categories;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getCategoriesWithExercises() async {
    List<Categoria> categories = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('categorias')
          .select('*, ejercicios(*)'); // Incluye la relación con la tabla ejercicios

      categories = data.map<Categoria>((json) {
        Categoria category = Categoria.fromJson(json);
        if (json['ejercicios'] != null) {
          category.ejercicios = (json['ejercicios'] as List)
              .map<Ejercicio>((exerciseJson) => Ejercicio.fromJson(exerciseJson))
              .toList();
        }
        return category;
      }).toList();

      result.success = true;
      result.data = categories;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> getCategoryById(int id) async {
    Categoria category = Categoria(idCategoria: 0, nombre: '');
    
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('categorias')
        .select()
        .eq('idcategoria', id);

      category = Categoria.fromJson(data[0]);

      result.success = true;
      result.data = category;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> getCategoryByIdWithExercises(int id) async {
    Categoria? category;
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('categorias')
          .select('*, ejercicios(*)') // Incluye la relación con la tabla ejercicios
          .eq('idcategoria', id)
          .single(); // Obtiene un único registro
  
      category = Categoria.fromJson(data);
      if (data['ejercicios'] != null) {
        category.ejercicios = (data['ejercicios'] as List)
            .map<Ejercicio>((exerciseJson) => Ejercicio.fromJson(exerciseJson))
            .toList();
      }
  
      result.success = true;
      result.data = category;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> addCategory(Categoria category) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('categorias')
        .insert(category.toJson());

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> updateCategory(Categoria category) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('categorias')
        .update(category.toJson())
        .eq('idcategoria', category.idCategoria);

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> deleteCategory(int id) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('categorias')
        .delete()
        .eq('idcategoria', id);

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

} 

class _ConsejosServices {
  Future<custom_response.Response> getTips() async {
    List<Consejo> tips = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('consejos')
        .select()
        .order('idconsejo', ascending: true);

      tips = data.map<Consejo>((json) => Consejo.fromJson(json)).toList();

      result.success = true;
      result.data = tips;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getTipById(int id) async{
    Consejo tip = Consejo(idconsejo: 0, descripcion: '');
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('consejos')
        .select()
        .eq('idconsejo', id);

      tip = Consejo.fromJson(data[0]);

      result.success = true;
      result.data = tip;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> addTip(Consejo tip) async {
    custom_response.Response result = custom_response.Response(success: false);
    try {
      await client
        .from('consejos')
        .insert(tip.toJson());

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;  
  }
  Future<custom_response.Response> updateTip(Consejo tip) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('consejos')
        .update(tip.toJson())
        .eq('idconsejo', tip.idconsejo);

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> deleteTip(int id) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('consejos')
        .delete()
        .eq('idconsejo', id);

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
}

class _DiasEntrenadosService{
  Future<custom_response.Response> getTrainingDaysByUser(int idUsuario) async {
  List<DiaEntrenado> trainingDays = [];
  custom_response.Response result = custom_response.Response(success: false);

  try {
    final data = await client
        .from('dias_entrenados')
        .select()
        .eq('idusuario', idUsuario); // Filtra por idUsuario

    trainingDays = data.map<DiaEntrenado>((json) => DiaEntrenado.fromJson(json)).toList();

    result.success = true;
    result.data = trainingDays;

  } catch (e) {
    result.success = false;
    result.errorMessage = e.toString();
  }

  return result;
}
  Future<custom_response.Response> addTrainedDay(DiaEntrenado trainedDay) async {
  custom_response.Response result = custom_response.Response(success: false);

  try {
    await client
        .from('dias_entrenados')
        .insert(trainedDay.toJson()); // Inserta el objeto convertido a JSON

    result.success = true;
    result.data = trainedDay;
  } catch (e) {
    result.success = false;
    result.errorMessage = e.toString();
  }

  return result;
}

} 

class _DificultadesService {
  Future<custom_response.Response> getDifficulty() async {
    List<Dificultad> difficulties = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('dificultades')
        .select();

      difficulties = data.map<Dificultad>((json) => Dificultad.fromJson(json)).toList();

      result.success = true;
      result.data = difficulties;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getDifficultyById(int id) async {
    Dificultad difficulty = Dificultad(idDificultad: 0, descripcion: '');
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('dificultades')
        .select()
        .eq('iddificultad', id);

      difficulty = Dificultad.fromJson(data[0]);

      result.success = true;
      result.data = difficulty;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> addDifficulty(Dificultad difficulty) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('dificultades')
        .insert(difficulty.toJson());

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> updateDifficulty(Dificultad difficulty) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('dificultades')
        .update(difficulty.toJson())
        .eq('iddificultad', difficulty.idDificultad);

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> deleteDifficulty(int id) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('dificultades')
        .delete()
        .eq('iddificultad', id);

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

}

class _EjerciciosService {
  Future<custom_response.Response> getExercises() async {
    List<Ejercicio> exercises = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('dias_entrenados')
        .select()
        .order('idusuario', ascending: true);

      exercises = data.map<Ejercicio>((json) => Ejercicio.fromJson(json)).toList();

      result.success = true;
      result.data = exercises;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getExercisesWithCategory() async {
  List<Ejercicio> exercises = [];
  custom_response.Response result = custom_response.Response(success: false);

  try {
    final data = await client
        .from('ejercicios')
        .select('*, categorias(*)'); // Incluye la relación con la tabla categorias

    exercises = data.map<Ejercicio>((json) {
      Ejercicio exercise = Ejercicio.fromJson(json);
      if (json['categorias'] != null) {
        exercise.categoria = Categoria.fromJson(json['categorias']);
      }
      return exercise;
    }).toList();

    result.success = true;
    result.data = exercises;

  } catch (e) {
    result.success = false;
    result.errorMessage = e.toString();
  }

  return result;
}
  Future<custom_response.Response> getExerciseById(int id) async {
    Ejercicio exercise = Ejercicio(idEjercicio: 0, nombre: '', descripcion: '', idCategoria: 0);
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('ejercicios')
        .select()
        .eq('idejercicio', id);

      exercise = Ejercicio.fromJson(data[0]);

      result.success = true;
      result.data = exercise;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> getExerciseByIdWithCategory(int id) async {
  Ejercicio? exercise;
  custom_response.Response result = custom_response.Response(success: false);

  try {
    final data = await client
        .from('ejercicios')
        .select('*, categorias(*)') // Incluye la relación con la tabla categorias
        .eq('idejercicio', id)
        .single(); // Obtiene un único registro

    exercise = Ejercicio.fromJson(data);
    if (data['categorias'] != null) {
      exercise.categoria = Categoria.fromJson(data['categorias']);
    }

    result.success = true;
    result.data = exercise;

  } catch (e) {
    result.success = false;
    result.errorMessage = e.toString();
  }

  return result;
}
  Future<custom_response.Response> getExercisesByCategory(int id) async {
    List<Ejercicio> exercises = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('ejercicios')
        .select()
        .eq('idcategoria', id);

      exercises = data.map<Ejercicio>((json) => Ejercicio.fromJson(json)).toList();

      result.success = true;
      result.data = exercises;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getExercisesByCategoryWithCategory(int idCategoria) async {
  List<Ejercicio> exercises = [];
  custom_response.Response result = custom_response.Response(success: false);

  try {
    final data = await client
        .from('ejercicios')
        .select('*, categorias(*)') // Incluye la relación con la tabla categorias
        .eq('idcategoria', idCategoria); // Filtra por idCategoria

    exercises = data.map<Ejercicio>((json) {
      Ejercicio exercise = Ejercicio.fromJson(json);
      if (json['categorias'] != null) {
        exercise.categoria = Categoria.fromJson(json['categorias']);
      }
      return exercise;
    }).toList();

    result.success = true;
    result.data = exercises;

  } catch (e) {
    result.success = false;
    result.errorMessage = e.toString();
  }

  return result;
}
  Future<custom_response.Response> addExercise(Ejercicio exercise) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('ejercicios')
        .insert(exercise.toJson());

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> updateExercise(Ejercicio exercise) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('ejercicios')
        .update(exercise.toJson())
        .eq('idejercicio', exercise.idEjercicio);

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> deleteExercise(int id) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('ejercicios')
        .delete()
        .eq('idejercicio', id);

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

}

class _EjerciciosRutinasService {
  Future<custom_response.Response> getEjerciciosByRutinaId(int idRutina) async {
    List<EjercicioRutina> ejerciciosRutina = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('ejercicios_rutina')
        .select()
        .eq('idrutina', idRutina);
        
      ejerciciosRutina = data.map<EjercicioRutina>((json) => EjercicioRutina.fromJson(json)).toList();

      result.success = true;
      result.data = ejerciciosRutina;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getEjerciciosByRutinaIdWithEjercicios(int idRutina) async {
    List<EjercicioRutina> ejerciciosRutina = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('ejercicios_rutina')
          .select('*, ejercicios(*)') // Incluye la relación con las tablas ejercicios y rutinas
          .eq('idrutina', idRutina); // Filtra por idRutina

      ejerciciosRutina = data.map<EjercicioRutina>((json) {
        EjercicioRutina ejercicioRutina = EjercicioRutina.fromJson(json);
        if (json['ejercicios'] != null) {
          ejercicioRutina.ejercicio = Ejercicio.fromJson(json['ejercicios']);
        }
        return ejercicioRutina;
      }).toList();

      result.success = true;
      result.data = ejerciciosRutina;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> addEjercicioRutina(EjercicioRutina ejercicioRutina) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('ejercicios_rutina')
          .insert(ejercicioRutina.toJson()); // Inserta el objeto convertido a JSON
  
      result.success = true;
      result.data = ejercicioRutina;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> updateEjercicioRutina(EjercicioRutina ejercicioRutina) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('ejercicios_rutina')
          .update(ejercicioRutina.toJson()) // Actualiza el objeto convertido a JSON
          .eq('idrutina', ejercicioRutina.idRutina) // Filtra por idRutina
          .eq('idejercicio', ejercicioRutina.idEjercicio); // Filtra por idEjercicio
  
      result.success = true;
      result.data = ejercicioRutina;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> deleteEjercicioRutina(int idRutina, int idEjercicio) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('ejercicios_rutina')
          .delete()
          .eq('idrutina', idRutina) // Filtra por idRutina
          .eq('idejercicio', idEjercicio); // Filtra por idEjercicio
  
      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }

  Future<custom_response.Response> getEjerciciosOfRutina(int idRutina) async {
    List<EjercicioRutina> ejerciciosRutina = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('ejercicios_rutina')
          .select('*, ejercicios(*)') // Incluye la relación con la tabla ejercicios
          .eq('idrutina', idRutina); // Filtra por idRutina

      // Mapea los datos para incluir el objeto ejercicio
      ejerciciosRutina = (data as List).map<EjercicioRutina>((json) {
        EjercicioRutina ejercicioRutina = EjercicioRutina.fromJson(json);
        if (json['ejercicios'] != null) {
          ejercicioRutina.ejercicio = Ejercicio.fromJson(json['ejercicios']);
        }
        return ejercicioRutina;
      }).toList();

      result.success = true;
      result.data = ejerciciosRutina;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
}

class _FotosService {
  Future<custom_response.Response> getPhotos() async {
    List<Foto> photos = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('fotos')
        .select()
        .order('idusuario', ascending: true);

      photos = data.map<Foto>((json) => Foto.fromJson(json)).toList();

      result.success = true;
      result.data = photos;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getPhotoById(int id) async {
    Foto photo = Foto(idFoto: 0, urlFoto: '', idUsuario: 0);
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('fotos')
        .select()
        .eq('idfoto', id);

      photo = Foto.fromJson(data[0]);

      result.success = true;
      result.data = photo;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> getPhotoByUserId(int userId) async {
    List<Foto> photos = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('fotos')
        .select()
        .eq('idusuario', userId);

      photos = data.map<Foto>((json) => Foto.fromJson(json)).toList();

      result.success = true;
      result.data = photos;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> getPhotosByUserIdWithUser(int idUser) async{
    List<Foto> photos = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('fotos')
        .select('idfoto, urlfoto, idusuario, usuarios(*)')
        .eq('idusuario', idUser); // Incluye toda la info del usuario
    
      photos = data.map<Foto>((json) => Foto.fromJson(json)).toList();

      result.success = true;
      result.data = photos;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> addPhoto(Foto photo) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('fotos')
        .insert(photo.toJson());

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> updatePhoto(Foto photo) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('fotos')
        .update(photo.toJson())
        .eq('idfoto', photo.idFoto);

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> deletePhoto(int id) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('fotos')
        .delete()
        .eq('idfoto', id);

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

}

class _GimnasiosService {
  Future<custom_response.Response> getGyms() async {
    List<Gimnasio> gyms = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('gimnasios')
        .select()
        .order('idgimnasio', ascending: true);

      gyms = data.map<Gimnasio>((json) => Gimnasio.fromJson(json)).toList();

      result.success = true;
      result.data = gyms;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getGymById(int id) async {
    Gimnasio gym = Gimnasio(idGimnasio: 0, nombre: '', ubicacion: '');
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('gimnasios')
        .select()
        .eq('idgimnasio', id);

      gym = Gimnasio.fromJson(data[0]);

      result.success = true;
      result.data = gym;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> addGym(Gimnasio gym) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('gimnasios')
        .insert(gym.toJson());

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> updateGym(Gimnasio gym) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('gimnasios')
        .update(gym.toJson())
        .eq('idgimnasio', gym.idGimnasio);

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> deleteGym(int id) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('gimnasios')
        .delete()
        .eq('idgimnasio', id);

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  
}

class _RecompensasService {
  Future<custom_response.Response> getRewards() async {
    List<Recompensa> rewards = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('recompensas')
        .select()
        .order('idrecompensa', ascending: true);

      rewards = data.map<Recompensa>((json) => Recompensa.fromJson(json)).toList();

      result.success = true;
      result.data = rewards;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getRewardById(int id) async {
    Recompensa reward = Recompensa(idRecompensa: 0, nombre: '', descripcion: '', puntosNecesarios: 0);
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('recompensas')
        .select()
        .eq('idrecompensa', id);

      reward = Recompensa.fromJson(data[0]);

      result.success = true;
      result.data = reward;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> addReward(Recompensa reward) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('recompensas')
        .insert(reward.toJson());

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> updateReward(Recompensa reward) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('recompensas')
        .update(reward.toJson())
        .eq('idrecompensa', reward.idRecompensa);

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> deleteReward(int id) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('recompensas')
        .delete()
        .eq('idrecompensa', id);

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

}

class _RecompensasCanjeadasService {
  Future<custom_response.Response> getTradedRewards() async {
    List<RecompensaCanjeada> tradedRewards = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('recompensas_canjeadas')
          .select()
          .order('idrecompensacanjeada', ascending: true); // Ordena por idrecompensacanjeada de forma ascendente

      tradedRewards = data.map<RecompensaCanjeada>((json) => RecompensaCanjeada.fromJson(json)).toList();

      result.success = true;
      result.data = tradedRewards;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> getTradedRewardsByUserId(int idUsuario) async {
    List<RecompensaCanjeada> tradedRewards = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('recompensas_canjeadas')
          .select() // Solo selecciona los campos de la tabla principal
          .eq('idusuario', idUsuario) // Filtra por idUsuario
          .order('idrecompensacanjeada', ascending: true); // Ordena por idrecompensacanjeada

      tradedRewards = data.map<RecompensaCanjeada>((json) => RecompensaCanjeada.fromJson(json)).toList();

      result.success = true;
      result.data = tradedRewards;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> getTradedRewardsWithRewards() async {
    List<RecompensaCanjeada> tradedRewards = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('recompensas_canjeadas')
          .select('*, recompensas(*)') // Incluye la relación con la tabla recompensas
          .order('idrecompensacanjeada', ascending: true); // Ordena por idrecompensacanjeada
  
      tradedRewards = data.map<RecompensaCanjeada>((json) {
        RecompensaCanjeada recompensaCanjeada = RecompensaCanjeada.fromJson(json);
        if (json['recompensas'] != null) {
          recompensaCanjeada.recompensa = Recompensa.fromJson(json['recompensas']);
        }
        return recompensaCanjeada;
      }).toList();
  
      result.success = true;
      result.data = tradedRewards;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
}

class _RecordsPersonalesService {
  Future<custom_response.Response> getRecordsPersonalesByUserId(int idUsuario) async {
    List<RecordPersonal> records = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('records_personales')
          .select() // Selecciona solo los campos de la tabla principal
          .eq('idusuario', idUsuario) // Filtra por idUsuario
          .order('idejercicio', ascending: true); // Ordena por idejercicio
  
      records = data.map<RecordPersonal>((json) => RecordPersonal.fromJson(json)).toList();
  
      result.success = true;
      result.data = records;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getRecordsPersonalesByUserIdWithExercise(int idUsuario) async {
    List<RecordPersonal> records = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('records_personales')
          .select('*, ejercicios(*)') // Incluye la relación con la tabla ejercicios
          .eq('idusuario', idUsuario) // Filtra por idUsuario
          .order('idejercicio', ascending: true); // Ordena por idejercicio
  
      records = data.map<RecordPersonal>((json) {
        RecordPersonal record = RecordPersonal.fromJson(json);
        if (json['ejercicios'] != null) {
          record.ejercicio = Ejercicio.fromJson(json['ejercicios']);
        }
        return record;
      }).toList();
  
      result.success = true;
      result.data = records;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> addRecordPersonal(RecordPersonal record) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
          .from('records_personales')
          .insert(record.toJson()); // Inserta el objeto convertido a JSON

      result.success = true;
      result.data = record;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> updateRecordPersonal(RecordPersonal record) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('records_personales')
          .update(record.toJson()) // Actualiza el objeto convertido a JSON
          .eq('idusuario', record.idUsuario) // Filtra por idUsuario
          .eq('idejercicio', record.idEjercicio); // Filtra por idEjercicio
  
      result.success = true;
      result.data = record;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> deleteRecordPersonal(int idUsuario, int idEjercicio) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('records_personales')
          .delete()
          .eq('idusuario', idUsuario) // Filtra por idUsuario
          .eq('idejercicio', idEjercicio); // Filtra por idEjercicio
  
      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
}

class _RetosService {
  Future<custom_response.Response> getRetos() async {
    List<Reto> retos = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('retos')
          .select()
          .order('idreto', ascending: true); // Ordena por idreto de forma ascendente
  
      retos = data.map<Reto>((json) => Reto.fromJson(json)).toList();
  
      result.success = true;
      result.data = retos;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getRetosWithTipoRetoAndDificultad() async {
    List<Reto> retos = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('retos')
          .select('*, tipos_retos(*), dificultades(*)') // Incluye las relaciones con tipos_retos y dificultades
          .order('idreto', ascending: true); // Ordena por idreto
  
      retos = data.map<Reto>((json) {
        Reto reto = Reto.fromJson(json);
        if (json['tipos_retos'] != null) {
          reto.tipoReto = TipoReto.fromJson(json['tipos_retos']);
        }
        if (json['dificultades'] != null) {
          reto.dificultad = Dificultad.fromJson(json['dificultades']);
        }
        return reto;
      }).toList();
  
      result.success = true;
      result.data = retos;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getRetoById(int id) async {
    Reto reto;
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('retos')
          .select()
          .eq('idreto', id);
  
      reto = Reto.fromJson(data[0]);
  
      result.success = true;
      result.data = reto;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> getRetosByIdWithTipoRetoAndDificultad(int id) async {
    Reto? reto;
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('retos')
          .select('*, tipos_retos(*), dificultades(*)') // Incluye las relaciones con tipos_retos y dificultades
          .eq('idreto', id)
          .single(); // Obtiene un único registro
  
      if (data != null) {
        reto = Reto.fromJson(data);
        if (data['tipos_retos'] != null) {
          reto.tipoReto = TipoReto.fromJson(data['tipos_retos']);
        }
        if (data['dificultades'] != null) {
          reto.dificultad = Dificultad.fromJson(data['dificultades']);
        }
        result.success = true;
        result.data = reto;
      } else {
        result.success = false;
        result.errorMessage = 'No se encontró el reto con el ID proporcionado.';
      }
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> addReto(Reto reto) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('retos')
          .insert(reto.toJson()); // Inserta el objeto convertido a JSON
  
      result.success = true;
      result.data = reto;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> updateReto(Reto reto) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('retos')
          .update(reto.toJson()) // Actualiza el objeto convertido a JSON
          .eq('idreto', reto.idReto); // Filtra por idReto
  
      result.success = true;
      result.data = reto;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> deleteReto(int id) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('retos')
          .delete()
          .eq('idreto', id); // Filtra por idReto
  
      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
}

class _RutinasService {
  Future<custom_response.Response> getRutinas() async {
    List<Rutina> rutinas = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('rutinas')
          .select()
          .order('idrutina', ascending: true); // Ordena por idrutina de forma ascendente
  
      rutinas = data.map<Rutina>((json) => Rutina.fromJson(json)).toList();
  
      result.success = true;
      result.data = rutinas;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getRutinaById(int id) async {
    Rutina rutina;
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('rutinas')
          .select()
          .eq('idrutina', id);
  
      rutina = Rutina.fromJson(data[0]);
  
      result.success = true;
      result.data = rutina;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> addRutina(Rutina rutina) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('rutinas')
          .insert(rutina.toJson()); // Inserta el objeto convertido a JSON
  
      result.success = true;
      result.data = rutina;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> updateRutina(Rutina rutina) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('rutinas')
          .update(rutina.toJson()) // Actualiza el objeto convertido a JSON
          .eq('idrutina', rutina.idRutina); // Filtra por idRutina
  
      result.success = true;
      result.data = rutina;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> deleteRutina(int id) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('rutinas')
          .delete()
          .eq('idrutina', id); // Filtra por idRutina
  
      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }

    Future<custom_response.Response> getRutinaWithEjercicios(int idRutina) async {
      Rutina? rutina;
      custom_response.Response result = custom_response.Response(success: false);
    
      try {
        // Obtiene la rutina por su ID
        final data = await client
            .from('rutinas')
            .select()
            .eq('idrutina', idRutina)
            .single(); // Obtiene un único registro
    
        rutina = Rutina.fromJson(data);
    
        // Obtiene los ejercicios asociados a la rutina
        final ejerciciosResponse = await _EjerciciosRutinasService().getEjerciciosOfRutina(idRutina);
    
        if (ejerciciosResponse.success) {
          rutina.ejercicios = ejerciciosResponse.data as List<EjercicioRutina>;
        } else {
          throw Exception('Error obteniendo ejercicios para la rutina $idRutina: ${ejerciciosResponse.errorMessage}');
        }
    
        result.success = true;
        result.data = rutina;
      } catch (e) {
        result.success = false;
        result.errorMessage = e.toString();
      }
    
      return result;
  } 
  Future<custom_response.Response> getRutinasWithEjercicios() async {
    List<Rutina> rutinas = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      // Obtiene todas las rutinas
      final data = await client
          .from('rutinas')
          .select()
          .order('idrutina', ascending: true);
  
      rutinas = (data as List).map<Rutina>((json) => Rutina.fromJson(json)).toList();
  
      // Itera sobre cada rutina para obtener sus ejercicios
      for (var rutina in rutinas) {
        final ejerciciosResponse = await _EjerciciosRutinasService().getEjerciciosOfRutina(rutina.idRutina!);
        if (ejerciciosResponse.success) {
          rutina.ejercicios = ejerciciosResponse.data as List<EjercicioRutina>;
        } else {
          throw Exception('Error obteniendo ejercicios para la rutina ${rutina.idRutina}: ${ejerciciosResponse.errorMessage}');
        }
      }
  
      result.success = true;
      result.data = rutinas;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
}

class _TiposRetosService {
  Future<custom_response.Response> getTiposRetos() async {
    List<TipoReto> tiposRetos = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('tipos_retos')
          .select()
          .order('idtiporeto', ascending: true); // Ordena por idtiporeto de forma ascendente
  
      tiposRetos = data.map<TipoReto>((json) => TipoReto.fromJson(json)).toList();
  
      result.success = true;
      result.data = tiposRetos;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getTipoRetoById(int id) async {
    TipoReto tipoReto;
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('tipos_retos')
          .select()
          .eq('idtiporeto', id);
  
      tipoReto = TipoReto.fromJson(data[0]);
  
      result.success = true;
      result.data = tipoReto;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> addTipoReto(TipoReto tipoReto) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('tipos_retos')
          .insert(tipoReto.toJson()); // Inserta el objeto convertido a JSON
  
      result.success = true;
      result.data = tipoReto;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> updateTipoReto(TipoReto tipoReto) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('tipos_retos')
          .update(tipoReto.toJson()) // Actualiza el objeto convertido a JSON
          .eq('idtiporeto', tipoReto.idTipoReto); // Filtra por idTipoReto
  
      result.success = true;
      result.data = tipoReto;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> deleteTipoReto(int id) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('tipos_retos')
          .delete()
          .eq('idtiporeto', id); // Filtra por idTipoReto
  
      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
}

class _UsuariosGimnasiosService {
  Future<custom_response.Response> getUsuariosGimnasiosByUserId(int idUsuario) async {
    List<dynamic> usuariosGimnasios = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('usuarios_gimnasios')
          .select() // Selecciona solo los datos de la tabla usuarios_gimnasios
          .eq('idusuario', idUsuario); // Filtra por idUsuario
  
      usuariosGimnasios = data as List<dynamic>;
  
      result.success = true;
      result.data = usuariosGimnasios;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getUsuariosGimnasiosByUserIdWithGyms(int idUsuario) async {
    List<Gimnasio> gimnasios = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('usuarios_gimnasios')
          .select('gimnasios(*)') // Incluye la relación con la tabla gimnasios
          .eq('idusuario', idUsuario); // Filtra por idUsuario
  
      gimnasios = data.map<Gimnasio>((json) {
        if (json['gimnasios'] != null) {
          return Gimnasio.fromJson(json['gimnasios']);
        }
        throw Exception('Datos de gimnasio no encontrados');
      }).toList();
  
      result.success = true;
      result.data = gimnasios;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> addUsuarioGimnasio(UsuarioGimnasio usuarioGimnasio) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('usuarios_gimnasios')
          .insert(usuarioGimnasio.toJson()); // Inserta el objeto convertido a JSON
  
      result.success = true;
      result.data = usuarioGimnasio;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> updateUsuarioGimnasio(UsuarioGimnasio usuarioGimnasio) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('usuarios_gimnasios')
          .update(usuarioGimnasio.toJson()) // Actualiza el objeto convertido a JSON
          .eq('idusuario', usuarioGimnasio.idUsuario) // Filtra por idUsuario
          .eq('idgimnasio', usuarioGimnasio.idGimnasio); // Filtra por idGimnasio
  
      result.success = true;
      result.data = usuarioGimnasio;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> deleteUsuarioGimnasio(int idUsuario, int idGimnasio) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('usuarios_gimnasios')
          .delete()
          .eq('idusuario', idUsuario) // Filtra por idUsuario
          .eq('idgimnasio', idGimnasio); // Filtra por idGimnasio
  
      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }

}

class _UsuariosRetosService {
  Future<custom_response.Response> getUsuariosRetosId(int idUsuario) async {
    List<dynamic> usuariosRetos = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('usuarios_retos')
          .select() // Selecciona solo los datos de la tabla usuarios_retos
          .eq('idusuario', idUsuario); // Filtra por idUsuario
  
      usuariosRetos = data as List<dynamic>;
  
      result.success = true;
      result.data = usuariosRetos;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getUsuariosRetosByIdWithRetos(int idUsuario) async {
    List<Reto> retos = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('usuarios_retos')
          .select('retos(*)') // Incluye la relación con la tabla retos
          .eq('idusuario', idUsuario); // Filtra por idUsuario
  
      retos = data.map<Reto>((json) {
        if (json['retos'] != null) {
          return Reto.fromJson(json['retos']);
        }
        throw Exception('Datos de reto no encontrados');
      }).toList();
  
      result.success = true;
      result.data = retos;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getUsuarioRetoById(int idUsuario, int idReto) async {
    dynamic usuarioReto;
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('usuarios_retos')
          .select() // Selecciona solo los datos de la tabla usuarios_retos
          .eq('idusuario', idUsuario) // Filtra por idUsuario
          .eq('idreto', idReto) // Filtra por idReto
          .single(); // Obtiene un único registro
  
      usuarioReto = data;
  
      result.success = true;
      result.data = usuarioReto;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getUsuarioRetoByIdWithRetos(int idUsuario, int idReto) async {
    dynamic usuarioReto;
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('usuarios_retos')
          .select('*, retos(*)') // Incluye la relación con la tabla retos
          .eq('idusuario', idUsuario) // Filtra por idUsuario
          .eq('idreto', idReto) // Filtra por idReto
          .single(); // Obtiene un único registro
  
      if (data != null) {
        usuarioReto = {
          ...data,
          'reto': data['retos'] != null ? Reto.fromJson(data['retos']) : null,
        };
      }
  
      result.success = true;
      result.data = usuarioReto;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> addUsuarioReto(UsuarioReto usuarioReto) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('usuarios_retos')
          .insert(usuarioReto.toJson()); // Inserta el objeto convertido a JSON
  
      result.success = true;
      result.data = usuarioReto;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> updateUsuarioReto(UsuarioReto usuarioReto) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('usuarios_retos')
          .update(usuarioReto.toJson()) // Actualiza el objeto convertido a JSON
          .eq('idusuario', usuarioReto.idUsuario) // Filtra por idUsuario
          .eq('idreto', usuarioReto.idReto); // Filtra por idReto
  
      result.success = true;
      result.data = usuarioReto;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> deleteUsuarioReto(int idUsuario, int idReto) async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      await client
          .from('usuarios_retos')
          .delete()
          .eq('idusuario', idUsuario) // Filtra por idUsuario
          .eq('idreto', idReto); // Filtra por idReto
  
      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }

}

class _UsuariosRutinasService {
  Future<custom_response.Response> getUsuariosRutinasByUserId(int idUsuario) async {
    List<dynamic> usuariosRutinas = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('usuarios_rutinas')
          .select() // Selecciona solo los datos de la tabla usuarios_rutinas
          .eq('idusuario', idUsuario); // Filtra por idUsuario

      usuariosRutinas = data as List<dynamic>;

      result.success = true;
      result.data = usuariosRutinas;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> getUsuariosRutinasByUserIdWithRutinas(int idUsuario) async {
    List<Rutina> rutinas = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('usuarios_rutinas')
          .select('rutinas(*)') // Incluye la relación con la tabla rutinas
          .eq('idusuario', idUsuario); // Filtra por idUsuario

      rutinas = data.map<Rutina>((json) {
        if (json['rutinas'] != null) {
          return Rutina.fromJson(json['rutinas']);
        }
        throw Exception('Datos de rutina no encontrados');
      }).toList();

      result.success = true;
      result.data = rutinas;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> addUsuarioRutina(UsuarioRutina usuarioRutina) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
          .from('usuarios_rutinas')
          .insert(usuarioRutina.toJson()); // Inserta el objeto convertido a JSON

      result.success = true;
      result.data = usuarioRutina;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> updateUsuarioRutina(UsuarioRutina usuarioRutina) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
          .from('usuarios_rutinas')
          .update(usuarioRutina.toJson()) // Actualiza el objeto convertido a JSON
          .eq('idusuario', usuarioRutina.idUsuario) // Filtra por idUsuario
          .eq('idrutina', usuarioRutina.idRutina); // Filtra por idRutina

      result.success = true;
      result.data = usuarioRutina;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }
  Future<custom_response.Response> deleteUsuarioRutina(int idUsuario, int idRutina) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
          .from('usuarios_rutinas')
          .delete()
          .eq('idusuario', idUsuario) // Filtra por idUsuario
          .eq('idrutina', idRutina); // Filtra por idRutina

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }

  Future<custom_response.Response> getRutinasOfUser(int idUsuario) async {
    List<Rutina> rutinas = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final data = await client
          .from('usuarios_rutinas')
          .select('rutinas(*)') // Incluye la relación con la tabla rutinas
          .eq('idusuario', idUsuario); // Filtra por idUsuario
  
      rutinas = data.map<Rutina>((json) {
        if (json['rutinas'] != null) {
          return Rutina.fromJson(json['rutinas']);
        }
        throw Exception('Datos de rutina no encontrados');
      }).toList();
  
      result.success = true;
      result.data = rutinas;
  
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> getRutinasOfUserWithExercises(int idUsuario) async {
    List<Rutina> rutinas = [];
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      // Obtiene las rutinas asociadas al usuario
      final data = await client
          .from('usuarios_rutinas')
          .select('rutinas(*, ejercicios_rutina(*, ejercicios(*)))') // Incluye rutinas, ejercicios_rutina y ejercicios
          .eq('idusuario', idUsuario); // Filtra por idUsuario
  
      // Mapea los datos para convertirlos en objetos Rutina
      rutinas = data.map<Rutina>((json) {
        if (json['rutinas'] != null) {
          return Rutina.fromJson(json['rutinas']);
        }
        throw Exception('Datos de rutina no encontrados');
      }).toList();
  
      result.success = true;
      result.data = rutinas;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
}

class _UsuariosService {
  Future<custom_response.Response> getUsers() async {
    List<Usuario> users = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('usuarios')
        .select()
        .order('idusuario', ascending: true);

      users = data.map<Usuario>((json) => Usuario.fromJson(json)).toList();

      result.success = true;
      result.data = users;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getUserById(int id) async {
    Usuario user = Usuario(uuid: "", idUsuario: 0, nombre: '', apellido1: '', email: '', nombreUsuario: '', created_at: DateTime.now(), location: "");  
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('usuarios')
        .select()
        .eq('idusuario', id);

      user = Usuario.fromJson(data[0]);

      result.success = true;
      result.data = user;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> getLoggedInUser() async {
    custom_response.Response result = custom_response.Response(success: false);
  
    try {
      final User? currentUser = client.auth.currentUser;
  
      if (currentUser != null) {
        final data = await client
            .from('usuarios')
            .select()
            .eq('uuid', currentUser.id)
            .single();
  
        Usuario user = Usuario.fromJson(data);
  
        result.success = true;
        result.data = user;
      } else {
        result.errorMessage = "No user is currently logged in.";
      }
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
  
    return result;
  }
  Future<custom_response.Response> addUser(Usuario user, String password) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final AuthResponse res = await client.auth.signUp(
        email: user.email,
        password: password
      );
      final User? usuario = res.user;

      user.uuid = usuario?.id;

      await client
        .from('usuarios')
        .insert(user.toJson());

      result.success = true;
      result.data = user;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> login(String email, String password) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final AuthResponse res = await client.auth.signInWithPassword(
        email: email,
        password: password
      );
      final User? usuario = res.user;

      result.success = true;
      result.data = usuario;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> updateUser(Usuario user) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('usuarios')
        .update(user.toJson())
        .eq('idusuario', user.idUsuario);

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
  Future<custom_response.Response> deleteUser(int id) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      await client
        .from('usuarios')
        .delete()
        .eq('idusuario', id);

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

}
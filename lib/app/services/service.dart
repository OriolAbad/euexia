import 'package:euexia/app/data/models/amigos.dart';
import 'package:euexia/app/data/models/categorias.dart';
import 'package:euexia/app/data/models/consejos.dart';
import 'package:euexia/app/data/models/dias_entrenados.dart';
import 'package:euexia/app/data/models/dificultades.dart';
import 'package:euexia/app/data/models/ejercicios.dart';
import 'package:euexia/app/data/models/fotos.dart';
import 'package:euexia/app/data/models/gimnasios.dart';
import 'package:euexia/app/data/models/recompensas.dart';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseClient client = Supabase.instance.client;

  //********AMIGOS********/
  Future<custom_response.Response> getFriends(int idUsuario) async {
    List<Amigo> friends = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
          .from('amigos')
          .select()
          .eq('idusuario1', idUsuario).or('idusuario2.eq.$idUsuario');
      friends = data.map<Amigo>((json) => Amigo.fromJson(json)).toList();

      result.success = true;
      result.data = friends;

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
          .or('idusuario1.eq.$idUsuario1.and.idusuario2.eq.$idUsuario2,idusuario1.eq.$idUsuario2.and.idusuario2.eq.$idUsuario1');

      result.success = true;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }

  //********CATEGORIAS*******/
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

  //********CONSEJOS********/
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

  //********DIAS_ENTRENADOS********/
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


 //*********DIFICULTADES********/
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

  //********EJERCICIOS********/
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
  Future<custom_response.Response> getExerciseByCategory(int id) async {
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
  
  //********FOTOS********/
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

  //********GIMNASIOS********/
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
  
  //********RECOMPENSAS********/
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

  //********RUTINAS********/
  Future<custom_response.Response> getRutina() async {
    List<Rutina> trainingDays = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('rutinas')
        .select()
        .order('idrutina', ascending: true);

      trainingDays = data.map<Rutina>((json) => Rutina.fromJson(json)).toList();

      result.success = true;
      result.data = trainingDays;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }
  Future<custom_response.Response> getRutinaById(int id) async {
    Rutina trainingDay = Rutina(idRutina: 0, nombre: '');
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('rutinas')
        .select()
        .eq('idrutina', id);

      trainingDay = Rutina.fromJson(data[0]);

      result.success = true;
      result.data = trainingDay;

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
        .insert(rutina.toJson());

      result.success = true;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

  //********USERS********/
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
  Future <custom_response.Response> getUserById(int id) async {
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

  //********TIPS********/

  
}





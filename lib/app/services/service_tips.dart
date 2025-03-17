import 'package:euexia/app/data/models/consejos.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseClient client = Supabase.instance.client;

  //********USERS********/
  Future<custom_response.Response> getUsers() async {
    List<Usuarios> users = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('usuarios')
        .select()
        .order('idusuario', ascending: true);

      users = data.map<Usuarios>((json) => Usuarios.fromJson(json)).toList();

      result.success = true;
      result.data = users;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }

  Future <custom_response.Response> getUserById(int id) async {
    Usuarios user = Usuarios(uuid: "", idUsuario: 0, nombre: '', apellido1: '', email: '', nombreUsuario: '', created_at: DateTime.now(), location: "");  
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('usuarios')
        .select()
        .eq('idusuario', id);

      user = Usuarios.fromJson(data[0]);

      result.success = true;
      result.data = user;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

  Future<custom_response.Response> addUser(Usuarios user, String password) async {
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final AuthResponse res = await client.auth.signUp(
        email: user.email,
        password: password
      );
      final Session? session = res.session;
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
      final Session? session = res.session;
      final User? usuario = res.user;

      result.success = true;
      result.data = usuario;
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

  Future<custom_response.Response> updateUser(Usuarios user) async {
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
  Future<custom_response.Response> getTips() async {
    List<Consejos> tips = [];
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('consejos')
        .select()
        .order('idconsejo', ascending: true);

      tips = data.map<Consejos>((json) => Consejos.fromJson(json)).toList();

      result.success = true;
      result.data = tips;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    
    return result;
  }

  Future<custom_response.Response> getTipById(int id) async{
    Consejos tip = Consejos(idconsejo: 0, descripcion: '');
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final data = await client
        .from('consejos')
        .select()
        .eq('idconsejo', id);

      tip = Consejos.fromJson(data[0]);

      result.success = true;
      result.data = tip;

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }

  Future<custom_response.Response> addTip(Consejos tip) async {
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

  Future<custom_response.Response> updateTip(Consejos tip) async {
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





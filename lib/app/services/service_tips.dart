import 'package:euexia/app/data/models/consejos.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseClient client = Supabase.instance.client;


  Future<List<Consejos>> getTips() async {
    
    List<Consejos> tips = [];

    try {
      final data = await client
        .from('consejos')
        .select()
        .order('idconsejo', ascending: true);

      tips = data.map<Consejos>((json) => Consejos.fromJson(json)).toList();

    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
    
    return tips;
  }

  Future<Consejos> getTipById(int id) async{
    Consejos tip = Consejos(idconsejo: 0, descripcion: '');
    try {
      final data = await client
        .from('consejos')
        .select()
        .eq('idconsejo', id);

      tip = Consejos.fromJson(data[0]);

    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
    return tip;
  }

  Future<void> addTip(Consejos tip) async {
    try {
      await client
        .from('consejos')
        .insert(tip.toJson());
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
  
  }

  Future<void> updateTip(Consejos tip) async {
    try {
      await client
        .from('consejos')
        .update(tip.toJson())
        .eq('idconsejo', tip.idconsejo);
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
  }

  Future<void> deleteTip(int id) async {
    try {
      await client
        .from('consejos')
        .delete()
        .eq('idconsejo', id);
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
  }
  
}





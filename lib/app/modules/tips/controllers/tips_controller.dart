import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:euexia/app/data/models/consejos.dart';

class TipsController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  Future<List<Consejos>> getTips() async {
    
    List<Consejos> tips = [];

    try {
      final data = await client
        .from('consejos')
        .select();

      tips = data.map((json) => Consejos.fromJson(json)).toList();

    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
    
    return tips;
  }
}

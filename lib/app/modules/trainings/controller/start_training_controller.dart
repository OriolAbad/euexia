import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/services/service.dart';
import 'package:get/get.dart';

class StartTrainingController extends GetxController
{
  final Rx<Rutina> rutina;
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;
  var updating = false.obs;
  var adding = false.obs;

  

  StartTrainingController(Rutina rutina) : rutina = rutina.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Initialize any necessary data or state here
  }
  
}
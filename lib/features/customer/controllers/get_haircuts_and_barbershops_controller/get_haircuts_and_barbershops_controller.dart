import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:get/get.dart';

import '../../../../data/models/haircut_model/haircut_model.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/haircut_repository.dart';
import '../../../auth/models/barbershop_model.dart';
// Import your HaircutModel

class GetHaircutsAndBarbershopsController extends GetxController {
  static GetHaircutsAndBarbershopsController get instace => Get.find();

  final HaircutRepository _haircutRepository = HaircutRepository();
  final BarbershopRepository _barbershopRepository = BarbershopRepository();

  RxList<HaircutModel> haircuts = <HaircutModel>[].obs;
  RxList<HaircutModel> barbershopHaircuts = <HaircutModel>[].obs;
  RxList<BarbershopModel> barbershops = <BarbershopModel>[].obs;
  var isLoading = true.obs;
  var error = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchAllBarbershops();
  }

//============================================= fetch haircuts
  Future<void> fetchHaircuts() async {
    try {
      isLoading(true);
      haircuts.value = await _haircutRepository.fetchHaircuts();
    } catch (e) {
      ToastNotif(message: 'Error Fetching Haircuts', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading(false);
    }
  }

// Fetch all barbershops and update the state
  Future<void> fetchAllBarbershops() async {
    isLoading.value = true;
    try {
      // Fetch data from the repository

      barbershops.value = await _barbershopRepository.fetchAllBarbershops();
    } catch (e) {
      // Handle and display error
      ToastNotif(message: 'Error fetching barbershops', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all barbershop haircuts
  Future<void> fetchAllBarbershoHaircuts(String barbershopId) async {
    isLoading.value = true;
    try {
      // fetch data from the repo

      barbershopHaircuts.value =
          await _barbershopRepository.fetchBarbershopHaircuts(barbershopId);
    } catch (e) {
      // Handle and display error
      ToastNotif(message: 'Error fetching barbershops', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }
}

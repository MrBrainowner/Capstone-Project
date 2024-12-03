import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate/features/auth/models/barbershop_model.dart';

class BarbershopWithHaircuts {
  final BarbershopModel barbershop;
  final List<HaircutModel> haircuts;

  BarbershopWithHaircuts({required this.barbershop, required this.haircuts});
}

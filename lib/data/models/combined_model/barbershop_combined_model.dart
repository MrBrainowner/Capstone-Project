import 'package:barbermate/data/models/available_days/available_days.dart';
import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/models/timeslot_model/timeslot_model.dart';
import 'package:barbermate/data/models/user_authenthication_model/barbershop_model.dart';

class BarbershopCombinedModel {
  final BarbershopModel barbershop;
  final List<HaircutModel> haircuts;
  final List<TimeSlotModel> timeslot;
  final AvailableDaysModel? availableDays;
  final List<ReviewsModel> review;

  BarbershopCombinedModel(
      {required this.timeslot,
      required this.review,
      required this.availableDays,
      required this.barbershop,
      required this.haircuts});

  // Empty method for BarbershopCombinedModel
  static BarbershopCombinedModel empty() {
    return BarbershopCombinedModel(
      barbershop:
          BarbershopModel.empty(), // Use the empty method of BarbershopModel
      haircuts: [],
      timeslot: [],
      availableDays: null,
      review: [],
    );
  }
}

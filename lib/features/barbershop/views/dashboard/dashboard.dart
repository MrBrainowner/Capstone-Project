import 'package:barbermate/features/barbershop/controllers/barbers_controller/barbers_controller.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/barbershop/controllers/haircuts_controller/haircuts_controller.dart';
import 'package:barbermate/features/barbershop/controllers/review_controller/review_controller.dart';
import 'package:barbermate/features/barbershop/controllers/timeslot_controller/timeslot_controller.dart';
import 'package:barbermate/features/barbershop/views/appointments/appointments.dart';
import 'package:barbermate/features/barbershop/views/management/haircut/management.dart';
import 'package:barbermate/features/barbershop/views/reviews/reviews.dart';
import 'package:barbermate/features/barbershop/views/widgets/appbar/appbar.dart';
import 'package:barbermate/features/barbershop/views/widgets/dashboard/overview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import '../management/barbers/management.dart';
import '../drawer/drawer.dart';
import '../management/timeslots/timeslots.dart';

class BarbershopDashboard extends StatelessWidget {
  const BarbershopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = Get.put(BarbershopController());
    final haircutController = Get.put(HaircutController());
    final barberController = Get.put(BarberController());
    final timeSlotController = Get.put(TimeSlotController());
    final bookingController = Get.put(BarbershopBookingController());
    final reviewsController = Get.put(ReviewController());

    return Scaffold(
      key: scaffoldKey,
      appBar: BarbershopAppBar(
        centertitle: false,
        scaffoldKey: scaffoldKey,
        title: Text(
          '',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      drawer: const BarbershopDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchBarbershopData();
          haircutController.fetchHaircuts();
          barberController.fetchBarbers();
          timeSlotController.fetchTimeSlots();
          bookingController.fetchBookings();
          reviewsController.fetchReviewsForBarbershop();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Flexible(
                            child: Obx(
                              () => Text(
                                'Welcome to Barbermate, ${controller.barbershop.value.barbershopName}',
                                maxLines: 3,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                  const SizedBox(height: 90),
                  Text('Haircut Styles | Time Slots | Barbers',
                      style: Theme.of(context).textTheme.labelSmall),
                  Row(
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          Get.to(() =>
                                              const HaircutManagementPage());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const iconoir.Scissor(
                                              height: 25,
                                            ),
                                            const SizedBox(width: 10),
                                            Obx(
                                              () => Text(
                                                  '${haircutController.haircuts.length}'),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(width: 5),
                              Row(
                                children: [
                                  SizedBox(
                                    child: OutlinedButton(
                                        onPressed: () {
                                          Get.to(() => const TimeslotsPage());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const iconoir.Timer(
                                              height: 25,
                                            ),
                                            const SizedBox(width: 10),
                                            Obx(
                                              () => Text(
                                                  '${timeSlotController.timeSlots.length}'),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(width: 5),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => const ManageBarbersPage());
                                    },
                                    child: Row(
                                      children: [
                                        const iconoir.Group(
                                            height: 25,
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1)),
                                        const SizedBox(width: 10),
                                        Obx(() => Text(
                                            '${barberController.barbers.length}')),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Overview',
                      style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OverviewCard(
                            flex1: 1,
                            flex2: 0,
                            color: Colors.blue.shade100,
                            color2: Colors.white,
                            title: 'Total Appointments',
                            sometext: '${bookingController.bookings.length}',
                            titl2: '   ',
                            sometext2: '   ',
                            onTapCard1: () =>
                                Get.to(() => const BarbershopAppointments()),
                            onTapCard2: () {},
                          ),
                          OverviewCard(
                            flex1: 0,
                            flex2: 1,
                            color: Colors.white,
                            color2: Colors.orange.shade100,
                            title: '    ',
                            sometext: '   ',
                            titl2: 'Upcoming Appointments',
                            sometext2:
                                '${bookingController.confirmedBookings.length}',
                            onTapCard1: null,
                            onTapCard2: () =>
                                Get.to(() => const BarbershopAppointments()),
                          ),
                          OverviewCard(
                            flex1: 1,
                            flex2: 0,
                            color: Colors.yellow.shade100,
                            color2: Colors.white,
                            title: 'Reviews',
                            sometext: "${reviewsController.reviewsList.length}",
                            titl2: '   ',
                            sometext2: '   ',
                            onTapCard1: () => Get.to(() => const ReviewsPage()),
                            onTapCard2: null,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

// ignore_for_file: deprecated_member_use

import 'package:card_swiper/card_swiper.dart';
import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/home_controller.dart';
import 'package:finpay/controller/reserva_controller.dart';
import 'package:finpay/controller/alumno/reserva_alumno_controller.dart';
import 'package:finpay/utils/utiles.dart';
import 'package:finpay/view/home/top_up_screen.dart';
import 'package:finpay/view/home/transfer_screen.dart';
import 'package:finpay/view/home/widget/circle_card.dart';
import 'package:finpay/view/home/widget/custom_card.dart';
import 'package:finpay/view/home/widget/transaction_list.dart';
import 'package:finpay/view/reservas/reservas_screen.dart';
import 'package:finpay/view/alumno/reserva_alumno_screen.dart';
import 'package:finpay/view/pago/pago_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final HomeController homeController;

  const HomeView({Key? key, required this.homeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.isLightTheme == false
          ? const Color(0xff15141F)
          : Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good morning",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).textTheme.bodySmall!.color,
                          ),
                    ),
                    Text(
                      "Good morning",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 28,
                      width: 69,
                      decoration: BoxDecoration(
                        color: const Color(0xffF6A609).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            DefaultImages.ranking,
                          ),
                          Text(
                            "Gold",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: const Color(0xffF6A609),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset(
                        DefaultImages.avatar,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.isLightTheme ? Colors.white : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Estadísticas",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          "Pagos del Mes",
                          homeController.pagosMesActual.value.toString(),
                          Icons.payments,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          "Pagos Pendientes",
                          homeController.pagosPendientes.value.toString(),
                          Icons.pending_actions,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          "Total Autos",
                          homeController.totalAutos.value.toString(),
                          Icons.directions_car,
                          Colors.green,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.isLightTheme == false
                                ? HexColor('#15141f')
                                : Theme.of(context).appBarTheme.backgroundColor,
                            border: Border.all(
                              color: HexColor(AppTheme.primaryColorString!)
                                  .withOpacity(0.05),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                customContainer(
                                  title: "USD",
                                  background: AppTheme.primaryColorString,
                                  textColor: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                customContainer(
                                  title: "IDR",
                                  background: AppTheme.isLightTheme == false
                                      ? '#211F32'
                                      : "#FFFFFF",
                                  textColor: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => PagoScreen(),
                              transition: Transition.downToUp,
                              duration: const Duration(milliseconds: 500));
                        },
                        child: circleCard(
                          image: DefaultImages.topup,
                          title: "Pagar",
                        ),
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {},
                        child: circleCard(
                          image: DefaultImages.withdraw,
                          title: "Withdraw",
                        ),
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(
                            () => ReservaAlumnoScreen(),
                            binding: BindingsBuilder(() {
                              Get.delete<ReservaAlumnoController>();
                              Get.create(() => ReservaAlumnoController());
                            }),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        child: circleCard(
                          image: DefaultImages.transfer,
                          title: "Reservar",
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.isLightTheme == false
                            ? const Color(0xff211F32)
                            : const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff000000).withOpacity(0.10),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Pagos previos",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(() {
                            return Column(
                              children: homeController.pagosPrevios.map((pago) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    leading: const Icon(Icons.payments_outlined),
                                    title: Text(
                                        "Reserva: ${pago.codigoReservaAsociada}"),
                                    subtitle: Text(
                                        "Fecha: ${UtilesApp.formatearFechaDdMMAaaa(pago.fechaPago)}"),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "- ${UtilesApp.formatearGuaranies(pago.montoPagado)}",
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.red),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Eliminar Pago'),
                                                content: const Text(
                                                    '¿Estás seguro que deseas eliminar este pago?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Cancelar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      homeController
                                                          .eliminarPago(pago);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Eliminar',
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

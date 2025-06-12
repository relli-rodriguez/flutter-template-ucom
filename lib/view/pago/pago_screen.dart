import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/pago_controller.dart';
import 'package:finpay/utils/utiles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PagoScreen extends StatelessWidget {
  final controller = Get.put(PagoController());

  PagoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagar Reservas"),
        elevation: 0,
        backgroundColor: const Color(0xFF4A4A4A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4A4A4A).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.reservasPendientes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No hay reservas pendientes de pago",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.reservasPendientes.length,
            itemBuilder: (context, index) {
              final reserva = controller.reservasPendientes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Reserva #${reserva.codigoReserva}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Pendiente",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        "Auto",
                        reserva.chapaAuto,
                        Icons.directions_car,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        "Horario",
                        "${UtilesApp.formatearFechaDdMMAaaa(reserva.horarioInicio)} - ${TimeOfDay.fromDateTime(reserva.horarioInicio).format(context)}",
                        Icons.access_time,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        "Duración",
                        "${reserva.horarioSalida.difference(reserva.horarioInicio).inHours} horas",
                        Icons.timer,
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total a pagar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            UtilesApp.formatearGuaranies(reserva.monto),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final confirmado = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirmar Pago"),
                                content: Text(
                                  "¿Deseas realizar el pago de ${UtilesApp.formatearGuaranies(reserva.monto)}?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancelar"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text("Confirmar"),
                                  ),
                                ],
                              ),
                            );

                            if (confirmado == true) {
                              final exitoso = await controller.realizarPago(reserva);
                              if (exitoso) {
                                Get.snackbar(
                                  "Éxito",
                                  "El pago se realizó correctamente",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green.shade100,
                                  colorText: Colors.green.shade900,
                                );
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "No se pudo realizar el pago",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red.shade100,
                                  colorText: Colors.red.shade900,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A4A4A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Realizar Pago",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 
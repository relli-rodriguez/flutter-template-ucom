import 'package:finpay/api/local.db.service.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:finpay/controller/home_controller.dart';
import 'package:get/get.dart';

class PagoController extends GetxController {
  final db = LocalDBService();
  RxList<Reserva> reservasPendientes = <Reserva>[].obs;
  Rx<Reserva?> reservaSeleccionada = Rx<Reserva?>(null);

  @override
  void onInit() {
    super.onInit();
    cargarReservasPendientes();
  }

  Future<void> cargarReservasPendientes() async {
    final data = await db.getAll("reservas.json");
    final reservas = data.map((json) => Reserva.fromJson(json)).toList();
    reservasPendientes.value = reservas.where((r) => r.estado == "PENDIENTE").toList();
  }

  Future<bool> realizarPago(Reserva reserva) async {
    try {
      // Crear el pago
      final nuevoPago = Pago(
        codigoPago: "PAG-${DateTime.now().millisecondsSinceEpoch}",
        codigoReservaAsociada: reserva.codigoReserva,
        montoPagado: reserva.monto,
        fechaPago: DateTime.now(),
      );

      // Guardar el pago
      final pagos = await db.getAll("pagos.json");
      pagos.add(nuevoPago.toJson());
      await db.saveAll("pagos.json", pagos);

      // Obtener la reserva actualizada con el código del lugar
      final reservas = await db.getAll("reservas.json");
      final reservaIndex = reservas.indexWhere((r) => r['codigoReserva'] == reserva.codigoReserva);
      if (reservaIndex == -1) return false;

      // Actualizar estado de la reserva
      reservas[reservaIndex]['estado'] = "PAGADO";
      await db.saveAll("reservas.json", reservas);

      // Liberar el lugar específico de esta reserva
      final lugares = await db.getAll("lugares.json");
      final lugarIndex = lugares.indexWhere(
        (l) => l['codigoLugar'] == reservas[reservaIndex]['codigoLugar'],
      );
      if (lugarIndex != -1) {
        lugares[lugarIndex]['estado'] = "DISPONIBLE";
        await db.saveAll("lugares.json", lugares);
      }

      // Actualizar contadores en HomeController
      final homeController = Get.find<HomeController>();
      await homeController.actualizarContadoresPago();

      // Actualizar lista de reservas pendientes
      await cargarReservasPendientes();
      return true;
    } catch (e) {
      print("Error al realizar el pago: $e");
      return false;
    }
  }
} 
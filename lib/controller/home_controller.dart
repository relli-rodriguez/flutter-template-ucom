// ignore_for_file: deprecated_member_use

import 'package:finpay/api/local.db.service.dart';
import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:finpay/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<TransactionModel> transactionList = List<TransactionModel>.empty().obs;
  RxBool isWeek = true.obs;
  RxBool isMonth = false.obs;
  RxBool isYear = false.obs;
  RxBool isAdd = false.obs;
  RxList<Pago> pagosPrevios = <Pago>[].obs;
  RxInt pagosMesActual = 0.obs;
  RxInt pagosPendientes = 0.obs;
  RxInt totalAutos = 0.obs;
  RxList<Reserva> reservasList = <Reserva>[].obs;

  // Método para actualizar contadores cuando se hace una reserva
  Future<void> actualizarContadoresReserva() async {
    totalAutos.value++;
    pagosPendientes.value++;
    update();
  }

  // Método para actualizar contadores cuando se hace un pago
  Future<void> actualizarContadoresPago() async {
    pagosPendientes.value--;
    pagosMesActual.value++;
    update();
  }

  Future<void> cargarEstadisticas() async {
    try {
      final db = LocalDBService();
      
      // Cargar pagos del mes actual
      final ahora = DateTime.now();
      final inicioMes = DateTime(ahora.year, ahora.month, 1);
      final finMes = DateTime(ahora.year, ahora.month + 1, 0);
      
      print('Cargando estadísticas...');
      print('Período: ${inicioMes.toString()} - ${finMes.toString()}');
      
      // Cargar todos los pagos
      final pagos = await db.getAll("pagos.json");
      print('Pagos encontrados: ${pagos?.length ?? 0}');
      
      if (pagos != null && pagos.isNotEmpty) {
        // Contar pagos del mes actual
        final pagosDelMes = pagos.where((pago) {
          try {
            if (pago['fechaPago'] == null) {
              print('Pago sin fecha: ${pago['codigoPago']}');
              return false;
            }
            final fechaPago = DateTime.parse(pago['fechaPago']);
            final esDelMes = fechaPago.isAfter(inicioMes) && fechaPago.isBefore(finMes);
            if (esDelMes) {
              print('Pago del mes encontrado: ${pago['codigoPago']} - ${fechaPago.toString()}');
            }
            return esDelMes;
          } catch (e) {
            print('Error al procesar fecha de pago ${pago['codigoPago']}: $e');
            return false;
          }
        }).toList();
        
        pagosMesActual.value = pagosDelMes.length;
        print('Pagos del mes actual: ${pagosMesActual.value}');
        
        // Cargar todos los pagos previos
        pagosPrevios.value = pagos.map((json) => Pago.fromJson(json)).toList();
        print('Total de pagos cargados: ${pagosPrevios.length}');
      } else {
        print('No se encontraron pagos');
        pagosMesActual.value = 0;
        pagosPrevios.value = [];
      }

      // Cargar reservas pendientes
      final reservas = await db.getAll("reservas.json");
      print('Reservas encontradas: ${reservas?.length ?? 0}');
      
      if (reservas != null && reservas.isNotEmpty) {
        // Contar reservas pendientes
        final reservasPendientes = reservas.where((reserva) {
          try {
            if (reserva['estado'] == null) {
              print('Reserva sin estado: ${reserva['codigoReserva']}');
              return false;
            }
            final esPendiente = reserva['estado'] == "PENDIENTE";
            if (esPendiente) {
              print('Reserva pendiente encontrada: ${reserva['codigoReserva']}');
            }
            return esPendiente;
          } catch (e) {
            print('Error al procesar estado de reserva ${reserva['codigoReserva']}: $e');
            return false;
          }
        }).toList();
        
        pagosPendientes.value = reservasPendientes.length;
        print('Reservas pendientes: ${pagosPendientes.value}');
        
        // Cargar todas las reservas
        reservasList.value = reservas.map((json) => Reserva.fromJson(json)).toList();
        print('Total de reservas cargadas: ${reservasList.length}');
      } else {
        print('No se encontraron reservas');
        pagosPendientes.value = 0;
        reservasList.value = [];
      }

      // Cargar total de autos
      final autos = await db.getAll("autos.json");
      print('Autos encontrados: ${autos?.length ?? 0}');
      
      if (autos != null && autos.isNotEmpty) {
        totalAutos.value = autos.length;
        print('Total de autos: ${totalAutos.value}');
      } else {
        print('No se encontraron autos');
        totalAutos.value = 0;
      }
      
      print('Estadísticas cargadas:');
      print('Pagos del mes: ${pagosMesActual.value}');
      print('Pagos pendientes: ${pagosPendientes.value}');
      print('Total autos: ${totalAutos.value}');
      print('Total reservas: ${reservasList.value.length}');
      print('Total pagos: ${pagosPrevios.value.length}');
      
      // Forzar actualización de la UI
      update();
    } catch (e) {
      print('Error al cargar estadísticas: $e');
      pagosMesActual.value = 0;
      pagosPendientes.value = 0;
      totalAutos.value = 0;
      pagosPrevios.value = [];
      reservasList.value = [];
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    print('Inicializando HomeController...');
    customInit();
  }

  customInit() async {
    try {
      print('Ejecutando customInit...');
      await cargarEstadisticas();
      isWeek.value = true;
      isMonth.value = false;
      isYear.value = false;
      update();
    } catch (e) {
      print('Error en customInit: $e');
    }
  }

  Future<void> eliminarPago(Pago pago) async {
    try {
      final db = LocalDBService();
      final data = await db.getAll("pagos.json");
      if (data != null && data.isNotEmpty) {
        data.removeWhere((p) => p['codigoPago'] == pago.codigoPago);
        await db.saveAll("pagos.json", data);
        await cargarEstadisticas(); // Recargar todas las estadísticas
      }
    } catch (e) {
      print('Error al eliminar pago: $e');
    }
  }
}

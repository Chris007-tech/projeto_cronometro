import 'package:flutter/material.dart';

class CronometroViewModel extends ChangeNotifier {
  int duracao = 10;
  bool rodando = false;
  final List<Volta> voltas = [];

  void definirDuracao(int segundos) {
    duracao = segundos;
    notifyListeners();
  }

  void iniciar() {
    rodando = true;
    notifyListeners();
  }

  void pausar() {
    rodando = false;
    notifyListeners();
  }

  void reiniciar() {
    rodando = false;
    voltas.clear();
    notifyListeners();
  }

  void registrarVolta(Duration tempoVolta, Duration tempoTotal) {
    voltas.add(Volta(tempoVolta: tempoVolta, tempoTotal: tempoTotal));
    notifyListeners();
  }
}

class Volta {
  final Duration tempoVolta;
  final Duration tempoTotal;

  Volta({required this.tempoVolta, required this.tempoTotal});
}

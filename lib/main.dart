import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/cronometro_viewmodel.dart';
import 'views/cronometro_pagina.dart';
import 'servicos/notificacao_servico.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificacaoServico.inicializar();

  runApp(
    ChangeNotifierProvider(
      create: (_) => CronometroViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cronômetro MVVM",
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const CronometroPagina(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../viewmodels/cronometro_viewmodel.dart';
import '../servicos/notificacao_servico.dart';

class CronometroPagina extends StatefulWidget {
  const CronometroPagina({super.key});

  @override
  State<CronometroPagina> createState() => _CronometroPaginaState();
}

class _CronometroPaginaState extends State<CronometroPagina> {
  final _controladorTexto = TextEditingController();
  final _controladorCircular = CountDownController();

  @override
  void dispose() {
    _controladorTexto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CronometroViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cronômetro Circular"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorTexto,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Duração em segundos",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final valor = int.tryParse(_controladorTexto.text);
                    if (valor != null && valor > 0) {
                      vm.definirDuracao(valor);
                      _controladorCircular.restart(duration: valor);
                      NotificacaoServico.mostrar(
                        "Cronômetro",
                        "Cronômetro ajustado para $valor segundos",
                      );
                    }
                  },
                  child: const Text("Guardar"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: CircularCountDownTimer(
                duration: vm.duracao,
                initialDuration: 0,
                controller: _controladorCircular,
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                ringColor: Colors.grey[300]!,
                fillColor: Colors.purpleAccent[100]!,
                backgroundColor: Colors.purple[500],
                strokeWidth: 20,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(
                  fontSize: 33,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textFormat: CountdownTextFormat.S,
                autoStart: false,
                onStart: () {
                  vm.iniciar();
                  NotificacaoServico.mostrar(
                    "Cronômetro",
                    "Cronômetro iniciado!",
                  );
                },
                onComplete: () {
                  vm.pausar();
                  NotificacaoServico.mostrar("Cronômetro", "O tempo terminou!");
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _botao("Começar", () => _controladorCircular.start()),
              _botao("Pausar", () => _controladorCircular.pause()),
              _botao("Continuar", () => _controladorCircular.resume()),
              _botao("Reiniciar", () {
                vm.reiniciar();
                _controladorCircular.restart(duration: vm.duracao);
                NotificacaoServico.mostrar(
                  "Cronômetro",
                  "Cronômetro reiniciado!",
                );
              }),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: vm.voltas.length,
              itemBuilder: (context, i) {
                final volta = vm.voltas[i];
                return ListTile(
                  leading: const Icon(Icons.timer),
                  title: Text(
                    "Volta ${i + 1} - ${volta.tempoVolta.inSeconds}s "
                    "(Total: ${volta.tempoTotal.inSeconds}s)",
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.flag),
        onPressed: () {
          vm.registrarVolta(
            const Duration(seconds: 5),
            Duration(seconds: vm.duracao),
          );
          NotificacaoServico.mostrar("Nova Volta", "Você registrou uma volta!");
        },
      ),
    );
  }

  Widget _botao(String titulo, VoidCallback acao) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(onPressed: acao, child: Text(titulo)),
    );
  }
}

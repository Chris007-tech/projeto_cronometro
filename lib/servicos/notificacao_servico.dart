import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacaoServico {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  static Future<void> mostrar(String titulo, String corpo) async {
    const android = AndroidNotificationDetails(
      'canal_simples',
      'Notificações Simples',
      channelDescription: 'Canal para notificações básicas',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const detalhes = NotificationDetails(android: android);

    await _plugin.show(0, titulo, corpo, detalhes);
  }
}

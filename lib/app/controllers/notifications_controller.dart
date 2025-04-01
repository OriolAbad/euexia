import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationController {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();


  // Inicializar el plugin de notificaciones
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Manejar cuando se toca la notificación
        print('Notificación tocada: ${response.payload}');
      },
    );
  }

  // Método actualizado para solicitar permisos en iOS/macOS
static Future<bool> requestIOSPermissions() async {
  try {
    final IOSFlutterLocalNotificationsPlugin? iosPlugin = 
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      // Configuración de permisos para iOS/macOS
      final bool granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ?? false;
      return granted;
    }
    return false;
  } catch (e) {
    debugPrint('Error al solicitar permisos de notificación: $e');
    return false;
  }
}

  // Mostrar notificación con acciones (botones Sí/No)
  static Future<void> showNotificationWithActions({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // ID del canal
      'Your Channel Name', // Nombre del canal
      channelDescription: 'Your Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'yes_action', 
          'Sí',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'no_action', 
          'No',
          showsUserInterface: true,
        ),
      ],
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      0, // ID de la notificación
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Configurar el manejador de acciones (para cuando se pulsa Sí o No)
  static void configureActionStream(Function(String) onActionSelected) {
    _notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.actionId?.isNotEmpty ?? false) {
          // Se ha pulsado una acción (Sí o No)
          onActionSelected(response.actionId!);
        } else {
          // Se ha pulsado la notificación directamente
          onActionSelected('notification_tapped');
        }
      },
    );
  }
}
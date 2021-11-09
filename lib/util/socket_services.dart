import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants.dart';

class SocketServices {
  static SocketServices _instance = new SocketServices._internal();

  IO.Socket? socket;
  var screen;

  factory SocketServices() {
    return _instance;
  }

  SocketServices._internal();

  initialize() {
    String namespace = "sock";
    String socketUrl = baseUrl + namespace;
    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.onConnect((_) {
      socket!.emit('message_event', 'Connected, ms server!');
      if (this.screen != null) {
        this.screen.update();
      }
    });
    socket!.onDisconnect((_) {
      socket!.emit('message_event', 'sorry ms server, disconnected!');
    });
    socket!.on('message_event', (data) => print(data));
    socket!.open();
    print("quick socket test");
    print(socket!.connected);
  }

  setScreen(var screen) {
    this.screen = screen;
  }

  isConnected() {
    print("another quick socket test");
    if (socket == null) {
      print("WAAT?!");
      return false;
    }
    print(socket!.connected);
    return socket!.connected;
  }
}
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
  }

  setScreen(var screen) {
    this.screen = screen;
  }

  isConnected() {
    if (socket == null) {
      return false;
    }
    return socket!.connected;
  }

  leaveRoom(String room) {
    if (socket!.connected) {
      // The room could be for a chat
      // roomSolo is the room for this phone specifically
      socket!.emit(
        "leave",
        {
          "room": room,
        },
      );
    }
  }

  joinRoom(String room) {
    if (socket!.connected) {
      // The room could be for a chat
      // roomSolo is the room for this phone specifically
      socket!.emit(
        "join",
        {
          "room": room,
        },
      );
    }
  }

  sendMessage(String message, String room) {
    if (socket!.connected) {
      // The room could be for a chat
      // roomSolo is the room for this phone specifically
      socket!.emit(
        "message",
        {
          "id": 1.toString(),
          "message": message,
          "room": room,
        },
      );
    }
  }
}
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
      this.screen!.update();
    });
    socket!.onDisconnect((_) {
      socket!.emit('message_event', 'sorry ms server, disconnected!');
      this.screen!.update();
    });
    socket!.on('message_event', (data) {
      print(data);
      this.screen.updateDebugString(data);
    });
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

  joinRoomSolo() {
    if (socket!.connected) {
      String room = "room_1";
      // roomSolo is the room for this phone specifically
      // We will activate the listening for the room responses from the server
      socket!.on('message_event_send_solo', (data) =>
          this.screen.messageReceivedSolo(data));

      socket!.emit(
        "join",
        {
          "room": room,
        },
      );
    }
  }

  joinRoomChat() {
    if (socket!.connected) {
      String room = "1_2";
      // The room could be for a chat
      // We will activate the listening for the room responses from the server
      socket!.on('message_event_send', (data) =>
          this.screen.messageReceivedChat(data));

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

  sendMessageWithDelay(String message, String room) {
    if (socket!.connected) {
      // The room could be for a chat
      // roomSolo is the room for this phone specifically
      socket!.emit(
        "message_with_delay",
        {
          "id": 1.toString(),
          "message": message,
          "room": room,
        },
      );
    }
  }

  sendMessageCustom(String message, String room) {
    if (socket!.connected) {
      // The room could be for a chat
      // roomSolo is the room for this phone specifically
      socket!.emit(
        "message_custom",
        {
          "id": 1.toString(),
          "message": message,
          "room": room,
        },
      );
    }
  }

  sendMessageWithDelayCustom(String message, String room) {
    if (socket!.connected) {
      // The room could be for a chat
      // roomSolo is the room for this phone specifically
      socket!.emit(
        "message_with_delay_custom",
        {
          "id": 1.toString(),
          "message": message,
          "room": room,
        },
      );
    }
  }

  sendRegistrationId(String registrationId, String room) {
    if (socket!.connected) {
      // The room could be for a chat
      // roomSolo is the room for this phone specifically
      socket!.emit(
        "set_registration",
        {
          "registration_id": registrationId,
          "room": room,
        },
      );
    }
  }
}
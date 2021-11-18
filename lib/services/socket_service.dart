import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {

  static final SocketService _instance = SocketService._internal();

  IO.Socket? socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

}
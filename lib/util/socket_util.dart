import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketUtil {

  static final SocketUtil _instance = SocketUtil._internal();

  IO.Socket? socket;

  factory SocketUtil() {
    return _instance;
  }

  SocketUtil._internal();

}
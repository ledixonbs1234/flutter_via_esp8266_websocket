import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:web_socket_channel/io.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  void startBegin() {
    io.Socket socket = io.io(
        "http://192.168.1.180:3000",
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'foo': 'bar'})
            .build());

    socket.onConnect((data) {
      print('connect');
      socket.emit('msg', 'test');
    });

    socket.on('event', (data) => print(data));
    socket.onDisconnect((data) => print("Disconnect"));
    socket.on('fromServer', (data) => print(data));
    socket.connect();
    print("Da chay trong nay");
  }

  IOWebSocketChannel? channel;
  bool connected = false;

  void beginAll() {
    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      channel!.sink.add(cmd);
    } else {
      channelconnect();
      print('Websocket not connect');
    }
  }

  void buttonPress() {
    sendcmd('poweron');
  }

  channelconnect() {
    //function to connect
    try {
      channel = IOWebSocketChannel.connect(
          "ws://192.168.1.180:3000"); //channel IP : Port
      channel!.stream.listen(
        (message) {
          print(message);
          if (message == "connected") {
            connected = true; //message is "connected" from NodeMCU
          } else if (message == "poweron:success") {
            print("led on");
          } else if (message == "poweroff:success") {
            print("led off");
          }
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          connected = false;
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

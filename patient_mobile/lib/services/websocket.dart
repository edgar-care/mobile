import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  WebSocketChannel? _channel;
  String? authToken;

  // Callback functions
  Function(Map<String, dynamic>)? onReceiveMessage;
  Function(Map<String, dynamic>)? onReady;
  Function(Map<String, dynamic>)? onCreateChat;
  Function(Map<String, dynamic>)? onGetMessages;
  Function(Map<String, dynamic>)? onReadMessage;
  Function(Map<String, dynamic>)? onAskMobileConnection;
  Function(Map<String, dynamic>)? onResponseMobileConnection;

  WebSocketService({
    this.onReceiveMessage,
    this.onReady,
    this.onCreateChat,
    this.onGetMessages,
    this.onReadMessage,
    this.onResponseMobileConnection,
    this.onAskMobileConnection,
  });

  // Connect to WebSocket
  Future<void> connect() async {
    await _retrieveToken();

    if (authToken == null) {
      return;
    }

    final url = dotenv.env['WEBSOCKET_URL'];
    if (url == null) {
      return;
    }

    _channel = WebSocketChannel.connect(Uri.parse(url));

    // Listen for incoming messages
    _channel?.stream.listen((message) {
      _handleMessage(message);
    }, onError: (error) {
    }, onDone: () {
    });

    sendReadyAction();
  }

  // Retrieve the token from shared preferences
  Future<void> _retrieveToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token');
  }

  // Disconnect from WebSocket
  void disconnect() {
    _channel?.sink.close(status.goingAway);
  }

  // Send 'ready' action
  void sendReadyAction() {
    if (authToken == null) return;

    final readyMessage = jsonEncode({
      'action': 'ready',
      'authToken': authToken,
    });
    _channel?.sink.add(readyMessage);
  }

  // Create a new chat
  void createChat(String message, List<String> recipientIds) {
    if (authToken == null) return;

    final createChatMessage = jsonEncode({
      'action': 'create_chat',
      'authToken': authToken,
      'message': message,
      'recipient_ids': recipientIds,
    });
    _channel?.sink.add(createChatMessage);
  }

  // Get messages
  void getMessages() {
    if (authToken == null) return;

    final getMessagesMessage = jsonEncode({
      'action': 'get_messages',
      'authToken': authToken,
    });
    _channel?.sink.add(getMessagesMessage);
  }

  // Send a message to a chat
  void sendMessage(String chatId, String message) {
    if (authToken == null) return;

    final sendMessage = jsonEncode({
      'action': 'send_message',
      'authToken': authToken,
      'chat_id': chatId,
      'message': message,
    });
    _channel?.sink.add(sendMessage);
  }

  // Mark a message as read
  void readMessage(String chatId) {
    if (authToken == null) return;

    final readMessage = jsonEncode({
      'action': 'read_message',
      'authToken': authToken,
      'chat_id': chatId,
    });
    _channel?.sink.add(readMessage);
  }

  void responseMobileConnection(String patientAuthTokenWS, String uuid) {
    final responseMobileConnection = jsonEncode({
      'action': 'responseMobileConnection ',
      'authToken': patientAuthTokenWS,
      'uuid': uuid,
      "response": true,
    });
    _channel?.sink.add(responseMobileConnection);
  }

  // Handle incoming messages
  void _handleMessage(String message) {
    final decodedMessage = jsonDecode(message);
    switch (decodedMessage['action']) {
      case 'ready':
        onReady?.call(decodedMessage);
        break;
      case 'create_chat':
        onCreateChat?.call(decodedMessage);
        break;
      case 'get_message':
        onGetMessages?.call(decodedMessage);
        break;
      case 'receive_message':
        onReceiveMessage?.call(decodedMessage);
        break;
      case 'ask_mobile_connection':
        onAskMobileConnection?.call(decodedMessage);
        break;
      case 'response_mobile_connection':
        onResponseMobileConnection?.call(decodedMessage);
        break;
      case 'read_message':
        onReadMessage?.call(decodedMessage);
        break;
    }
  }
}

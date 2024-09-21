class Chat {
  final String id;
  final List<Sms> messages;
  final List<Participant> recipientIds;

  Chat({
    required this.messages,
    required this.id,
    required this.recipientIds,
  });
}

class Sms {
  final String message;
  final String ownerId;
  final DateTime time;

  Sms({
    required this.message,
    required this.time,
    required this.ownerId,
  });
}

class Participant {
  final String id;
  final DateTime lastSeen;

  Participant({
    required this.id,
    required this.lastSeen,
  });
}

List<Chat> transformChats(Map<String, dynamic> chats) {
  List<Chat> transformedChats = [];

  for (var chat in chats['chats']) {
    List<Sms> messages = [];
    List<Participant> participants = [];
    for (var message in chat['messages']) {
      messages.add(Sms(
        message: message['message'],
        ownerId: message['owner_id'],
        time: DateTime.fromMillisecondsSinceEpoch(
            (message['sended_time'] * 1000)),
      ));
    }
    for (var participant in chat['participants']) {
      participants.add(Participant(
        id: participant['participant_id'],
        lastSeen: DateTime.fromMillisecondsSinceEpoch(
            participant['last_seen'] * 1000),
      ));
    }
    transformedChats.add(Chat(
      id: chat['id'],
      messages: messages,
      recipientIds: participants,
    ));
  }

  var sortedChats = transformedChats
    ..sort((a, b) {
      return b.messages.last.time.compareTo(a.messages.last.time);
    });

  return sortedChats;
}

int getUnreadMessages(Chat chat, String userId) {
  int unreadMessages = 0;

  for (var participant in chat.recipientIds) {
    if (participant.id == userId) {
      unreadMessages += chat.messages.where((message) {
        return message.ownerId != userId &&
            message.time.isAfter(participant.lastSeen);
      }).length;
    }
  }

  return unreadMessages;
}

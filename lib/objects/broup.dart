import 'chat.dart';


class Broup extends Chat {
  Broup(
      int id,
      String chatName,
      String chatDescription,
      String alias,
      String chatColor,
      int unreadMessages,
      String lastActivity,
      String roomName,
      int blocked,
      int mute,
      int isBroup
      ) {
    this.id = id;
    this.chatName = chatName;
    this.chatDescription = chatDescription;
    this.alias = alias;
    this.chatColor = chatColor;
    this.unreadMessages = unreadMessages;
    this.blocked = blocked;
    this.mute = mute;
    this.lastActivity = lastActivity;
    this.roomName = roomName;
    this.isBroup = isBroup;
  }

  @override
  String getBroNameOrAlias() {
    if (this.alias != null && this.alias.isNotEmpty) {
      return this.alias;
    } else {
      return this.chatName;
    }
  }

  Map<String, dynamic> toDbMap() {
    var map = Map<String, dynamic>();
    map['chatId'] = id;
    map['lastActivity'] = lastActivity;
    map['chatName'] = chatName;
    map['chatDescription'] = chatDescription;
    map['alias'] = alias;
    map['chatColor'] = chatColor;
    map['roomName'] = roomName;
    map['unreadMessages'] = unreadMessages;
    map['blocked'] = blocked;
    map['mute'] = mute;
    map['isBroup'] = isBroup;
    return map;
  }

  Broup.fromDbMap(Map<String, dynamic> map) {
    id = map['chatId'];
    chatName = map['chatName'];
    chatDescription = map['chatDescription'];
    alias = map['alias'];
    chatColor = map['chatColor'];
    unreadMessages = map['unreadMessages'];
    lastActivity = map['lastActivity'];
    roomName = map['roomName'];
    blocked = map['blocked'];
    mute = map['mute'];
    isBroup = map['isBroup'];
  }
}

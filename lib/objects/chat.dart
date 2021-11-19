

abstract class Chat {

  late int id;
  late String lastActivity;
  late String roomName;
  late String chatName;
  late String chatDescription;
  late String alias;
  late String chatColor;
  late int unreadMessages;
  late int blocked;
  late int mute;
  late int isBroup;

  Chat();

  String getBroNameOrAlias();
  Map<String, dynamic> toDbMap();

  Chat.fromDbMap(Map<String, dynamic> map);
}
class Friends {
  String id;
  String name;
  String avatarUrl;
  String lastMessage = 'Сообщений нет';
  // List<String> messages;

  Friends({this.id, this.name, this.avatarUrl, this.lastMessage});
}

class Messag {
  String id = '';
  String userId = '';
  String body = '';
  String statusId = '';
  String createdAt = '';
  bool my;
  // List<String> messages;

  Messag(
      {this.id,
      this.userId,
      this.body,
      this.statusId,
      this.createdAt,
      this.my});
}

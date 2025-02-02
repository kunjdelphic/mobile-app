///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class GetNotificationModelNotifications {
/*
{
  "_id": "671926981d2a9071c4720ef0",
  "type": "SERVER_UPDATE",
  "userId": "63418db98ab2ca7a19b499cb",
  "title": "Test Admin",
  "message": "Good Morning, Gg",
  "read": false,
  "createdAt": "2024-10-23T16:38:48.491Z",
  "__v": 0
}
*/

  String? id;
  String? type;
  String? userId;
  String? title;
  String? message;
  bool? read;
  String? createdAt;
  int? V;

  GetNotificationModelNotifications({
    this.id,
    this.type,
    this.userId,
    this.title,
    this.message,
    this.read,
    this.createdAt,
    this.V,
  });
  GetNotificationModelNotifications.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    type = json['type']?.toString();
    userId = json['userId']?.toString();
    title = json['title']?.toString();
    message = json['message']?.toString();
    read = json['read'];
    createdAt = json['createdAt']?.toString();
    V = json['__v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['type'] = type;
    data['userId'] = userId;
    data['title'] = title;
    data['message'] = message;
    data['read'] = read;
    data['createdAt'] = createdAt;
    data['__v'] = V;
    return data;
  }
}

class GetNotificationModel {
/*
{
  "status": 200,
  "message": "Success",
  "notifications": [
    {
      "_id": "671926981d2a9071c4720ef0",
      "type": "SERVER_UPDATE",
      "userId": "63418db98ab2ca7a19b499cb",
      "title": "Test Admin",
      "message": "Good Morning, Gg",
      "read": false,
      "createdAt": "2024-10-23T16:38:48.491Z",
      "__v": 0
    }
  ]
}
*/

  int? status;
  String? message;
  List<GetNotificationModelNotifications>? notifications;

  GetNotificationModel({
    this.status,
    this.message,
    this.notifications,
  });
  GetNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    if (json['notifications'] != null) {
      final v = json['notifications'];
      final arr0 = <GetNotificationModelNotifications>[];
      v.forEach((v) {
        arr0.add(GetNotificationModelNotifications.fromJson(v));
      });
      notifications = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (notifications != null) {
      final v = notifications;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['notifications'] = arr0;
    }
    return data;
  }
}

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ReadNotificationNotifications {
/*
{
  "_id": "671926981d2a9071c4720ef0",
  "type": "SERVER_UPDATE",
  "userId": "63418db98ab2ca7a19b499cb",
  "title": "Test Admin",
  "message": "Good Morning, Gg",
  "read": true,
  "createdAt": "2024-10-23T16:38:48.491Z",
  "__v": 0
}
*/

  String? Id;
  String? type;
  String? userId;
  String? title;
  String? message;
  bool? read;
  String? createdAt;
  int? V;

  ReadNotificationNotifications({
    this.Id,
    this.type,
    this.userId,
    this.title,
    this.message,
    this.read,
    this.createdAt,
    this.V,
  });
  ReadNotificationNotifications.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    type = json['type']?.toString();
    userId = json['userId']?.toString();
    title = json['title']?.toString();
    message = json['message']?.toString();
    read = json['read'];
    createdAt = json['createdAt']?.toString();
    V = json['__v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['type'] = type;
    data['userId'] = userId;
    data['title'] = title;
    data['message'] = message;
    data['read'] = read;
    data['createdAt'] = createdAt;
    data['__v'] = V;
    return data;
  }
}

class ReadNotification {
/*
+
*/

  int? status;
  String? message;
  ReadNotificationNotifications? notifications;

  ReadNotification({
    this.status,
    this.message,
    this.notifications,
  });
  ReadNotification.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    notifications = (json['notifications'] != null) ? ReadNotificationNotifications.fromJson(json['notifications']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (notifications != null) {
      data['notifications'] = notifications!.toJson();
    }
    return data;
  }
}

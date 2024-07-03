class UserProfileModel {
  final String email;
  final String name;
  final String uid; //유저고유번호
  final String bio;
  final String link;
  final bool hasAvatar;

  UserProfileModel(
      {required this.email,
      required this.name,
      required this.uid,
      required this.bio,
      required this.link,
      required this.hasAvatar});

  UserProfileModel.empty()
      : email = "",
        name = "",
        uid = "",
        bio = "",
        link = "",
        hasAvatar = false;

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        name = json['name'],
        uid = json['uid'],
        bio = json['bio'],
        link = json['link'],
        hasAvatar = json['hasAvatar'];

  Map<String, String> toJson() {
    return {
      'email': email,
      'name': name,
      'uid': uid,
      'bio': bio,
      'link': link,
    };
  }

  UserProfileModel copyWith({
    String? email,
    String? name,
    String? uid, //
    String? bio,
    String? link,
    bool? hasAvatar,
  }) {
    return UserProfileModel(
        email: email ?? this.email,
        name: name ?? this.name,
        uid: uid ?? this.uid,
        bio: bio ?? this.bio,
        link: link ?? this.link,
        hasAvatar: hasAvatar ?? this.hasAvatar);
  }
}

class KinkContact {
  final String id; // ID Firestore
  final String username;
  final String status;
  final bool isBlocked;
  final bool isVisibilityRestricted;
  final String privateNotes;

  KinkContact({
    required this.id,
    required this.username,
    required this.status,
    required this.isBlocked,
    required this.isVisibilityRestricted,
    required this.privateNotes,
  });

  // Pour créer un KinkContact depuis un DocumentSnapshot
  factory KinkContact.fromMap(String docId, Map<String, dynamic> data) {
    return KinkContact(
      id: docId,
      username: data['username'] ?? '',
      status: data['status'] ?? '',
      isBlocked: data['isBlocked'] ?? false,
      isVisibilityRestricted: data['isVisibilityRestricted'] ?? false,
      privateNotes: data['privateNotes'] ?? '',
    );
  }

  // Pour transformer en Map (pour .set ou .update)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'status': status,
      'isBlocked': isBlocked,
      'isVisibilityRestricted': isVisibilityRestricted,
      'privateNotes': privateNotes,
    };
  }
}

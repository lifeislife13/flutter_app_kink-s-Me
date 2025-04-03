class KinkContact {
  final String id; // Firestore document ID
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

  // Constructeur depuis un DocumentSnapshot
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

  // Pour transformer l'objet en Map
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

import 'package:cloud_firestore/cloud_firestore.dart';

class Nothing {
  final String documentId;
  final String text;
  final bool public;
  final int useCt;
  final String creatorId;

  static const String TEXT = 'Text';
  static const String PUBLIC = 'Public';
  static const String USECT = 'UseCt';
  static const String CREATORID = 'CreatorId';

  static Nothing defaultNothing = Nothing('default', 'You Are My Love', false, 1, 'default');

  Nothing(this.documentId, this.text, this.public, this.useCt, this.creatorId);

  Nothing.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : documentId = snapshot.documentID,
        text = snapshot.data[TEXT],
        public = snapshot.data[PUBLIC],
        useCt = snapshot.data[USECT],
        creatorId = snapshot.data[CREATORID];

  Map<String, dynamic> toJSON() => {
        TEXT: text,
        PUBLIC: public,
        USECT: useCt,
        CREATORID: creatorId,
      };
}

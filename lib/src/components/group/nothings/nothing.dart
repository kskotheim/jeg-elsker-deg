import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/data/strings.dart';

class Nothing {
  final String documentId;
  final int createdAt;
  final String text;
  final bool public;
  final int useCt;
  final String creatorId;

  static Nothing defaultNothing = Nothing('default', 'You Are My Love', false, 1, 'default', 0);

  Nothing(this.documentId, this.text, this.public, this.useCt, this.creatorId, this.createdAt);

  Nothing.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : documentId = snapshot.documentID,
        text = snapshot.data[TEXT],
        public = snapshot.data[PUBLIC],
        useCt = snapshot.data[USE_CT],
        creatorId = snapshot.data[CREATOR_ID],
        createdAt = snapshot.data[CREATED_AT];

  Map<String, dynamic> toJSON() => {
        TEXT: text,
        PUBLIC: public,
        USE_CT: useCt,
        CREATOR_ID: creatorId,
      };
}

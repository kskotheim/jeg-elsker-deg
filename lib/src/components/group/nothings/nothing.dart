import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/data/db.dart';

class Nothing {
  final String documentId;
  final String text;
  final bool public;
  final int useCt;
  final String creatorId;

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

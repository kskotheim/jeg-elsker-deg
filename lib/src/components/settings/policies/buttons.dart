
import 'package:flutter/material.dart';
import 'package:my_love/src/components/settings/policies/privacy.dart';
import 'package:my_love/src/components/settings/policies/terms.dart';
import 'package:my_love/src/util/button.dart';

class PolicyButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AccountButton(
          text: 'Privacy Policy',
          onPressed: () => showDialog(
            context: context,
            child: SimpleDialog(
              title: Text('Privacy Policy'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(PRIVACY_STRING),
                ),
              ],
            ),
          ),
        ),
        AccountButton(
          text: 'Terms & Conditions',
          onPressed: () => showDialog(
            context: context,
            child: SimpleDialog(
              title: Text('Terms & Conditions'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(TERMS_STRING),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
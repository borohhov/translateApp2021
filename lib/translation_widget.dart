import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translation_app/constants/constants.dart';

import 'connectors/firebase.dart';
import 'connectors/translation_api.dart';
import 'model/translation.dart';

class TranslationWidget extends StatefulWidget {
  const TranslationWidget({Key? key}) : super(key: key);

  @override
  _TranslationWidgetState createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  final TextEditingController _controller = TextEditingController();
  String sourceLang = "en";
  String destLang = "et";
  final _formKey = GlobalKey<FormState>();

  Future<String> getTranslation() {
    Translation translation =
        Translation(_controller.value.text, sourceLang, destLang);
    FirebaseApi().saveToDb(translation);
    return TranslationApi.fetchTranslation(translation);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    label: Text("Input some text to traslate")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FutureBuilder<String>(
                future: getTranslation(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  String response = "";
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    response = "Waiting for response";
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    response = snapshot.data ?? "";
                  }
                  return Text(
                    response,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                    value: sourceLang,
                    onChanged: (String? newValue) {
                      setState(() {
                        sourceLang = newValue!;
                      });
                    },
                    items: Constants.languageCodes
                        .asMap()
                        .entries
                        .map((langCode) => DropdownMenuItem(
                            value: langCode.value,
                            child: Text(Constants.languageNames[langCode.key])))
                        .toList()),
                Icon(Icons.arrow_forward),
                DropdownButton(
                    value: destLang,
                    onChanged: (String? newValue) {
                      setState(() {
                        destLang = newValue!;
                      });
                    },
                    items: Constants.languageCodes
                        .asMap()
                        .entries
                        .map((langCode) => DropdownMenuItem(
                            value: langCode.value,
                            child: Text(Constants.languageNames[langCode.key])))
                        .toList())
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      bool formIsCorrect = _formKey.currentState!.validate();
                      if (formIsCorrect) {
                        setState(() {
                          getTranslation();
                        });
                      }
                    },
                    child: Text(
                      "Translate",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

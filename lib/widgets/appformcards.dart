import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import '../utils/locator.dart';
import '../utils/language_service.dart';

enum CheckColor { Black, Green, Red }

class Dpvalue {
  String name;
  String value;
  Dpvalue({this.name, this.value});
}

Future<String> appimagepicker({ImageSource source}) async {
  var image = await ImagePicker.pickImage(source: source, imageQuality: 30);
  File trasnformimage = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
  var apppath = await getApplicationDocumentsDirectory();
  var filename = trasnformimage.path.split("/").last;
  var localfile = await trasnformimage.copy('${apppath.path}/$filename');
  return localfile.path;
}

Widget completedcheckbox({CheckColor isCompleted}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        //color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(color: getCheckColor(isCompleted), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: getCheckColor(isCompleted),
          ),
        ),
      ),
    ),
  );
}

Color getCheckColor(CheckColor cc) {
  Color choosenColor = Colors.black;
  try {
    switch (cc) {
      case CheckColor.Black:
        choosenColor = Colors.black;
        break;
      case CheckColor.Green:
        choosenColor = Colors.lightGreen;
        break;
      case CheckColor.Red:
        choosenColor = Colors.red;
        break;
      default:
    }
  } catch (e) {
    print(e);
  }
  return choosenColor;
}

Widget formcardtextfield(
    {TextInputType keyboardtype,
    String initvalue,
    String headerlablekey,
    CheckColor radiovalue,
    String hinttextkey,
    Function(String) onSaved,
    Function(String) validator,
    Function(String) onChanged,
    FocusNode fieldfocus,
    TextInputAction textInputAction,
    void Function(String) onFieldSubmitted,
    Widget suffix,
    bool enable,
    int maxLength,
    List<TextInputFormatter> inputFormatters,
    bool fieldrequired = false}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(176, 174, 171, 1), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              textDirection: locator<LanguageService>().currentlanguage == 0
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: <Widget>[
                completedcheckbox(isCompleted: radiovalue),
                fieldrequired
                    ? Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )
                    : SizedBox(),
                Flexible(
                  child: Container(
                    child: Text(
                      headerlablekey,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      style: TextStyle(),
                      textDirection:
                          locator<LanguageService>().currentlanguage == 0
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: TextFormField(
                autofocus: false,
                textDirection: locator<LanguageService>().currentlanguage == 0
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                enabled: enable,
                keyboardType: keyboardtype,
                initialValue: initvalue?.isEmpty ?? true ? "" : initvalue,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.redAccent),
                  suffixIcon: suffix,
                  hintText: hinttextkey?.isEmpty ?? true ? "" : hinttextkey,
                ),
                onSaved: onSaved,
                validator: validator,
                onChanged: onChanged,
                onFieldSubmitted: onFieldSubmitted,
                inputFormatters: inputFormatters,
                maxLength: maxLength,
                maxLengthEnforced: true,

                ///WhitelistingTextInputFormatter.digitsOnly
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget formCardDropdown(
    {CheckColor iscompleted,
    String headerlablekey,
    List<Dpvalue> dropdownitems,
    Function(String) onSaved,
    String value,
    Function(String) validate,
    FocusNode fieldfocus,
    Function(String) onChanged,
    bool fieldrequired = false,
    bool enable = false}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(176, 174, 171, 1), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              textDirection: locator<LanguageService>().currentlanguage == 0
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: <Widget>[
                completedcheckbox(isCompleted: iscompleted),
                fieldrequired
                    ? Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )
                    : SizedBox(),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    headerlablekey,
                    style: TextStyle(),
                    textDirection:
                        locator<LanguageService>().currentlanguage == 0
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: Directionality(
                textDirection: locator<LanguageService>().currentlanguage == 0
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: AbsorbPointer(
                    absorbing: enable,
                    child: DropdownButtonFormField<String>(
                      items: dropdownitems.map((Dpvalue data) {
                        return DropdownMenuItem<String>(
                          value: data.value,
                          child: Container(
                            alignment:
                                locator<LanguageService>().currentlanguage == 0
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: Text(
                              data.name,
                            ),
                          ),
                        );
                      }).toList(),
                      validator: validate,
                      onChanged: onChanged,
                      onSaved: onSaved,
                      value: value,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget formcardtextfield1(
    {TextInputType keyboardtype,
    final item,
    String initvalue,
    String headerlablekey,
    CheckColor radiovalue,
    String hinttextkey,
    Function(String) onSaved,
    Function(String) validator,
    Function(String) onChanged,
    FocusNode fieldfocus,
    TextInputAction textInputAction,
    void Function(String) onFieldSubmitted,
    Widget suffix,
    bool enable,
    int maxLength,
    List<TextInputFormatter> inputFormatters,
    List surveyList,
    String value,
    bool fieldrequired = false}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(176, 174, 171, 1), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              textDirection: locator<LanguageService>().currentlanguage == 0
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: <Widget>[
                completedcheckbox(isCompleted: radiovalue),
                fieldrequired
                    ? Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )
                    : SizedBox(),
                Flexible(
                  child: Container(
                    child: Text(
                      headerlablekey,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      style: TextStyle(),
                      textDirection:
                          locator<LanguageService>().currentlanguage == 0
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: DropdownButtonFormField<String>(
                hint: new Text(hinttextkey),
                items: surveyList.map((item) {
                  // String fullName =
                  //     "${item["first_name"]} ${item["first_name"]}";
                  return DropdownMenuItem<String>(
                    value: item["_id"],
                    child: Container(
                      alignment: locator<LanguageService>().currentlanguage == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: new Text(
                          "${item["first_name"]} ${item["last_name"]}"),
                    ),
                  );
                }).toList(),
                // validator: validate,
                onChanged: onChanged,
                onSaved: onSaved,
                value: value,
              ),
              // child: TextFormField(
              //   autofocus: false,
              //   textDirection: locator<LanguageService>().currentlanguage == 0
              //       ? TextDirection.ltr
              //       : TextDirection.rtl,
              //   enabled: enable,
              //   keyboardType: keyboardtype,
              //   initialValue: initvalue?.isEmpty ?? true ? "" : initvalue,
              //   decoration: InputDecoration(
              //     errorStyle: TextStyle(color: Colors.redAccent),
              //     suffixIcon: suffix,
              //     hintText: hinttextkey?.isEmpty ?? true ? "" : hinttextkey,
              //   ),
              //   onSaved: onSaved,
              //   validator: validator,
              //   onChanged: onChanged,
              //   onFieldSubmitted: onFieldSubmitted,
              //   inputFormatters: inputFormatters,
              //   maxLength: maxLength,
              //   maxLengthEnforced: true,
              //   ///WhitelistingTextInputFormatter.digitsOnly
              // ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget formcardtextfield3(
    {TextInputType keyboardtype,
    String initvalue,
    String headerlablekey,
    CheckColor radiovalue,
    String hinttextkey,
    Function(String) onSaved,
    Function(String) validator,
    Function(String) onChanged,
    FocusNode fieldfocus,
    TextInputAction textInputAction,
    void Function(String) onFieldSubmitted,
    Widget suffix,
    bool enable,
    int maxLength,
    List<TextInputFormatter> inputFormatters,
    List surveyList,
    String value,
    bool fieldrequired = false}) {
  print("drop-down ====gozar ========== $surveyList");
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(176, 174, 171, 1), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              textDirection: locator<LanguageService>().currentlanguage == 0
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: <Widget>[
                completedcheckbox(isCompleted: radiovalue),
                fieldrequired
                    ? Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )
                    : SizedBox(),
                Flexible(
                  child: Container(
                    child: Text(
                      headerlablekey,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      style: TextStyle(),
                      textDirection:
                          locator<LanguageService>().currentlanguage == 0
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: DropdownButtonFormField<String>(
                hint: new Text(hinttextkey),
                items: surveyList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item["_id"],
                    child: Container(
                      alignment: locator<LanguageService>().currentlanguage == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        item["name"],
                      ),
                    ),
                  );
                }).toList(),
                // validator: validate,
                onChanged: onChanged,
                onSaved: onSaved,
                value: value,
              ),
              // child: TextFormField(
              //   autofocus: false,
              //   textDirection: locator<LanguageService>().currentlanguage == 0
              //       ? TextDirection.ltr
              //       : TextDirection.rtl,
              //   enabled: enable,
              //   keyboardType: keyboardtype,
              //   initialValue: initvalue?.isEmpty ?? true ? "" : initvalue,
              //   decoration: InputDecoration(
              //     errorStyle: TextStyle(color: Colors.redAccent),
              //     suffixIcon: suffix,
              //     hintText: hinttextkey?.isEmpty ?? true ? "" : hinttextkey,
              //   ),
              //   onSaved: onSaved,
              //   validator: validator,
              //   onChanged: onChanged,
              //   onFieldSubmitted: onFieldSubmitted,
              //   inputFormatters: inputFormatters,
              //   maxLength: maxLength,
              //   maxLengthEnforced: true,
              //   ///WhitelistingTextInputFormatter.digitsOnly
              // ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget formcardtextfield4(
    {TextInputType keyboardtype,
    String initvalue,
    String headerlablekey,
    CheckColor radiovalue,
    String hinttextkey,
    Function(String) onSaved,
    Function(String) validator,
    Function(String) onChanged,
    FocusNode fieldfocus,
    TextInputAction textInputAction,
    void Function(String) onFieldSubmitted,
    Widget suffix,
    bool enable,
    int maxLength,
    List<TextInputFormatter> inputFormatters,
    List surveyList,
    String value,
    bool fieldrequired = false}) {
  print("drop-down ====gozar ========== $surveyList");
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(176, 174, 171, 1), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              textDirection: locator<LanguageService>().currentlanguage == 0
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: <Widget>[
                completedcheckbox(isCompleted: radiovalue),
                fieldrequired
                    ? Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )
                    : SizedBox(),
                Flexible(
                  child: Container(
                    child: Text(
                      headerlablekey,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      style: TextStyle(),
                      textDirection:
                          locator<LanguageService>().currentlanguage == 0
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: DropdownButtonFormField<String>(
                hint: new Text(hinttextkey),
                items: surveyList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['name'].toString(),
                    child: Container(
                      alignment: locator<LanguageService>().currentlanguage == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        item['name'].toString(),
                      ),
                    ),
                  );
                }).toList(),
                // validator: validate,
                onChanged: onChanged,
                onSaved: onSaved,
                value: value,
              ),
              // child: TextFormField(
              //   autofocus: false,
              //   textDirection: locator<LanguageService>().currentlanguage == 0
              //       ? TextDirection.ltr
              //       : TextDirection.rtl,
              //   enabled: enable,
              //   keyboardType: keyboardtype,
              //   initialValue: initvalue?.isEmpty ?? true ? "" : initvalue,
              //   decoration: InputDecoration(
              //     errorStyle: TextStyle(color: Colors.redAccent),
              //     suffixIcon: suffix,
              //     hintText: hinttextkey?.isEmpty ?? true ? "" : hinttextkey,
              //   ),
              //   onSaved: onSaved,
              //   validator: validator,
              //   onChanged: onChanged,
              //   onFieldSubmitted: onFieldSubmitted,
              //   inputFormatters: inputFormatters,
              //   maxLength: maxLength,
              //   maxLengthEnforced: true,
              //   ///WhitelistingTextInputFormatter.digitsOnly
              // ),
            )
          ],
        ),
      ),
    ),
  );
}
Widget formcardtextfield2(
    {TextInputType keyboardtype,
    String initvalue,
    String headerlablekey,
    CheckColor radiovalue,
    String hinttextkey,
    Function(String) onSaved,
    Function(String) validator,
    Function(String) onChanged,
    FocusNode fieldfocus,
    TextInputAction textInputAction,
    void Function(String) onFieldSubmitted,
    Widget suffix,
    bool enable,
    int maxLength,
    List<TextInputFormatter> inputFormatters,
    List surveyList,
    String value,
    bool fieldrequired = false}) {
  print("provincelist ========= $surveyList");
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(176, 174, 171, 1), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              textDirection: locator<LanguageService>().currentlanguage == 0
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: <Widget>[
                completedcheckbox(isCompleted: radiovalue),
                fieldrequired
                    ? Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )
                    : SizedBox(),
                Flexible(
                  child: Container(
                    child: Text(
                      headerlablekey,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      style: TextStyle(),
                      textDirection:
                          locator<LanguageService>().currentlanguage == 0
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: DropdownButtonFormField<String>(
                hint: new Text(hinttextkey),
                items: surveyList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      alignment: locator<LanguageService>().currentlanguage == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        getProvincename(item.toString()),
                      ),
                    ),
                  );
                }).toList(),
                // validator: validate,
                onChanged: onChanged,
                onSaved: onSaved,
                value: value,
              ),
              // child: TextFormField(
              //   autofocus: false,
              //   textDirection: locator<LanguageService>().currentlanguage == 0
              //       ? TextDirection.ltr
              //       : TextDirection.rtl,
              //   enabled: enable,
              //   keyboardType: keyboardtype,
              //   initialValue: initvalue?.isEmpty ?? true ? "" : initvalue,
              //   decoration: InputDecoration(
              //     errorStyle: TextStyle(color: Colors.redAccent),
              //     suffixIcon: suffix,
              //     hintText: hinttextkey?.isEmpty ?? true ? "" : hinttextkey,
              //   ),
              //   onSaved: onSaved,
              //   validator: validator,
              //   onChanged: onChanged,
              //   onFieldSubmitted: onFieldSubmitted,
              //   inputFormatters: inputFormatters,
              //   maxLength: maxLength,
              //   maxLengthEnforced: true,
              //   ///WhitelistingTextInputFormatter.digitsOnly
              // ),
            )
          ],
        ),
      ),
    ),
  );
}
Widget formcardtextfield5(
    {TextInputType keyboardtype,
      String fieldFor,
      String initvalue,
      String headerlablekey,
      CheckColor radiovalue,
      String hinttextkey,
      Function(String) onSaved,
      Function(String) validator,
      Function(String) onChanged,
      FocusNode fieldfocus,
      TextInputAction textInputAction,
      void Function(String) onFieldSubmitted,
      Widget suffix,
      bool enable,
      int maxLength,
      List<TextInputFormatter> inputFormatters,
      List surveyList,
      String value,
      bool fieldrequired = false}) {
  print("$fieldFor ========== $surveyList");
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(176, 174, 171, 1), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              textDirection: locator<LanguageService>().currentlanguage == 0
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: <Widget>[
                completedcheckbox(isCompleted: radiovalue),
                fieldrequired
                    ? Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                )
                    : SizedBox(),
                Flexible(
                  child: Container(
                    child: Text(
                      headerlablekey,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      style: TextStyle(),
                      textDirection:
                      locator<LanguageService>().currentlanguage == 0
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: DropdownButtonFormField<String>(
                hint: new Text(hinttextkey),
                items: surveyList.map((item) {
                  return DropdownMenuItem<String>(
                    value: getItem(item,fieldFor),
                    child: Container(
                      alignment: locator<LanguageService>().currentlanguage == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        getName(item,fieldFor),
                      ),
                    ),
                  );
                }).toList(),
                // validator: validate,
                onChanged: onChanged,
                onSaved: onSaved,
                value: value,
              ),
              // child: TextFormField(
              //   autofocus: false,
              //   textDirection: locator<LanguageService>().currentlanguage == 0
              //       ? TextDirection.ltr
              //       : TextDirection.rtl,
              //   enabled: enable,
              //   keyboardType: keyboardtype,
              //   initialValue: initvalue?.isEmpty ?? true ? "" : initvalue,
              //   decoration: InputDecoration(
              //     errorStyle: TextStyle(color: Colors.redAccent),
              //     suffixIcon: suffix,
              //     hintText: hinttextkey?.isEmpty ?? true ? "" : hinttextkey,
              //   ),
              //   onSaved: onSaved,
              //   validator: validator,
              //   onChanged: onChanged,
              //   onFieldSubmitted: onFieldSubmitted,
              //   inputFormatters: inputFormatters,
              //   maxLength: maxLength,
              //   maxLengthEnforced: true,
              //   ///WhitelistingTextInputFormatter.digitsOnly
              // ),
            )
          ],
        ),
      ),
    ),
  );
}

String getName(item, String fieldFor) {
  String result;
  switch (fieldFor) {
    case "province":
      result = getProvincename(item.toString());
      break;
    case "municipality":
      result = item['name'].toString();
      break;
    case "nahia":
      result = item['name'].toString();
      break;
    case "gozar":
      result = item['name'].toString();
      break;
    default:
      result = item;
  }
  return result;
}

dynamic getItem(item, String fieldFor) {
  dynamic result;
  switch (fieldFor) {
    case "province":
      result = item;
      break;
    case "municipality":
      result = item['value'].toString();
      break;
    case "nahia":
      result = item['name'].toString();
      break;
    case "gozar":
      result = item['name'].toString();
      break;
    default:
      result = item;
  }
  return result;
}

String getProvincename(String id) {
  var result = "";
  switch (id) {
    case "01-01":
      result = 'Kabul';
      break;
    case "06-01":
      result = 'Nangarhar';
      break;
    case "33-01":
      result = 'Kandahar';
      break;
    case "10-01":
      result = 'Bamyan';
      break;
    case "22-01":
      result = 'Daikundi';
      break;
    case "17-01":
      result = 'Kundoz';
      break;
    case "18-01":
      result = 'Balkh';
      break;
    case "30-01":
      result = 'Herat';
      break;
    case "03-01":
      result = 'Parwan';
      break;
    case "04-01":
      result = 'Farah';
      break;
    default:
      result = id;
  }
  return result;
}

import 'package:flash_chat/constants.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/screens/BaseView.dart';
import 'package:flash_chat/viewmodels/AccountInfoViewModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountInfoScreen extends StatefulWidget {
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  FocusNode _nameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String get name => _nameController.text;

  String get email => _nameController.text;

  String get password => _nameController.text;

  _shiftFocus(FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  void _submitForm(AccountInfoViewModel model) {
//    model.submitForm();
  }

//  onModelReady: (model) {
//  _nameController.text = "${me.firstName} ${me.lastName}";
//  _emailController.text = "${me.email}";
//  },
  @override
  Widget build(BuildContext context) {
    Me me = Provider.of<Me>(context);
    return BaseView<AccountInfoViewModel>(
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          title: Text("Account Settings"),
          actions: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: RawMaterialButton(
                onPressed: () => _submitForm(model),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )),
          ],
        ),
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ..._buildForm(model),
                    Center(
                      child: model.image != null ? Container(
                        height: 50,
                        width: 50,
                        child: Image.file(model.image, scale: 1.0, repeat: ImageRepeat.noRepeat,),
                      ) : Container(),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    FloatingActionButton(
                      mini: true,
                      onPressed: () => model.setProfilePicture(me.uid),
                      tooltip: 'Upload profile picture',
                      child: Icon(FontAwesomeIcons.mandalorian),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildForm(AccountInfoViewModel model) {
    return [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Name"),
      ),
      TextField(
          focusNode: _nameNode,
          onEditingComplete: () => _shiftFocus(_emailNode),
          controller: _nameController,
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.grey[700],
          ),
          textInputAction: TextInputAction.next,
          decoration:
              kFloatingTextFieldDecoration.copyWith(hintText: "Who are ya?")),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Email"),
      ),
      TextField(
          focusNode: _emailNode,
//        enabled: !model.loading,
          onEditingComplete: () => _shiftFocus(_passwordNode),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.grey[700],
          ),
          textInputAction: TextInputAction.next,
          decoration: kFloatingTextFieldDecoration.copyWith(
              hintText: "What's your email?")),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Password"),
      ),
      TextField(
          focusNode: _passwordNode,
//        enabled: !model.loading,
          controller: _passwordController,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.grey[700],
          ),
          textInputAction: TextInputAction.done,
          decoration: kFloatingTextFieldDecoration.copyWith(
              hintText: "What's your new password!")),
    ];
  }
}

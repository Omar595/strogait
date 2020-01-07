import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../chatdoctor/mainScreen.dart';
import '../doctorprofile/Screens/ProfilePage.dart';
import '../userprofile/Screens/ProfilePage.dart';
import '../screens/home.dart';

enum AuthMode { Confirm, Login }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: SizedBox(height: deviceSize.height * 0.18),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: Auth(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<Auth> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  int _radioValue = 0;

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'name': '', 'phone': '', 'uid': ''};
  bool _isLoading = false;
  bool _hasError = false;
  bool _signedUp = false;
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  Country _selected = Country.EG;
  String phoneCode = '+20';

  String smsCode;
  AuthCredential _authCredential;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _verificationId;

  //method 2

  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  Future<void> verifyeNumber() async {
    final PhoneCodeSent smsCodeSent =
        (String verificationId, [int forceResendingToken]) async {
      this._verificationId = verificationId;
      Fluttertoast.showToast(msg: 'Code sent to ${_phoneController.text}');
      // print('Code sent to ${_phoneController.text}');
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this._verificationId = verificationId;
      setState(() {
        _isLoading = false;
        _switchAuthMode();
      });
    };

    //called when Auto verified
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      _authCredential = auth;

      firebaseAuth.signInWithCredential(_authCredential).catchError(
        (error) {
          setState(() {
            _isLoading = false;
          });

          var errorMsg = '';
          print(error.toString());
          if (error.toString().contains('ERROR_INVALID_VERIFICATION_CODE'))
            errorMsg = 'الكود غير صحيح';
          else if (error.toString().contains('Network'))
            errorMsg = 'تحقق من إتصال الانترنت';
          else
            errorMsg = 'لقد حدث خطأ، حاول لاحقًا';
          _hasError = true;

          errorDialog(errorMsg);
        },
      ).then(
        (user) async {
          if (user != null) {
            // Update data to server if new user

            // Write data to local
            currentUser = user.user;
            if (user.additionalUserInfo.isNewUser) {
              setState(() {
                _signedUp = true;
                _isLoading = false;
              });
            } else {
              prefs = await SharedPreferences.getInstance();
              await prefs.setString('id', currentUser.uid);
              bool doc = prefs.getBool('doctor');

              if (doc)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MainScreen(currentUserId: currentUser.uid)));
              else
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Homepage()));
            }
          }
        },
      );
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(authException.message);
      if (authException.message.contains('blocked')) {
        setState(() {
          _isLoading = false;
        });
        errorDialog('دخول متكرر، يرجى المحاولة لاحقًا');
      }
    };

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: _authData['phone'],
      timeout: const Duration(seconds: 2),
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
    );
  }

  signInManually() async {
    _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsCode);

    firebaseAuth.signInWithCredential(_authCredential).catchError(
      (error) {
        var errorMsg = '';
        print(error.message.toString());
        if (error.toString().contains('ERROR_INVALID_VERIFICATION_CODE'))
          errorMsg = 'الكود غير صحيح';
        else if (error.toString().contains('Network'))
          errorMsg = 'تحقق من إتصال الانترنت';
        else
          errorMsg = 'لقد حدث خطأ، حاول لاحقًا';
        _hasError = true;
        setState(() {
          _isLoading = false;
          _hasError = true;
          _codeController.clear();
        });

        errorDialog(errorMsg);
      },
    ).then((user) async {
      if (user != null) {
        currentUser = user.user;
        // Check is already sign up
        if (user.additionalUserInfo.isNewUser) {
          setState(() {
            _signedUp = true;
            _isLoading = false;
          });
        } else {
          prefs = await SharedPreferences.getInstance();
          prefs.setString('id', currentUser.uid);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainScreen(currentUserId: prefs.getString('id'))));
        }
      }
    });
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });
    if (!_signedUp) {
      if (_authMode == AuthMode.Login) {
        verifyeNumber();
      } else {
        signInManually();
      }
    } else {
      if (_radioValue != 0) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserSignup(currentUser)));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DoctorSignup(currentUser)));
      }
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Confirm;
        _codeController.clear();
        _hasError = false;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _nameController.clear();
        _phoneController.clear();
        _hasError = false;
      });
    }
  }

  void errorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: Text(
                  'خطأ',
                  style: TextStyle(fontSize: 20),
                ),
                content: Text(
                  msg,
                  style: TextStyle(fontSize: 16),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('حسنا'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: _authMode == AuthMode.Login ? 260 : 320,
        constraints: BoxConstraints(minHeight: 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (!_signedUp)
                    if (_authMode == AuthMode.Login)
                      Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    CountryPicker(
                                      dense: false,
                                      showFlag:
                                          true, //displays flag, true by default
                                      showDialingCode: false,
                                      showName:
                                          false, //displays country name, true by default
                                      onChanged: (Country country) {
                                        setState(() {
                                          _selected = country;
                                        });
                                        phoneCode = '+' + _selected.dialingCode;
                                      },
                                      selectedCountry: _selected,
                                    ),
                                    Flexible(
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                value.length != 11) {
                                              return 'الرقم غير صحيح';
                                            }
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'رقم الهاتف'),
                                          keyboardType: TextInputType.phone,
                                          textAlign: TextAlign.center,
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter
                                                .digitsOnly
                                          ],
                                          controller: _phoneController,
                                          onSaved: (value) {
                                            _authData['phone'] =
                                                phoneCode + value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        child: Center(
                          child: PinCodeTextField(
                            pinBoxWidth: 30,
                            pinBoxHeight: 50,
                            autofocus: true,
                            highlight: true,
                            highlightColor: Colors.blue,
                            defaultBorderColor: Colors.black,
                            hasTextBorderColor: Colors.green,
                            hasError: _hasError,
                            maxLength: 6,
                            pinTextAnimatedSwitcherTransition:
                                ProvidedPinBoxTextAnimation.scalingTransition,
                            pinTextAnimatedSwitcherDuration:
                                Duration(milliseconds: 200),
                            highlightAnimationBeginColor: Colors.blue,
                            highlightAnimationEndColor: Colors.black87,
                            highlightAnimationDuration:
                                Duration(milliseconds: 1000),
                            keyboardType: TextInputType.phone,
                            controller: _codeController,
                            onTextChanged: (String s) {
                              smsCode = s;
                            },
                            onDone: (String s) {
                              smsCode = s;
                            },
                          ),
                        ),
                      )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Choose your role!",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: 0,
                                groupValue: _radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioValue = value;
                                  });
                                },
                              ),
                              Text("Doctor", style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: 1,
                                groupValue: _radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioValue = value;
                                  });
                                },
                              ),
                              Text("Patient", style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
                      ],
                    ),

                  // if (_authMode == AuthMode.Confirm)

                  if (_isLoading == true)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CircularProgressIndicator())
                  else
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      margin: EdgeInsets.only(top: !_signedUp ? 30 : 0),
                      child: RaisedButton(
                        child: !_signedUp
                            ? Text(
                                'تسجيل الدخول',
                                style: TextStyle(fontSize: 20),
                              )
                            : Text(
                                'متابعة',
                                style: TextStyle(fontSize: 20),
                              ),
                        onPressed: () {
                          _submit();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                    ),

                  if (_authMode == AuthMode.Login)
                    SizedBox()
                  else if (_signedUp)
                    SizedBox()
                  else
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: Text('اعادة ارسال كود التشغيل'),
                          onPressed: verifyeNumber,
                          color: Colors.transparent,
                          textColor: Theme.of(context).primaryColor,
                        ),
                        FlatButton(
                          child: Text('تسجيل برقم اخر'),
                          onPressed: _switchAuthMode,
                          color: Colors.transparent,
                          textColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

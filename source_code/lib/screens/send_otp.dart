import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';


class SendOtp extends StatefulWidget {
  SendOtp({Key key, this.verify_by = "email",this.user_id}) : super(key: key);
  final String verify_by;
  final int user_id;

  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onTapResend() async {
    var resendCodeResponse = await AuthRepository()
        .getResendCodeResponse(widget.user_id,widget.verify_by);

    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(resendCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(resendCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    }

  }

  onPressConfirm() async {

    var code = _verificationCodeController.text.toString();

    // if(code == ""){
    //   ToastComponent.showDialog("Enter verification code", context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //   return;
    // }

    var confirmCodeResponse = await AuthRepository()
        .getConfirmCodeResponse(widget.user_id,code);

    if (confirmCodeResponse.result == false) {
      ToastComponent.showDialog(confirmCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(confirmCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));

    }
  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: _screen_width * (3 / 4),
            child: Image.asset(
                "assets/splash_login_registration_background_image.png"),
          ),
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                  child: Container(
                    width: 75,
                    height: 75,
                    child:
                        Image.asset('assets/login_registration_form_logo.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Verify your " +
                        (_verify_by == "email"
                            ? "Email Account"
                            : "Phone Number"),
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                      width: _screen_width * (3 / 4),
                      child: _verify_by == "email"
                          ? Text(
                              "Enter the verification code that sent to your email recently.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.dark_grey, fontSize: 14))
                          : Text(
                              "Enter the verification code that sent to your phone recently.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.dark_grey, fontSize: 14))),
                ),
                Container(
                  width: _screen_width * (3 / 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 36,
                              child: TextField(
                                controller: _verificationCodeController,
                                autofocus: false,
                                decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hint_text: "A X B 4 J H"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyTheme.textfield_grey, width: 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: FlatButton(
                            minWidth: MediaQuery.of(context).size.width,
                            //height: 50,
                            color: MyTheme.accent_color,
                            shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                             onPressConfirm();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: InkWell(
                    onTap: (){
                      onTapResend();
                    },
                    child: Text("Resend Code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            decoration: TextDecoration.underline,
                            fontSize: 13)),
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}

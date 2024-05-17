import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pangju/screens/auth/phone_vertification_detail_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isButtonEnabled = false;

  void _sendVerification() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            phoneNumber: _phoneController.text,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _phoneController.clear();
      }
    });
    _phoneController.addListener(_validatePhoneNumber);
  }

  void _validatePhoneNumber() {
    final phone = _phoneController.text.replaceAll(' ', '');
    setState(() {
      _isButtonEnabled = phone.length == 11 && phone.startsWith('010');
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
              children: [
                const Text(
                  '휴대폰 번호를 인증해 주세요.',
                  style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center, // 텍스트 중앙 정렬
                ),
                const SizedBox(height: 10),
                const Text(
                  '팡쥬는 휴대폰 번호로 가입해요.\n번호는 안전하게 보호되며 외부에 공개되지 않아요.',
                  style: TextStyle(
                    color: Color(0xFFA5A5A5),
                    fontSize: 16,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center, // 텍스트 중앙 정렬
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _phoneController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PhoneNumberFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: '휴대폰 번호를 입력해 주세요.',
                    hintStyle: const TextStyle(color: Color(0xFFA5A5A5)),
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20), // 여백 설정
                  ),
                  validator: (value) {
                    final phone = value?.replaceAll(' ', '') ?? '';
                    if (phone.isEmpty) {
                      return '휴대폰 번호를 입력해 주세요.';
                    }
                    if (phone.length != 11 || !phone.startsWith('010')) {
                      return '유효한 휴대폰 번호를 입력해 주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _sendVerification : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: _isButtonEnabled
                        ? const Color(0xFF37A3E0)
                        : const Color(0xFFF1F1F1),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    '인증문자 받기',
                    style: TextStyle(
                      color: _isButtonEnabled
                          ? Colors.white
                          : const Color(0xFFC3C3C3),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '휴대폰 번호가 변경되었나요?',
                      style: TextStyle(
                        color: Color(0xFF7B7B7B),
                        fontSize: 16,
                        height: 1.3,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // 이메일로 계정 찾기 로직 추가
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(left: 6), // 여백 6 설정
                        minimumSize: const Size(0, 0),
                      ),
                      child: const Text(
                        '이메일로 계정찾기',
                        style: TextStyle(
                          color: Color(0xFF37A3E0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;

    String newText;
    if (newTextLength > 3 && newTextLength <= 7) {
      newText =
          '${newValue.text.substring(0, 3)} ${newValue.text.substring(3)}';
      selectionIndex += 1;
    } else if (newTextLength > 7) {
      newText =
          '${newValue.text.substring(0, 3)} ${newValue.text.substring(3, 7)} ${newValue.text.substring(7)}';
      selectionIndex += 2;
    } else {
      newText = newValue.text;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 폼 컨트롤러
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  // 회원가입 요청을 보내는 함수
  Future<void> _registerUser() async {
    // 폼 검증
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // 로딩 상태로 변경
      });

      // 서버로 보낼 데이터 구성
      final Map<String, dynamic> userData = {
        "username": _usernameController.text,
        "password": _passwordController.text,
        "email": _emailController.text,
      };

      // HTTP 요청 보내기
      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/auth/register'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userData),
        );

        // 서버 응답 확인
        if (response.statusCode == 200) {
          // 회원가입 성공 시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입 성공')),
          );
        } else {
          // 회원가입 실패 시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입 실패: ${response.body}')),
          );
        }
      } catch (e) {
        // 네트워크 오류 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // 로딩 상태 해제
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // 폼 검증을 위한 키
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: '사용자 이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '사용자 이름을 입력하세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: '이메일'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력하세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: '비밀번호'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator()) // 로딩 상태일 때 표시
                  : ElevatedButton(
                      onPressed: _registerUser, // 버튼 클릭 시 회원가입 시도
                      child: Text('회원가입'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

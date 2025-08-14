import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:logger/logger.dart';
import 'package:weather/src/views/authenticated/forecast.dart';

const textStyle = TextStyle(fontSize: 24);

var loginLogger = Logger();

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: LoginForm()));
  }
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailValidator = Validator(
    validators: [const RequiredValidator(), const EmailValidator()],
  );
  final _passwordValidator = Validator(
    validators: [
      const RequiredValidator(),
      const MinLengthValidator(length: 8),
    ],
  );

  var _titleText = "Bem vindo de volta!";
  var _loginButtonText = "Login";
  var _passwordFieldLabel = "Senha";
  var _signUpText = "Criar conta";
  var _onSignup = false;

  final List<Map<String, String>> _validCreds = [
    {"email": "test@test.com", "password": "password"},
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Builder(
            builder: (BuildContext context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _titleText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaler: TextScaler.linear(1.5),
                ),
                const Text(
                  "Please provide your credentials.",
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.linear(1.25),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  validator: (value) {
                    return _emailValidator.validate(
                      label: "E-mail",
                      value: value,
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  validator: (value) => _passwordValidator.validate(
                    label: "Password",
                    value: value,
                  ),
                  decoration: InputDecoration(
                    labelText: _passwordFieldLabel,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSubmitLoginForm,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        _loginButtonText,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Forgot password logic will be implemented later
                        loginLogger.i('Forgot password requested');
                      },
                      child: const Text('Forgot my password'),
                    ),
                    TextButton(
                      onPressed: _onClickSignup,
                      child: Text(_signUpText),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onClickSignup() {
    setState(() {
      _onSignup = !_onSignup;
      if (!_onSignup) {
        _passwordFieldLabel = "Password";
        _loginButtonText = "Login";
        _signUpText = "Sign up";
        _titleText = "Welcome back!";
        return;
      }
      _passwordFieldLabel = "Password (min 8 characters)";
      _loginButtonText = "Create account";
      _signUpText = "Login";
      _titleText = "It's good to have you here.";
    });
    loginLogger.i('Sign up requested');
  }

  void _onSubmitLoginForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid fields. Try again.")),
      );
      return;
    }
    if (_onSignup) {
      _validCreds.add({
        "email": _emailController.text,
        "password": _passwordController.text,
      });
      _onClickSignup();
      return;
    }
    if (!_validCreds.any((creds) {
      return creds["email"] == _emailController.text.trim() &&
          creds["password"] == _passwordController.text.trim();
    })) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid credentials. Try again.")),
      );
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Loading.")));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ForecastView()),
    );
  }
}

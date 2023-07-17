import 'package:asuka/asuka.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/auth/auth_cubit.dart';
import 'package:safe_lopes_family/src/resources/images.dart';
import 'package:safe_lopes_family/src/widgets/safe_family_text_form_field/safe_family_text_form_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool visiblePassword = true;
  final AuthCubit authCubit = Modular.get();
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 22, fontFamily: 'Nunito'),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 22, top: 22, right: 22),
            child: BlocConsumer(
              listener: (context, state) {
                if (state.runtimeType == AuthErrorState) {
                  final errorState = state as AuthErrorState;
                  Asuka.showSnackBar(
                      SnackBar(content: Text(errorState.message)));
                }
              },
              bloc: authCubit,
              builder: (context, state) {
                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.logo,
                        width: 120,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Safe Family',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SafeFamilyTextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'E-mail',
                        prefixIcon: const Icon(
                          Icons.email,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo vazio';
                          }
                          if (!EmailValidator.validate(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SafeFamilyTextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: visiblePassword,
                        maxLength: 8,
                        labelText: 'Senha',
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visiblePassword = !visiblePassword;
                            });
                          },
                          icon: Icon(
                            visiblePassword
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo vazio';
                          }
                          if (value.length < 8) {
                            return 'Mínimo 8 dígitos';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Modular.to.pushNamed('/auth/forgot-password/'),
                            child: const Text(
                              'Esqueci minha senha',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await authCubit.signIn(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                }
                              },
                              child: state.runtimeType == AuthLoadingState
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Entrar'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Modular.to.pushNamed('/registration/');
                              },
                              child: const Text('Cadastrar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

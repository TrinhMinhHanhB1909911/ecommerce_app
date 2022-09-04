import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/screen/forget_password_page.dart';
import 'package:ecommerce_app/screen/home_page.dart';
import 'package:ecommerce_app/screen/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/signin/signin_cubit.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late GlobalKey<FormState> formKey;
  late TextEditingController phoneController;
  late TextEditingController passController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    phoneController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    phoneController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('My shop'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: ListView(
            children: [
              const SizedBox(height: 50),
              Text(
                'Đăng nhập',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextFormField(
                validator: (value) =>
                    context.read<SignInCubit>().validatePhone(value!),
                keyboardType: TextInputType.number,
                controller: phoneController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  label: const Text('Số điện thoại'),
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) {
                  if (state is SignInInitial) {
                    return buildInputPasswordInitial();
                  }
                  if (state is SignInPasswordVisibility) {
                    return buildInputPasswordWithObscure(state);
                  }
                  return buildInputPasswordInitial();
                },
              ),
              const SizedBox(height: 20),
              BlocListener<SignInCubit, SignInState>(
                listener: (context, state) {
                  if (state is SignIned) {
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(builder: (_) => const HomePage()),
                    );
                  }
                  if (state is SignInValidator) {
                    bool result = formKey.currentState!.validate();
                    if (result) {
                      context
                          .read<SignInCubit>()
                          .onSignIn(phoneController.text, passController.text);
                    }
                  }
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all<Size>(const Size(60, 60)),
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                    ),
                    onPressed: () {
                      context.read<SignInCubit>().onValidator();
                      context.read<HomeCubit>().mainTab();
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
              BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) {
                  if (state is SignInMessage) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        state.message ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              BlocListener<SignInCubit, SignInState>(
                listener: (context, state) {
                  if (state is SignUp) {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => const SignUpPage()),
                    );
                  }
                },
                child: TextButton(
                  onPressed: () => context.read<SignInCubit>().onRegister(),
                  child: Text(
                    'Đăng ký',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.red),
                  ),
                ),
              ),
              BlocListener<SignInCubit, SignInState>(
                listener: (context, state) {
                  if (state is SignInForgetPassword) {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                          builder: (_) => const ForgetPasswordPage()),
                    );
                  }
                },
                child: TextButton(
                  onPressed: () =>
                      context.read<SignInCubit>().onForgetPassword(),
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputPasswordInitial() {
    return buildInputPassword(
      obscure: true,
      Icons.visibility_off_rounded,
      onPress: () => context.read<SignInCubit>().onObscureClick(true),
    );
  }

  Widget buildInputPasswordWithObscure(SignInPasswordVisibility state) {
    if (state.isObscureText) {
      return buildInputPassword(
        obscure: state.isObscureText,
        Icons.visibility_off_rounded,
        onPress: () =>
            context.read<SignInCubit>().onObscureClick(state.isObscureText),
      );
    }
    return buildInputPassword(
      obscure: state.isObscureText,
      Icons.remove_red_eye_rounded,
      onPress: () =>
          context.read<SignInCubit>().onObscureClick(state.isObscureText),
    );
  }

  Widget buildInputPassword(IconData? iconData,
      {required bool obscure, required VoidCallback onPress}) {
    return TextFormField(
      validator: (value) => context.read<SignInCubit>().validatePassword(value),
      controller: passController,
      obscureText: obscure,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: const Text('Mật khẩu'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        prefixIcon: const Icon(Icons.password_rounded),
        suffixIcon: IconButton(
          icon: Icon(iconData),
          onPressed: onPress,
        ),
      ),
    );
  }
}

import 'package:ecommerce_app/cubit/signup/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late GlobalKey<FormState> formKey;
  late TextEditingController phoneController;
  late TextEditingController passController;
  late TextEditingController confirmController;
  late TextEditingController nameController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    passController = TextEditingController();
    confirmController = TextEditingController();
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    phoneController.dispose();
    passController.dispose();
    confirmController.dispose();
    nameController.dispose();
    addressController.dispose();
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          children: [
            const SizedBox(height: 50),
            Text(
              'Đăng ký',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            buildTextFormField(
              'Họ tên',
              Icons.perm_identity_rounded,
              nameController,
              context.read<SignUpCubit>().nameValidator,
            ),
            const SizedBox(height: 20),
            buildTextFormField(
              'Địa chỉ',
              Icons.location_pin,
              addressController,
              context.read<SignUpCubit>().addressValidator,
            ),
            const SizedBox(height: 20),
            buildTextFormField(
              'Số điện thoại',
              Icons.phone_rounded,
              phoneController,
              context.read<SignUpCubit>().phoneValidator,
              type: TextInputType.number,
            ),
            const SizedBox(height: 20),
            buildTextFormField(
              'Mật khẩu',
              Icons.password_rounded,
              passController,
              context.read<SignUpCubit>().passwordValidator,
              isObscureText: true,
            ),
            const SizedBox(height: 20),
            buildTextFormField(
              'Xác nhận mật khẩu',
              Icons.confirmation_num_rounded,
              confirmController,
              context.read<SignUpCubit>().confirmValidator,
              isObscureText: true,
            ),
            const SizedBox(height: 20),
            BlocBuilder<SignUpCubit, SignUpState>(
              builder: (context, state) {
                if (state is SignUpMessage) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.message ?? '',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            BlocListener<SignUpCubit, SignUpState>(
              listener: (context, state) {
                if (state is SignUpSuccess) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text('Đăng ký thành công'),
                        actions: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              context.read<SignUpCubit>().onSignUped();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('OK'),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                if (state is SignUped) {
                  Navigator.of(context).pop();
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
                  onPressed: () async {
                    bool result = formKey.currentState!.validate();
                    if (result) {
                      await context.read<SignUpCubit>().onSignUp(
                          phoneController.text,
                          passController.text,
                          confirmController.text);
                    }
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(
      String label,
      IconData prefixIconData,
      TextEditingController controller,
      String? Function(String? value)? validator,
      {bool? isObscureText = false,
      TextInputType? type}) {
    return TextFormField(
      keyboardType: type ?? TextInputType.text,
      obscureText: isObscureText ?? false,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
        label: Text(label),
        prefixIcon: Icon(prefixIconData),
      ),
    );
  }
}

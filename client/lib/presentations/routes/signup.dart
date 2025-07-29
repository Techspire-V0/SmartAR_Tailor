import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:smartar/core/services/auth_services.dart';
import 'package:smartar/data/consts.dart';
import 'package:smartar/data/sources/providers/index.dart';
import 'package:smartar/presentations/routes/pre_scan.dart';
import 'package:smartar/presentations/routes/signin.dart';
import 'package:smartar/presentations/widgets/shared/auth_guard.dart';
import 'package:smartar/presentations/widgets/shared/button.dart';
import 'package:smartar/presentations/widgets/shared/status_overlay.dart';
import 'package:smartar/presentations/widgets/shared/theme/toggle.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(statusMessageProv);

    if (status != null) {}
    return AuthGuard(
      redirectChild: PreScanScreen(),
      isNegativeAuth: true,

      child: StatusOverlayListener(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [ThemeToggle()],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                width: double.infinity,
                height: 105, // Reduced height
                color: Theme.of(context).primaryColor,
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(2, -20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Hello there, sign in to continue',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Custom label above the field for better styling
                          FormBuilder(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                    ),
                                  ),
                                ),

                                FormBuilderTextField(
                                  name: 'name',
                                  decoration: InputDecoration(
                                    // Remove labelText to avoid double label
                                    hintText: 'Enter your name',
                                    hintStyle: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                      fontSize: 15,
                                    ),
                                    fillColor: colorGrayLight,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal:
                                          18, // must match label left padding
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.match(
                                      RegExp(
                                        r'^(?:[A-Za-z]+)(?:\s[A-Za-z]+){1,2}$',
                                      ),
                                      errorText: "Provide your 2 or 3 Names",
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: 20),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                                FormBuilderTextField(
                                  name: 'email',
                                  decoration: InputDecoration(
                                    // Remove labelText to avoid double label
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                      fontSize: 15,
                                    ),
                                    fillColor: colorGrayLight,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal:
                                          18, // must match label left padding
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.email(),
                                  ]),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                                FormBuilderTextField(
                                  name: 'password',
                                  decoration: InputDecoration(
                                    // Remove labelText to avoid double label
                                    hintText: 'Enter your password',
                                    hintStyle: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                      fontSize: 15,
                                    ),
                                    fillColor: colorGrayLight,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal:
                                          18, // must match label left padding
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: textSecondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  obscureText: _obscurePassword,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(6),
                                  ]),
                                ),

                                const SizedBox(height: 20),
                                Button(
                                  text: 'Sign Up',
                                  color: Colors.white,
                                  isLoading: _isSubmitting,
                                  bgColor: primaryColor,
                                  onPressed: () async {
                                    setState(() {
                                      _isSubmitting = true;
                                    });
                                    if (_formKey.currentState
                                            ?.saveAndValidate() ??
                                        false) {
                                      await authServices.auth(
                                        ref,
                                        _formKey.currentState!.value,
                                        isSignin: false,
                                      );
                                    }
                                    setState(() {
                                      _isSubmitting = false;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                // Add "or" separator
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                        thickness: 0.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        "or",
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.tertiary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                        thickness: 0.5,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),
                                // Add "Continue with Google" button
                                Button(
                                  isOutline: true,
                                  icon: Image.asset(
                                    'assets/images/google_logo.png',
                                    width: 22,
                                  ),
                                  text: "Continue with Google",
                                  color: Theme.of(context).colorScheme.tertiary,
                                  onPressed: () async {
                                    setState(() {
                                      _isSubmitting = true;
                                    });
                                    await authServices.googleAuth(ref);
                                    setState(() {
                                      _isSubmitting = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignInPage()),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

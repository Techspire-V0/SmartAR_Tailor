import 'package:SmartAR/data/consts.dart';
import 'package:SmartAR/presentations/routes/signup.dart';
import 'package:SmartAR/presentations/widgets/shared/button.dart';
import 'package:SmartAR/presentations/widgets/shared/theme/toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            height: 120, // Reduced height
            color: Theme.of(context).primaryColor,
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // Add spacing between label and form box
          Expanded(
            child: Transform.translate(
              offset: const Offset(2, -40),
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
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
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
                          const SizedBox(height: 24),

                          // Custom label above the field for better styling
                          FormBuilder(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Email or Username',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                      ),
                                    ),
                                  ),
                                ),
                                FormBuilderTextField(
                                  name: 'email',
                                  decoration: InputDecoration(
                                    // Remove labelText to avoid double label
                                    hintText: 'Enter your email or username',
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
                                const SizedBox(height: 24),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
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
                                  ]),
                                ),
                                const SizedBox(height: 24),
                                Button(
                                  text: 'Sign In',
                                  color: Colors.white,
                                  bgColor: primaryColor,
                                  onPressed: () {
                                    if (_formKey.currentState
                                            ?.saveAndValidate() ??
                                        false) {
                                      // Handle sign in logic
                                      // final data = _formKey.currentState!.value;
                                    }
                                  },
                                ),
                                const SizedBox(height: 24),
                                // Add "or" separator
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Theme.of(context).dividerColor,
                                        thickness: 1,
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
                                              ).colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Theme.of(context).dividerColor,
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Add "Continue with Google" button
                                Button(
                                  isOutline: true,
                                  icon: Icon(
                                    FontAwesome5Brands.google,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 20,
                                  ),
                                  text: "Continue with Google",
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  onPressed: () {
                                    // Navigate to the next screen
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account? ',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignUpPage()),
                );
              },
              child: Text(
                'Sign up',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

part of auth_card;

class _LoginCard extends StatefulWidget {
  _LoginCard(
      {Key? key,
      this.loadingController,
      required this.userValidator,
      required this.passwordValidator,
      required this.onSwitchRecoveryPassword,
      required this.userType,
      this.onSwitchAuth,
      this.onSubmitCompleted,
      this.hideForgotPasswordButton = false,
      this.hideSignUpButton = false,
      this.loginAfterSignUp = true,
      this.hideProvidersTitle = false})
      : super(key: key);

  final AnimationController? loadingController;
  final FormFieldValidator<String>? userValidator;
  final FormFieldValidator<String>? passwordValidator;
  final Function onSwitchRecoveryPassword;
  final Function? onSwitchAuth;
  final Function? onSubmitCompleted;
  final bool hideForgotPasswordButton;
  final bool hideSignUpButton;
  final bool loginAfterSignUp;
  final bool hideProvidersTitle;
  final LoginUserType userType;

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _passController;
  TextEditingController? _confirmPassController;
  TextEditingController? _phoneController;
  TextEditingController? _addressController;

  var _isLoading = false;
  var _isSubmitting = false;
  var _showShadow = true;

  /// switch between login and signup
  late AnimationController _loadingController;
  late AnimationController _switchAuthController;
  late AnimationController _postSwitchAuthController;
  late AnimationController _submitController;

  ///list of AnimationController each one responsible for a authentication provider icon
  List<AnimationController> _providerControllerList = <AnimationController>[];

  Interval? _nameTextFieldLoadingAnimationInterval;
  Interval? _passTextFieldLoadingAnimationInterval;
  Interval? _textButtonLoadingAnimationInterval;
  late Animation<double> _buttonScaleAnimation;
  late var zomra;
  late var wilaya;
  bool get buttonEnabled => !_isLoading && !_isSubmitting;

  final List<String> zomraList = [
    "زمرة الدم",
    "'+A",
    "-A",
    "+B",
    "-B",
    "+AB",
    "-AB",
    "+O",
    "-O"
  ];
  final List<String> wilayaList = [
    "ولاية",
    "أدرار",
    "الشلف",
    "الأغواط",
    "أم البواقي",
    "باتنة",
    "بجاية",
    "بسكرة",
    "بشار",
    "البليدة",
    "البويرة",
    "تمنراست",
    "تبسة",
    "تلمسان",
    "تيارت",
    "تيزي وزو",
    "الجزائر",
    "الجلفة",
    "جيجل",
    "سطيف",
    "سعيدة",
    "سكيكدة",
    "سيدي بلعباس",
    "عنابة",
    "قالمة",
    "قسنطينة",
    "المدية",
    "مستغانم",
    "المسيلة",
    "معسكر",
    "ورقلة",
    "وهران",
    "البيض",
    "اليزي",
    "برج بوعريريج",
    "بومرداس",
    "الطارف",
    "تندوف",
    "تسمسيلت",
    "الوادي",
    "خنشلة",
    "سوق أهراس",
    "تيبازة",
    "ميلة",
    "عين الدفلى",
    "النعامة",
    "عين تموشنت",
    "غرداية",
    "غليزان",
    "المغير",
    "المنيعة",
    "أولاد جلال",
    "برج باجي مختار",
    "بني عباس",
    "تيميمون",
    "تقرت",
    "جانت",
    "عين صالح",
    "عين قزّام"
  ];

  //   static final FormFieldValidator<String> fullNameValidator = (value) {
  //   if (value!.isEmpty || value.length <= 5) {
  //     return 'الحقل فارغ';
  //   }
  //   return null;
  // };
  // static final FormFieldValidator<String> phoneValidator = (value) {
  //   if (value!.isEmpty || value.length <= 9) {
  //     return 'رقم الهاتف قصيرة جدا';
  //   }
  //   return null;
  // };

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<Auth>(context, listen: false);
    _nameController = TextEditingController(text: auth.name);
    _emailController = TextEditingController(text: auth.email);
    _phoneController = TextEditingController(text: auth.phone);
    _passController = TextEditingController(text: auth.password);
    _confirmPassController = TextEditingController(text: auth.confirmPassword);
    _addressController = TextEditingController(text: auth.address);
    zomra = zomraList[0];
    wilaya = wilayaList[0];
    _loadingController = widget.loadingController ??
        (AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1150),
          reverseDuration: Duration(milliseconds: 300),
        )..value = 1.0);

    _loadingController.addStatusListener(handleLoadingAnimationStatus);

    _switchAuthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _postSwitchAuthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _submitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _providerControllerList = auth.loginProviders
        .map(
          (e) => AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 1000),
          ),
        )
        .toList();

    _nameTextFieldLoadingAnimationInterval = const Interval(0, .85);
    _passTextFieldLoadingAnimationInterval = const Interval(.15, 1.0);
    _textButtonLoadingAnimationInterval =
        const Interval(.6, 1.0, curve: Curves.easeOut);
    _buttonScaleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Interval(.4, 1.0, curve: Curves.easeOutBack),
    ));
  }

  void handleLoadingAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.forward) {
      setState(() => _isLoading = true);
    }
    if (status == AnimationStatus.completed) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _loadingController.removeStatusListener(handleLoadingAnimationStatus);
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();

    _switchAuthController.dispose();
    _postSwitchAuthController.dispose();
    _submitController.dispose();

    _providerControllerList.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _switchAuthMode() {
    final auth = Provider.of<Auth>(context, listen: false);
    final newAuthMode = auth.switchAuth();

    if (newAuthMode == AuthMode.Signup) {
      _switchAuthController.forward();
    } else {
      _switchAuthController.reverse();
    }
  }

  Future<bool> _submit() async {
    // a hack to force unfocus the soft keyboard. If not, after change-route
    // animation completes, it will trigger rebuilding this widget and show all
    // textfields and buttons again before going to new route
    FocusScope.of(context).requestFocus(FocusNode());

    final messages = Provider.of<LoginMessages>(context, listen: false);

    if (!_formKey.currentState!.validate()) {
      return false;
    }

    _formKey.currentState!.save();
    await _submitController.forward();
    setState(() => _isSubmitting = true);
    final auth = Provider.of<Auth>(context, listen: false);
    String? error;

    if (auth.isLogin) {
      // error = await auth.onLogin!(
      //     LoginData(email: auth.email, password: auth.password, name: 'null', phone: 'null'));
      DB().login(auth.email, auth.password).then((msg) {
        if (msg == "لم يتم العثور على مستخدم لهذا البريد الإلكتروني." ||
            msg == "كلمة مرور خاطئة لهذا المستخدم") {
          showErrorToast(context, "خطأ", msg);
          setState(() => _isSubmitting = false);
        } else {
          showSuccessToast(context, "تم الدخول بنجاح", "مرحبا");
          Future.delayed(const Duration(seconds: 2), () {
            Nav().nav(Inbox(auth: msg), context);
          });
        }
      });
    } else {
      // error = await auth.onSignup!(LoginData(
      //   email: auth.email,
      //   password: auth.password,
      //   name: auth.name,
      //   phone: auth.phone,
      // ));
      DB().signup(auth.email, auth.password).then((msg) {
        if (msg == 'كلمة المرور المقدمة ضعيفة للغاية.' ||
            msg == 'الحساب موجود بالفعل لهذا البريد الإلكتروني.') {
          showErrorToast(context, "خطأ", msg);
          setState(() => _isSubmitting = false);
        } else {
          DB().setData(auth.phone, "newSubscribers", {
            "name": auth.name,
            "phone": auth.phone,
            "email": auth.email,
            "pwd": auth.password,
            "zomra": auth.zomra,
            "wilaya": auth.wilaya
          }).then((regst) {
            if (regst) {
              showSuccessToast(context, "تم التسجيل بنجاح", msg);
              Future.delayed(const Duration(seconds: 2), () {
                Nav().nav(Inbox(auth: auth), context);
              });
            } else {
              showErrorToast(context, "", "حدث خطأ خلال عملية التسجيل");
              setState(() => _isSubmitting = false);
            }
          });
        }

        // return "تم إرسال البريد الإلكتروني للتحقق";
      });
      // widget.onSwitchRecoveryPassword();
    }

    // workaround to run after _cardSizeAnimation in parent finished
    // need a cleaner way but currently it works so..
    Future.delayed(const Duration(milliseconds: 270), () {
      setState(() => _showShadow = false);
    });

    await _submitController.reverse();

    if (!DartHelper.isNullOrEmpty(error)) {
      // showErrorToast(context, messages.flushbarTitleError, error!);
      Future.delayed(const Duration(milliseconds: 271), () {
        setState(() => _showShadow = true);
      });
      setState(() => _isSubmitting = false);
      return false;
    }

    if (auth.isSignup && !widget.loginAfterSignUp) {
      // showSuccessToast(context, messages.flushbarTitleSuccess, messages.signUpSuccess);
      _switchAuthMode();
      setState(() => _isSubmitting = false);
      return false;
    }

    // widget.onSubmitCompleted!();

    return true;
  }

  Future<bool> _loginProviderSubmit(
      {required AnimationController control,
      required ProviderAuthCallback callback}) async {
    await control.forward();

    String? error;

    error = await callback();

    // workaround to run after _cardSizeAnimation in parent finished
    // need a cleaner way but currently it works so..
    Future.delayed(const Duration(milliseconds: 270), () {
      setState(() => _showShadow = false);
    });

    await control.reverse();

    final messages = Provider.of<LoginMessages>(context, listen: false);

    if (!DartHelper.isNullOrEmpty(error)) {
      showErrorToast(context, messages.flushbarTitleError, error!);
      Future.delayed(const Duration(milliseconds: 271), () {
        setState(() => _showShadow = true);
      });
      return false;
    }

    widget.onSubmitCompleted!();

    return true;
  }

  Widget _buildEmailField(
    double width,
    LoginMessages messages,
    Auth auth,
  ) {
    return AnimatedTextFormField(
      controller: _emailController,
      width: width,
      loadingController: _loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: messages.userHint,
      autofillHints: [TextFieldUtils.getAutofillHints(widget.userType)],
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextFieldUtils.getKeyboardType(widget.userType),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      validator: widget.userValidator,
      onSaved: (value) => auth.email = value!,
    );
  }

  Widget _buildUserField(
    double width,
    LoginMessages messages,
    Auth auth,
  ) {
    return AnimatedTextFormField(
      width: width,
      // animatedWidth: width,
      enabled: auth.isSignup,
      loadingController: _loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: 'الإسم الكامل',
      controller: _nameController,
      textInputAction: TextInputAction.done,
      focusNode: _nameFocusNode,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_phoneFocusNode);
      },
      validator: auth.isSignup
          ? (value) {
              if (value != _nameController!.text || value!.isEmpty) {
                return "الإسم مطلوب";
              }
              return null;
            }
          : (value) => null,
      onSaved: (value) => auth.name = value!,
    );
  }

  Widget _buildAddressField(
    double width,
    LoginMessages messages,
    Auth auth,
  ) {
    return AnimatedTextFormField(
      width: width,
      // animatedWidth: width,
      enabled: auth.isSignup,
      loadingController: _loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: 'العنوان',
      controller: _addressController,
      textInputAction: TextInputAction.done,
      focusNode: _addressFocusNode,
      onFieldSubmitted: (value) {
        _submit();
      },
      validator: auth.isSignup
          ? (value) {
              if (value != _addressController!.text || value!.isEmpty) {
                return "العنوان مطلوب";
              }
              return null;
            }
          : (value) => null,
      onSaved: (value) => auth.address = value!,
    );
  }

  Widget _buildPasswordField(double width, LoginMessages messages, Auth auth) {
    return AnimatedPasswordTextFormField(
      animatedWidth: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.passwordHint,
      autofillHints:
          auth.isLogin ? [AutofillHints.password] : [AutofillHints.newPassword],
      controller: _passController,
      textInputAction:
          auth.isLogin ? TextInputAction.done : TextInputAction.next,
      focusNode: _passwordFocusNode,
      onFieldSubmitted: (value) {
        if (auth.isLogin) {
          _submit();
        } else {
          // SignUp
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
        }
      },
      validator: widget.passwordValidator,
      onSaved: (value) => auth.password = value!,
    );
  }

  Widget _buildConfirmPasswordField(
      double width, LoginMessages messages, Auth auth) {
    return AnimatedPasswordTextFormField(
      animatedWidth: width,
      enabled: auth.isSignup,
      loadingController: _loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: messages.confirmPasswordHint,
      controller: _confirmPassController,
      textInputAction: TextInputAction.next,
      focusNode: _confirmPasswordFocusNode,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      },
      validator: auth.isSignup
          ? (value) {
              if (value != _passController!.text || value!.isEmpty) {
                return messages.confirmPasswordError;
              }
              return null;
            }
          : (value) => null,
      onSaved: (value) => auth.confirmPassword = value!,
    );
  }

  Widget _buildPhoneField(double width, LoginMessages messages, Auth auth) {
    return AnimatedTextFormField(
      width: width,
      // animatedWidth: width,
      keyboardType: TextInputType.phone,
      enabled: auth.isSignup,
      loadingController: _loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: 'هاتف',
      controller: _phoneController,
      textInputAction: TextInputAction.next,
      focusNode: _phoneFocusNode,
      onFieldSubmitted: (value) =>
          FocusScope.of(context).requestFocus(_addressFocusNode),
      validator: auth.isSignup
          ? (value) {
              if (value != _phoneController!.text || value!.length <= 9) {
                return "فارغ";
              }
              return null;
            }
          : (value) => null,
      onSaved: (value) => auth.phone = value!,
    );
  }

  Widget _buildZomraField(double width, LoginMessages messages, Auth auth) {
    return Container(
        width: 100.0,
        height: 60.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.grey[800]),
        padding: EdgeInsets.all(1.0),
        child: DropdownButtonFormField(
          alignment: Alignment.center,
          validator: auth.isSignup
              ? (value) {
                  if (value == null || value == "زمرة الدم") {
                    return "زمرة الدم مطلوبة";
                  }
                  return null;
                }
              : (value) => null,
          hint: Text(
            "زمرة الدم",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Hacen'),
          ),
          // value: wilaya,
          isDense: true,
          onChanged: (value) {
            setState(() {
              auth.zomra = value.toString();
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          items: zomraList.map((value) {
            return DropdownMenuItem<String>(
              alignment: Alignment.center,
              value: value,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildWilayaField(double width, LoginMessages messages, Auth auth) {
    return Container(
        width: 150.0,
        height: 60.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.grey[800]),
        padding: EdgeInsets.all(1.0),
        child: DropdownButtonFormField(
          alignment: Alignment.center,
          validator: auth.isSignup
              ? (value) {
                  if (value == null || value == "ولاية") {
                    return "الولاية مطلوبة";
                  }
                  return null;
                }
              : (value) => null,
          hint: Text(
            "ولاية",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Hacen'),
          ),
          // value: wilaya,
          isDense: true,
          onChanged: (value) {
            setState(() {
              auth.wilaya = value.toString();
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          items: wilayaList.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildForgotPassword(ThemeData theme, LoginMessages messages) {
    return FadeIn(
      controller: _loadingController,
      fadeDirection: FadeDirection.bottomToTop,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      child: TextButton(
        onPressed: buttonEnabled
            ? () {
                // save state to populate phone field on recovery card
                _formKey.currentState!.save();
                widget.onSwitchRecoveryPassword();
              }
            : null,
        child: Text(
          messages.forgotPasswordButton,
          style: theme.textTheme.bodyText2,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
      ThemeData theme, LoginMessages messages, Auth auth) {
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: AnimatedButton(
        controller: _submitController,
        text: auth.isLogin ? messages.loginButton : messages.signupButton,
        onPressed: _submit,
      ),
    );
  }

  Widget _buildSwitchAuthButton(ThemeData theme, LoginMessages messages,
      Auth auth, LoginTheme loginTheme) {
    final calculatedTextColor =
        (theme.cardTheme.color!.computeLuminance() < 0.5)
            ? Colors.white
            : theme.primaryColor;
    return FadeIn(
      controller: _loadingController,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      fadeDirection: FadeDirection.topToBottom,
      child: MaterialButton(
        disabledTextColor: theme.primaryColor,
        onPressed: buttonEnabled ? _switchAuthMode : null,
        padding: loginTheme.authButtonPadding ??
            EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textColor: loginTheme.switchAuthTextColor ?? calculatedTextColor,
        child: AnimatedText(
          text: auth.isSignup ? messages.loginButton : messages.signupButton,
          textRotation: AnimatedTextRotation.down,
        ),
      ),
    );
  }

  Widget _buildProvidersLogInButton(ThemeData theme, LoginMessages messages,
      Auth auth, LoginTheme loginTheme) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: auth.loginProviders.map((loginProvider) {
          var index = auth.loginProviders.indexOf(loginProvider);
          return Padding(
            padding: loginTheme.providerButtonPadding ??
                const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            child: ScaleTransition(
              scale: _buttonScaleAnimation,
              child: Column(
                children: [
                  AnimatedIconButton(
                    icon: loginProvider.icon,
                    controller: _providerControllerList[index],
                    tooltip: '',
                    onPressed: () => _loginProviderSubmit(
                      control: _providerControllerList[index],
                      callback: () {
                        return loginProvider.callback();
                      },
                    ),
                  ),
                  Text(loginProvider.label)
                ],
              ),
            ),
          );
        }).toList());
  }

  Widget _buildProvidersTitle(LoginMessages messages) {
    return ScaleTransition(
        scale: _buttonScaleAnimation,
        child: Row(children: <Widget>[
          Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(messages.providersTitle),
          ),
          Expanded(child: Divider()),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: true);
    final isLogin = auth.isLogin;
    final messages = Provider.of<LoginMessages>(context, listen: false);
    final loginTheme = Provider.of<LoginTheme>(context, listen: false);
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.9, 360.0);
    const cardPadding = 16.0;
    final textFieldWidth = cardWidth - cardPadding * 2;
    final authForm = Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: cardPadding,
              right: cardPadding,
              top: cardPadding + 10,
            ),
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildEmailField(textFieldWidth, messages, auth),
                SizedBox(height: 20),
                _buildPasswordField(textFieldWidth, messages, auth),
                SizedBox(height: 10),
              ],
            ),
          ),
          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: _buildConfirmPasswordField(textFieldWidth, messages, auth),
          ),
          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: _buildUserField(textFieldWidth, messages, auth),
          ),
          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: _buildPhoneField(textFieldWidth, messages, auth),
          ),
          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildZomraField(textFieldWidth, messages, auth),
                _buildWilayaField(textFieldWidth, messages, auth),
              ],
            ),
          ),
          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: _buildAddressField(textFieldWidth, messages, auth),
          ),
          Container(
            padding: Paddings.fromRBL(cardPadding),
            width: cardWidth,
            child: Column(
              children: <Widget>[
                !widget.hideForgotPasswordButton
                    ? _buildForgotPassword(theme, messages)
                    : SizedBox.fromSize(
                        size: Size.fromHeight(16),
                      ),
                _buildSubmitButton(theme, messages, auth),
                !widget.hideSignUpButton
                    ? _buildSwitchAuthButton(theme, messages, auth, loginTheme)
                    : SizedBox.fromSize(
                        size: Size.fromHeight(10),
                      ),
                auth.loginProviders.isNotEmpty && !widget.hideProvidersTitle
                    ? _buildProvidersTitle(messages)
                    : Container(),
                _buildProvidersLogInButton(theme, messages, auth, loginTheme),
              ],
            ),
          ),
        ],
      ),
    );

    return FittedBox(
      child: Card(
        elevation: _showShadow ? theme.cardTheme.elevation : 0,
        child: authForm,
      ),
    );
  }
}

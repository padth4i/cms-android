import 'package:cms_android/screens/home.dart';
import 'package:cms_android/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool passwordInvisible = true;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _usernameController,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'HKGrotesk',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              hintText: 'Enter your Username',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: passwordInvisible,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'HKGrotesk',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordInvisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    passwordInvisible = !passwordInvisible;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.amberAccent,
              activeColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.amber,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'HKGrotesk',
          ),
        ),
        onPressed: () async {
          final String authMutation = '''
                        mutation{
                          tokenAuth(username:"${_usernameController.text}", password:"${_passwordController.text}") {
                            token
                            }
                        }
                        ''';

          final HttpLink httpLink = HttpLink(
            uri: 'https://api.amfoss.in/',
          );
          GraphQLClient _client = GraphQLClient(
              link: httpLink,
              cache:
                  OptimisticCache(dataIdFromObject: typenameDataIdFromObject));
          QueryResult result =
              await _client.mutate(MutationOptions(document: authMutation));

          String token = result.data['tokenAuth']['token'];
          final AuthLink authLink = AuthLink(
            getToken: () async => 'JWT $token',
          );
          final Link link = authLink.concat(httpLink);

          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                username: _usernameController.text,
                url: link,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          'Powered by CMS',
          style: kLabelStyle,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                ),
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/amfoss.png', width: MediaQuery.of(context).size.width / 3.5),
                    SizedBox(height: 30.0),
                    _buildEmailTF(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _buildPasswordTF(),
                    // TODO: Implement remember me
                    // _buildRememberMeCheckbox(),
                    SizedBox(height: 30,),
                    _buildLoginBtn(),
                    _buildSignInWithText(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

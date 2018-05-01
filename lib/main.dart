import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Form Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Form Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  bool _termsChecked = false;
  int radioValue = -1;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
          margin: const EdgeInsets.all(20.0),
          child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                    height: 20.0,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (String value) {
                      email = value;
                    },
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    onSaved: (String value) {
                      password = value;
                    },
                    validator: _validatePassword,
                    obscureText: true,
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new Column(
                    children: <Widget>[
                      new RadioListTile<int>(
                          title: new Text('Male'),
                          value: 0,
                          groupValue: radioValue,
                          onChanged: handleRadioValueChange),
                      new RadioListTile<int>(
                          title: new Text('Female'),
                          value: 1,
                          groupValue: radioValue,
                          onChanged: handleRadioValueChange),
                      new RadioListTile<int>(
                          title: new Text('Transgender'),
                          value: 2,
                          groupValue: radioValue,
                          onChanged: handleRadioValueChange),
                    ],
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new CheckboxListTile(
                      title: new Text('Terms and Conditionns'),
                      value: _termsChecked,
                      onChanged: (bool value) =>
                          setState(() => _termsChecked = value)),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new RaisedButton(
                    onPressed: _validateInputs,
                    child: new Text('Login'),
                  )
                ],
              ))),
    );
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';
  }

  String _validatePassword(String value) {
    if (value.length > 5) {
      return null;
    }

    return 'Password must be upto 6 characters';
  }

  void handleRadioValueChange(int value) {
    print(value);
    setState(() => radioValue = value);
  }

  void _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms has validated.
      // Let's validate radios and checkbox
      if (radioValue < 0) {
        // None of the radio buttons was selected
        _showSnackBar('Please select your gender');
      } else if (!_termsChecked) {
        // The checkbox wasn't checked
        _showSnackBar("Please accept our terms");
      } else {
        // Every of the data in the form are valid at this point
        form.save();
        showDialog(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
                  content: new Text("All inputs are valid"),
                ));
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      content: new Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

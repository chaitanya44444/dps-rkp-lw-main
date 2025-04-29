import 'package:flutter/material.dart';
import 'package:lw/pages/signup.dart';
import 'package:lw/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InterestInputChips extends StatefulWidget {
  final List<String> initialInterests;
  final ValueChanged<List<String>>? onInterestsChanged;

  const InterestInputChips({
    Key? key,
    this.initialInterests = const [],
    this.onInterestsChanged,
  }) : super(key: key);

  @override
  _InterestInputChipsState createState() => _InterestInputChipsState();
}

class _InterestInputChipsState extends State<InterestInputChips> {
  final List<String> _interests = [];
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _interests.addAll(widget.initialInterests);
    _textEditingController.addListener(_onTextChanged);
    _focusNode.addListener(() {});
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onTextChanged);
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _textEditingController.text;
    if (text.isNotEmpty && text.endsWith(' ')) {
      final word = text.substring(0, text.length - 1).trim();
      if (word.isNotEmpty && !_interests.contains(word)) {
        setState(() {
          _interests.add(word);
          widget.onInterestsChanged?.call(_interests);
        });
      }
      _textEditingController.clear();
    }
  }

  void _removeInterest(String interest) {
    setState(() {
      _interests.remove(interest);
      widget.onInterestsChanged?.call(_interests);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _interests.map((interest) {
            return Chip(
              label: Text(interest),
              onDeleted: () => _removeInterest(interest),
              deleteIcon: Icon(Icons.cancel, size: 18.0),
              backgroundColor: Colors.blue.shade100,
              labelStyle: TextStyle(color: Colors.blue.shade800),
              deleteIconColor: Colors.blue.shade800,
            );
          }).toList(),
        ),
        SizedBox(height: 12.0),
        TextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Enter interests (i.e. crypto-mining)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          ),
          onSubmitted: (value) {
            final word = value.trim();
            if (word.isNotEmpty && !_interests.contains(word)) {
              setState(() {
                _interests.add(word);
                widget.onInterestsChanged?.call(_interests);
              });
            }
            _textEditingController.clear();
          },
        ),
      ],
    );
  }
}

class Interests extends StatefulWidget {
  const Interests({Key? key}) : super(key: key);


  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  List<String> _userInterests = ["crypto-mining"];

  String? _username;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final AuthenticationService _authService = AuthenticationService(FirebaseAuth.instance);

  void _submit(String? username, List<String> interests) async{
    _authService.addUserToDB(auth.currentUser!.uid, username.toString(), auth.currentUser!.email.toString(), DateTime.now(), interests);

    Navigator.pushNamed(context, "/landingscreen");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null && args is String) {
        setState(() {
          _username = args;
        });
      } else {
         print('No String data received or data is of wrong type.');
         setState(() {
           _username = 'user';
         });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Interests'),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Your Interests:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                InterestInputChips(
                  initialInterests: ['crypto-mining'],
                  onInterestsChanged: (interests) {
                    setState(() {
                      _userInterests = interests;
                    });
                    print('Current interests: $_userInterests');
                  },
                ),
                SizedBox(height: 20.0),
                Text('Saved Interests: ${_userInterests.join(', ')}'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _submit(_username, _userInterests),
                  child: Text('Submit'),
                ),
              ],
            )

          ],

        ),
      ),

    );

  }
}

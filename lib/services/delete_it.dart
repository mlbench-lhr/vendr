// // You must add 'google_sign_in: ^6.1.6' (or the latest version) to your pubspec.yaml file.
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// // Note: If you uncomment the backend HTTP request, you will need to import 'dart:convert' and 'package:http/http.dart' as http;

// // IMPORTANT: Replace this with the Web Client ID from your Google Cloud Project.
// // This is the Client ID of the "Web application" type, not the Android/iOS type.
// // It is essential for generating the ID Token needed for backend verification.
// const String googleWebClientId = "YOUR_WEB_CLIENT_ID_FROM_GCP";

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Google Sign-In Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//         useMaterial3: true,
//       ),
//       home: const GoogleSignInScreen(),
//     );
//   }
// }

// class GoogleSignInScreen extends StatefulWidget {
//   const GoogleSignInScreen({super.key});

//   @override
//   State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
// }

// class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
//   // 1. Initialize GoogleSignIn instance
//   // The serverClientId is required to ensure an ID token is returned,
//   // which your Node.js backend needs to verify the user's identity.
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: <String>['email'], // Requesting email scope
//     serverClientId: googleWebClientId, // Crucial for backend verification
//   );

//   // State variables for UI
//   GoogleSignInAccount? _currentUser;
//   String _authStatus = 'Signed out';

//   @override
//   void initState() {
//     super.initState();
//     // Listen for sign-in changes immediately when the screen loads
//     _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//       setState(() {
//         _currentUser = account;
//         if (_currentUser != null) {
//           _authStatus = 'Signed in as ${_currentUser!.displayName ?? 'User'}';
//         } else {
//           _authStatus = 'Signed out';
//         }
//       });
//     });

//     // Check if the user is already signed in from a previous session
//     _googleSignIn.signInSilently();
//   }

//   // 2. Handle the sign-in process
//   Future<void> _handleSignIn() async {
//     try {
//       // This launches the Google Sign-in flow (e.g., a browser or dialog).
//       await _googleSignIn.signIn();
//       // On success, the listener set in initState handles state update.
//       // We explicitly call this to immediately get the token post-sign-in.
//       _fetchAuthDetails();
//     } catch (error) {
//       setState(() {
//         _authStatus = 'Error signing in: $error';
//       });
//       print('Sign-in error: $error');
//     }
//   }

//   // 3. Extract the ID Token and Profile Data
//   Future<void> _fetchAuthDetails() async {
//     final GoogleSignInAccount? user = _currentUser;
//     if (user == null) {
//       // Should not happen if called after successful sign-in, but safe guard.
//       return;
//     }

//     setState(() {
//       _authStatus = 'Fetching authentication details...';
//     });

//     try {
//       // Get the authentication object, which contains the ID Token.
//       final GoogleSignInAuthentication googleAuth = await user.authentication;

//       // *** THIS IS THE CRITICAL DATA FOR YOUR NODE.JS BACKEND ***
//       final String? idToken = googleAuth.idToken;

//       if (idToken != null) {
//         // Log the token and profile data (for demonstration)
//         print('----------------------------------------------------');
//         print('Google ID Token (to be sent to Node.js backend):');
//         print(idToken);
//         print('----------------------------------------------------');
//         print('User Email: ${user.email}');
//         print('User Display Name: ${user.displayName}');
//         print('User ID: ${user.id}');
//         print('----------------------------------------------------');

//         setState(() {
//           _authStatus = 'Authenticated! Token retrieved. Ready to send to Node.js.';
//           // Here, you would typically make a POST request to your Node.js backend:
//           /*
//           // NOTE: You would need to add package:http/http.dart as http; and dart:convert
//           final response = await http.post(
//             Uri.parse('YOUR_NODEJS_BACKEND_URL/auth/google'),
//             headers: {'Content-Type': 'application/json'},
//             body: json.encode({'token': idToken}),
//           );
//           // Handle the backend's response (e.g., set a local JWT session token).
//           if (response.statusCode == 200) {
//             final backendToken = json.decode(response.body)['token'];
//             // Save backendToken locally (e.g., using shared_preferences or flutter_secure_storage)
//             _authStatus = 'Successfully logged in via Node.js backend!';
//           } else {
//             _authStatus = 'Backend failed to verify token: ${response.statusCode}';
//           }
//           */
//         });
//       } else {
//         setState(() {
//           _authStatus = 'Authentication failed: ID Token is null.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _authStatus = 'Error during token retrieval: $e';
//       });
//       print('Token retrieval error: $e');
//     }
//   }

//   // 4. Handle sign-out
//   Future<void> _handleSignOut() => _googleSignIn.signOut();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google Sign-In (Flutter to Node.js)'),
//         backgroundColor: Colors.indigo.shade700,
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               // Display User Info if signed in
//               if (_currentUser != null) ...[
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage: NetworkImage(_currentUser!.photoUrl ?? 'https://placehold.co/100x100/A0A0FF/ffffff?text=U'),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   _currentUser!.displayName ?? 'User',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   _currentUser!.email,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                 ),
//                 const SizedBox(height: 32),
//               ],

//               // Status Message
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.indigo.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.indigo.shade200),
//                 ),
//                 child: Text(
//                   'Status: $_authStatus',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.indigo.shade800),
//                 ),
//               ),

//               const SizedBox(height: 40),

//               // Sign-in/Sign-out Button
//               ElevatedButton.icon(
//                 onPressed: _currentUser == null ? _handleSignIn : _handleSignOut,
//                 icon: Icon(
//                   _currentUser == null ? Icons.login : Icons.logout,
//                   color: Colors.white,
//                 ),
//                 label: Text(
//                   _currentUser == null ? 'Sign in with Google' : 'Sign out',
//                   style: const TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _currentUser == null ? Colors.indigo.shade600 : Colors.red.shade400,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   elevation: 5,
//                 ),
//               ),
              
//               const SizedBox(height: 20),
              
//               // Button to show the ID Token (only visible after sign-in)
//               if (_currentUser != null)
//                 OutlinedButton.icon(
//                   onPressed: _fetchAuthDetails,
//                   icon: const Icon(Icons.security, color: Colors.indigo),
//                   label: const Text(
//                     'Get ID Token (Send to Backend)',
//                     style: TextStyle(fontSize: 16, color: Colors.indigo),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     side: BorderSide(color: Colors.indigo.shade300),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
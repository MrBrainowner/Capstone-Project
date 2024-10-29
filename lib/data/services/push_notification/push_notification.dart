// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

// class FirebasePushNotification {
//   static Future<String> getAccessToken() async {
//     //========================================================== service account json
//     final serviceAccountJson = {
//       "type": "service_account",
//       "project_id": "barbershop-booking-syste-cbffd",
//       "private_key_id": "740ce5c852b177e16fa12de7da784a585701c2b3",
//       "private_key":
//           "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDVEjEJMeVbd8W6\nljkJSfpyZyRLuiOBxQUI+h79D5oIGl39WWprTJJmOCtKib/t/8TM3iU147ne5sB0\nBE6wGjic3bFLjKl4EeFLFXBN+ZPXTi6eP5DVouUubWwkq7W6q7b6ghGCRyfUPOhg\n+ESqeZ9w19xqCEZb9gBVzs3FsXYSCGVI1JgzCA6FQMdpUEZ10u8ks5PkEJCKQa/5\n+q3GF+TeutmFIL3xrktDAYv/9wjNaSnEjCCtdefNp9eIbdwU59hBmn45Kvt06zUS\n45qjLWpZBw1KUI8/rmYYwoupi5tyRq7qvOcRiqV1tpmuWHKcN5LgnZ8Mwsx+zmT+\ndEQAsKvbAgMBAAECggEABEuoStH/IRk+FoyqbV57ATFeqYWjHnup+2wdmkjtvIoE\nV+/GpNO77qR+6qqLzYQX4/kLvAAGzzs7oKGLEPhpBoFe3W2eGsHAMKL0pLB1B8s1\naMp0Rr8dd4FhsqcpjaeAHEwtukCt2lCOCMSRGDkBagu+bWU2ceqBR7EL79MSO0PM\n2P2LqkALrjaNjdxLJUNzIcxiz7Shxa9PURys0Z82lb7VmCWWMOHv/hFnr3CKFGm/\nfTfghjAIiLh/4W+95BcTQ2Y1AZ7iIeIT86mL0gAEJnEGh/aGAY4MeoyAzvEoqW3o\nYLDeZzeN7fPBwq6LK7OqY6zwJt0nQhX100iz423rdQKBgQDtCU5wi9cAVHuozN3s\ndpwUSDC4yTbgdewUlNF4wl2TKAv4ASlTndvi2wE+pBGQcHHfrVFRnUxZYBea7rHy\ndvJ4AsDU8U8ClHmifBNZZ8K3qCeTtg6vAa96WBwKD0ECerKxGc0qyhu5I5kzRn19\nm+utmVNnzBqhqTNpXqpeY5JpvwKBgQDmHg6Mzwa56Du5tKNLMhb060P+COFsTlRr\nFkOd6NJMdtyh6ivVI7MiNOATiGeCtMWaVs1Le3K3HqOeZxtqzW3sDA8a7XJ5MKUK\nfe3Jdgp+ZAvHo+BomBiA4DrmsnJN6Evkgvcu8q9lmxLvQzvy4WDmlotvoSDQ/nWC\nBPHIwcTs5QKBgGFILYIxUkcXZT0M/5O5xiroyd487qHGo+J6hVHra14m1Gqvh1eC\n9Siwu10LFw5Rp9qmFjbJuPkBYA69IhkhyjeI4b1DYCrt5tHR3FsYI6kegUe1M2eN\n6Ifsu21Bf2vWEZpvvW1vT1t3ibuqlXxEzsALqlhyQwfQGoKHUKK2ePOfAoGBAJ1w\n/RV746c4a/yfyYV+LNS/TpK1Mr4uTXXDEtosXA3y2PtywzCdr0b9FD5o+iEkW3pA\nX0+Ak7kUHnAXLVwCV23DxmXvBX5DOPgXtqQ6ve1BuAmMZtJJFaK/R61lc+03vQ0I\nSeR2KGkFE4xd3NtNNkYtxBLJFDHJl04w4dgwMvK9AoGBAMzsx/EsYv1LpMbAtXKb\nmC/I5bmpuiPdRUBLy+F4eWWTT4gUBxMgaPYmZ+Dx+Cbyua8tbu78EjSyjgL6hGvQ\nKuXg/i0nwQ0hJ+ymQTgDfhigTSiqhau2NbrNXdEu1QCQ37XViQiuua55AFg/yygR\nSMYnHS7YIfMYrGmt4Q29tZS1\n-----END PRIVATE KEY-----\n",
//       "client_email":
//           "barbermate-push-notification@barbershop-booking-syste-cbffd.iam.gserviceaccount.com",
//       "client_id": "111717536647880597897",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url":
//           "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url":
//           "https://www.googleapis.com/robot/v1/metadata/x509/barbermate-push-notification%40barbershop-booking-syste-cbffd.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com"
//     };

//     List<String> scopes = [
//       "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/userinfo.email",
//       "https://www.googleapis.com/auth/firebase.messaging"
//     ];

//     http.Client client = await auth.clientViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//       scopes,
//     );

//     //========================================================== Get the acces token
//     auth.AccessCredentials credentials =
//         await auth.obtainAccessCredentialsViaServiceAccount(
//             auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//             scopes,
//             client);

//     client.close();

//     return credentials.accessToken.data;
//   }

//   static sendNotificationToSelectedUser(
//       String deviceToken, BuildContext context, String bookingId) async {
//     final String serverAccessTokenKey = await getAccessToken();
//     String endpointFirebaseCloudMessaging =
//         'https://fcm.googleapis.com/v1/projects/barbershop-booking-syste-cbffd/messages:send';

//     final Map<String, dynamic> message = {
//       'message': {
//         'token': deviceToken,
//         'notification': {'title': "Lorem Ipsum", 'body': "lorem ipsum"},
//         'data': {
//           'bookingId': bookingId,
//         }
//       }
//     };

//     final http.Response response = await http.post(
//       Uri.parse(endpointFirebaseCloudMessaging),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $serverAccessTokenKey'
//       },
//       body: jsonEncode(message),
//     );

//     if (response.statusCode == 200) {
//       print("Notification sent Successfully");
//     } else {
//       print("Failed to send FCM message: ${response.statusCode}");
//     }
//   }
// }

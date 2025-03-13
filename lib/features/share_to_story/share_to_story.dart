// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:social_share/social_share.dart';
// import 'package:widgets_to_image/widgets_to_image.dart';
//
// class ShareToStoryScreen extends StatefulWidget {
//   const ShareToStoryScreen({super.key});
//
//   @override
//   State<ShareToStoryScreen> createState() => _ShareToStoryScreenState();
// }
//
// class _ShareToStoryScreenState extends State<ShareToStoryScreen> {
//   // WidgetsToImageController to access widget
//   WidgetsToImageController controller = WidgetsToImageController();
//
// // to save image bytes of widget
//   Uint8List? bytes;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Share To Story Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             WidgetsToImage(
//               controller: controller,
//               child: sharedWidget(),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () async {
//                 final bytes = await controller.capture();
//
//                 if (bytes == null) return;
//
//                 // 4. Faylni vaqtinchalik papkaga saqlash
//                 final tempDir = await getTemporaryDirectory();
//                 final filePath = '${tempDir.path}/my_screenshot.png';
//                 final file = File(filePath);
//                 await file.writeAsBytes(bytes);
//
//                 await SocialShare.shareInstagramStory(
//                   backgroundTopColor: "#ffffff",
//                   backgroundBottomColor: "#ffffff",
//                   appId: 'com.example.lock_example',
//                   imagePath: filePath,
//                 );
//               },
//               child: const Text('Share To Story'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget sharedWidget() {
//     return Column(
//       children: [
//         Image.network(
//           'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?q=80&w=3538&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//         ),
//         const Text('Share To Story Screen'),
//       ],
//     );
//   }
// }

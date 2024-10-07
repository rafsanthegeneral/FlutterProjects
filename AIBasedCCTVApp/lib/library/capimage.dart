import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kimproject/library/firebasefile.dart';
import 'package:kimproject/library/publicvar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

//import 'dart:io';

class ImageCapturePopup extends StatefulWidget {
  @override
  _ImageCapturePopupState createState() => _ImageCapturePopupState();
}

class _ImageCapturePopupState extends State<ImageCapturePopup> {
  File? _image;

  Future<void> _checkPermissionAndPickImage(ImageSource source) async {
    final PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      _pickImage(source);
    } else if (status.isDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text('Please grant camera permission in settings.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (status.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text(
                'Camera permission is permanently denied. Please enable it in app settings.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      final directory = await getApplicationSupportDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${directory.path}/$fileName';

      final imageFile = File(pickedImage.path);
      await imageFile.copy(filePath);

      print('Image saved to: $filePath');
      PubicImageStoreVar.updateImagePathValue(filePath);
      // How many image Save

      final directoryy = await getApplicationSupportDirectory();
      final files = Directory(directoryy.path).listSync();

      // Filter the list to include only image files
      final imageFiles =
          files.where((file) => file.path.endsWith('.jpg')).toList();

      print('Number of saved images: ${imageFiles.length}');
      //imageFile.delete();
    } else {
      print('No image selected');
    }

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);

        // print(PublicValue.imagePathValue.value);
      });
    }
    Navigator.pop(context, _image);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Capture Image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () => _checkPermissionAndPickImage(ImageSource.camera),
            icon: Icon(Icons.camera),
            label: Text('Capture from Camera'),
          ),
          ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: Icon(Icons.photo_library),
            label: Text('Pick from Gallery'),
          ),
        ],
      ),
    );
  }
}

class ImageInfoDialog extends StatefulWidget {
  final String imagePath;

  ImageInfoDialog({required this.imagePath});

  @override
  _ImageInfoDialogState createState() => _ImageInfoDialogState();
}

class _ImageInfoDialogState extends State<ImageInfoDialog> {
  late String name;
  late String degicnation;
  late String status;
  File? capturedImage;

  @override
  void initState() {
    super.initState();
    capturedImage = File(widget.imagePath);
  }

  void showImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(capturedImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog();
      },
    );
  }

  showProgressDoneDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialogDone();
      },
    );
  }

  void performOperation(BuildContext context) {
    // Goto Back
    showProgressDialog(context);

    addPerson(name, degicnation, status).then((value) {
      final file = File(PubicImageStoreVar.imagePathValue.value);
      file.delete();
      print("Done");

      // Close the progress dialog
      Navigator.pop(context); //Goto Back
      Navigator.pop(context);
      //goto back
      showProgressDoneDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Text('Image Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (capturedImage != null)
                GestureDetector(
                  onTap: showImage,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(capturedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Person Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    degicnation = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Person Designation',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Person Type',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Process the captured image and information here
                // You can save the image, store the information, etc.
                performOperation(context);

                // Close the dialog
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () async {
                final file = File(PubicImageStoreVar.imagePathValue.value);
                if (await file.exists()) {
                  await file.delete();
                  print('Image file deleted');
                } else {
                  print('Image file not found');
                }
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressBox extends StatefulWidget {
  @override
  _ProgressBoxState createState() => _ProgressBoxState();
}

class _ProgressBoxState extends State<ProgressBox>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black45, Colors.white, Colors.yellow],
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: 200.0,
      height: 40.0,
      child: Center(
        child: Text(
          'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.0),
            Text(
              "Operation in Progress",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressDialogDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.done_all_rounded),
            SizedBox(height: 16.0),
            Text(
              "Done",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

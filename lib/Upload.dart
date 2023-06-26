import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cs310socialmedia/utils/progress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cs310socialmedia/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import "package:cs310socialmedia/login.dart";
class Upload extends StatefulWidget {
  final User2 currentUser;

  Upload({this.currentUser});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController locationController=TextEditingController();
  TextEditingController captionController=TextEditingController();
  final _picker = ImagePicker();
  File file;
  PickedFile pickedFile;
  bool isUploading=false;
  String postId=Uuid().v4();

  compressImage() async{
    final tempDir= await getTemporaryDirectory();
    final path=tempDir.path;
    Im.Image imageFile= Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile= File('$path/img_$postId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile,quality:85));
    setState(() {
      file=compressedImageFile;
    });
  }
  createPostInFirestore({String mediaUrl, String location, String description}){
    print("firestore");
    print(currentUser.userName);

    postsRef
        .doc(currentUser.id)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId":postId,
      "ownerId":currentUser.id,
      "username":currentUser.userName,
      "mediaUrl":mediaUrl,
      "description":description,
      "location":location,
      "timestamp":timestamp,
      "likes":{},
      "dislikes":{},
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask=storageRef.child("post_$postId.jpg").putFile(imageFile);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
  handleSubmit()async{
    print(isUploading);
    setState(() {
      isUploading=true;
    });
    print(isUploading);
    await compressImage();
    String mediaUrl= await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    print(isUploading);
    locationController.clear();
    captionController.clear();
    setState(() {
      file=null;
      isUploading=false;
      postId=Uuid().v4();
    });
  }
  handleTakePhoto() async {
    print("entered!!");
    Navigator.pop(context);
    PickedFile pickedFile = await _picker.getImage( source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,);
    file = File(pickedFile.path);
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    print("entered!!");
    Navigator.pop(context);
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery,);
    file = File(pickedFile.path);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"), onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/upload.svg', height: 260.0),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "Upload Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
                color: Colors.deepOrange,
                onPressed: () => selectImage(context)),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: Text(
          "Caption Post",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () =>handleSubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            /*leading: CircleAvatar(
              backgroundImage:
              CachedNetworkImageProvider(widget.currentUser.photoUrl),
            ),*/
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          /*Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              label: Text(
                "Use Current Location",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.blue,
              onPressed: () => print('get user location'),
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}

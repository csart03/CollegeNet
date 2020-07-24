import 'dart:io';
import 'package:collegenet/services/loading.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';

class PostView extends StatefulWidget {
  PostView(
      {this.caption,
      this.username,
      this.content,
      this.url,
      this.fileExt,
      this.postId,
      this.isFile});
  final String caption;
  final String username;
  final String content;
  final String url;
  final String fileExt;
  final String postId;
  final bool isFile;
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  String percentage;
  bool downloading = false;
  Dio dio = Dio();
  bool isDownloaded = false;
  String ext;
  String dirloc =
      '/storage/emulated/0/Android/data/com.example.collegenet/files/';

  downloadFile() async {
    setState(() {
      downloading = true;
    });
    // await Permission.storage.request();
    await Permission.storage.shouldShowRequestRationale;
    try {
      FileUtils.mkdir([dirloc]);
      await dio.download(widget.url, dirloc + widget.postId + widget.fileExt,
          onReceiveProgress: (receivedBytes, totalBytes) {
        setState(() {
          downloading = true;
          percentage =
              ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print("Error: " + e.toString());
    }
    setState(() {
      downloading = false;
      isDownloaded = true;
    });
  }

  @override
  void initState() {
    //  getUserById();
    super.initState();
    setState(() {
      isDownloaded = false;
      ext = widget.fileExt;
      checkifdownloaded();
    });
  }

  checkifdownloaded() async {
    String filePath = dirloc + widget.postId + widget.fileExt;
    if (await File(filePath).exists()) {
      setState(() {
        isDownloaded = true;
      });
    } else {
      setState(() {
        isDownloaded = false;
      });
    }
  }

  IconData returnIcon() {
    switch (ext) {
      case ".jpg":
        {
          return FontAwesome5.file_image;
        }
        break;
      case ".png":
        {
          return FontAwesome5.file_image;
        }
        break;
      case ".svg":
        {
          return FontAwesome5.file_image;
        }
        break;
      case ".mp3":
        {
          return FontAwesome5.file_audio;
        }
        break;
      case ".wav":
        {
          return FontAwesome5.file_audio;
        }
        break;
      case ".pdf":
        {
          return FontAwesome5.file_audio;
        }
        break;
      case ".zip":
        {
          return FontAwesome5.file_archive;
        }
        break;
      case ".pptx":
        {
          return FontAwesome5.file_powerpoint;
        }
        break;
      case ".rar":
        {
          return FontAwesome5.file_archive;
        }
        break;
      case ".xlsx":
        {
          return FontAwesome5.file_excel;
        }
        break;
      case ".docx":
        {
          return FontAwesome5.file_word;
        }
      case ".mp4":
        {
          return FontAwesome5.file_video;
        }
        break;
      case ".mkv":
        {
          return FontAwesome5.file_video;
        }
        break;
      default:
        {
          return FontAwesome5.file;
        }
    }
  }

  Widget postViewExpanded(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange[700],
              Colors.orange[600],
              Colors.orange[300]
            ],
            begin: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            downloading ? linearProgress() : Container(),
            Center(
              child: Text(
                widget.caption,
                style: TextStyle(
                  fontFamily: 'SaucerBB',
                  fontSize: 40.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              "Uploaded By :",
              style: TextStyle(
                  color: Colors.black, fontSize: 30, fontFamily: 'Lato'),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.username,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: 'PermanentMarker'),
              ),
            ),
            SizedBox(height: 20.0),
            (widget.isFile)
                ? (isDownloaded == false)
                    ? RaisedButton(
                        child: Text('Download File'),
                        onPressed: downloading ? null : () => downloadFile(),
                      )
                    : Row(
                        children: <Widget>[
                          Icon(
                            returnIcon(),
                            size: 40.0,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            onPressed: () async {
                              String filePath =
                                  dirloc + widget.postId + widget.fileExt;
                              try {
                                await OpenFile.open(filePath);
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Text(
                              'Open File',
                              style:
                                  TextStyle(fontFamily: 'Lato', fontSize: 30.0),
                            ),
                          ),
                        ],
                      )
                : Container(),
            SizedBox(height: 30.0),
            Text(
              widget.content,
              style: TextStyle(fontFamily: 'Lato', fontSize: 25.0),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return postViewExpanded();    
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegenet/services/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../widgets/app_drawer.dart';
import '../providers/event1.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';

final eventsfileRef = Firestore.instance.collection("eventsfile");
final StorageReference storageRef = FirebaseStorage.instance.ref();

class NewEvent extends StatefulWidget {
  static const routeName = '/hp';

  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  File file;
  String cnt;
  int length = 0;
  String eventimageid = Uuid().v4();
  String currentimageurl = "";

  bool isUploading = false;
  bool toggleValue = false;
  final _fNode = FocusNode();
  final _dfNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _sd1 = TextEditingController();
  final _st1 = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedEvent = Event2(
    id: null,
    imageId: null,
    title: '',
    description: '',
    imageURL: '',
    noOfPraticipants: 0,
    fee: '',
    startDate: DateTime.now().toString(),
    startTime: DateTime.now().toString(),
    count: 0,
  );
  var _isInit = true;
  var _isLoading = false;
  var _initValue = {
    'title': '',
    'description': '',
    'fee': '',
    'noOfParticipants': '',
    'imageURL': '',
    'startDate': '',
    'endDate': '',
    'startTime': '',
    'endTime': '',
  };
  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final evntId = ModalRoute.of(context).settings.arguments as String;
      if (evntId != null) {
        _editedEvent =
            Provider.of<Events>(context, listen: false).findById(evntId);
        _initValue = {
          'title': _editedEvent.title,
          'description': _editedEvent.description,
          'imageId': _editedEvent.imageId,
          'fee': _editedEvent.fee.toString(),

          'noOfParticipants': _editedEvent.noOfPraticipants.toString(),
          'imageURL': '',
          // 'imageId': _editedEvent.imageId,
          'count': _editedEvent.count.toString(),
        };
        _imageURLController.text = _editedEvent.imageURL;
        _sd1.text = _editedEvent.startDate;
        _st1.text = _editedEvent.startTime;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageUrl);
    _fNode.dispose();
    _dfNode.dispose();
    _imageURLController.dispose();
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageURLFocusNode.hasFocus) {
      if ((!_imageURLController.text.endsWith('.png') &&
          !_imageURLController.text.endsWith('.jpg') &&
          !_imageURLController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
//    handleUpload();
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedEvent.id != null) {
      await Provider.of<Events>(context, listen: false).updateEvent(
        _editedEvent.id,
        _editedEvent,
      );
      Navigator.of(context).pop();
    } else {
      print(_editedEvent.imageURL);
      try {
        await Provider.of<Events>(context, listen: false)
            .addEvent(_editedEvent);
        Navigator.of(context).pushReplacementNamed('/');
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('And Error Ocurred!'),
            content: Text('Something Went Wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    // Navigator.of(context).pop();
  }

  void _selectDate(TextEditingController _x) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2021),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      _x.text = DateFormat.yMd().format(pickedDate);
      print(_x);
    });
  }

  void _selectTime(TextEditingController _x) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      _x.text = pickedTime.format(context);
    });
  }

  String getExtension(File file) {
    int len = file.path.length;
    int idx = file.path.lastIndexOf('.');
    String ext = '';
    for (; idx < len; idx++) {
      ext = ext + file.path[idx];
    }
    print(ext);
    return ext;
  }

  createEventinFirestore(String mediaURL, String eventname, String eventid) {
    eventsfileRef.document(eventid).setData(
        {"eventid": eventid, "eventname": eventname, "imageURL": mediaURL});
    currentimageurl = mediaURL;
  }

  Future<String> uploadImage(File file) async {
    if (file != null) {
      setState(() {
        isUploading = true;
      });
      StorageUploadTask uploadTask = storageRef
          .child("eventsfile_$eventimageid" + getExtension(file))
          .putFile(file);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      setState(() {
        isUploading = false;
      });
      return downloadUrl;
    } else {
      print("we find file is null");
      return "we find file is null";
    }
  }

  handleUpload() async {
    String imageURL = await uploadImage(file);
    print(imageURL + "thisisit");
    if (imageURL != null) {
      createEventinFirestore(imageURL, _initValue['title'], eventimageid);
      _editedEvent = Event2(
        title: _editedEvent.title,
        imageId: _editedEvent.imageId,
        description: _editedEvent.description,
        imageURL: imageURL,
        // imageId: _editedEvent.imageId,
        noOfPraticipants: _editedEvent.noOfPraticipants,
        startDate: _editedEvent.startDate,
        count: _editedEvent.count,
        startTime: _editedEvent.startTime,
        fee: _editedEvent.fee,
        id: _editedEvent.id,
        isGoing: _editedEvent.isGoing,
      );
    } else {
      setState(() {
        cnt = "no file chosen";
      });
      return cnt;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Host a Event'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: circularProgress(),
            )
          : Form(
              key: _form,
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          initialValue: _initValue['title'],
                          decoration: InputDecoration(
                            labelText: 'Name of the Event',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_fNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedEvent = Event2(
                              title: value,
                              description: _editedEvent.description,
                              imageId: eventimageid,
                              imageURL: _editedEvent.imageURL,
                              noOfPraticipants: _editedEvent.noOfPraticipants,
                              startDate: _editedEvent.startDate,
                              count: _editedEvent.count,
                              startTime: _editedEvent.startTime,
                              fee: _editedEvent.fee,
                              id: _editedEvent.id,
                              // imageId: eventimageid,
                              isGoing: _editedEvent.isGoing,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValue['noOfParticipants'],
                          decoration: InputDecoration(
                              labelText: 'Number of Participants in a team'),
                          textInputAction: TextInputAction.next,
                          focusNode: _fNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_dfNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a value.';
                            }
                            if (int.tryParse(value) == null ||
                                int.tryParse(value) < 0) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedEvent = Event2(
                              title: _editedEvent.title,
                              imageId: eventimageid,
                              description: _editedEvent.description,
                              imageURL: _editedEvent.imageURL,
                              noOfPraticipants: int.parse(value),
                              startDate: _editedEvent.startDate,
                              count: _editedEvent.count,
                              startTime: _editedEvent.startTime,
                              fee: _editedEvent.fee,
                              id: _editedEvent.id,
                              // imageId: eventimageid,
                              isGoing: _editedEvent.isGoing,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValue['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _dfNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedEvent = Event2(
                              title: _editedEvent.title,
                              description: value,
                              imageId: eventimageid,
                              imageURL: _editedEvent.imageURL,
                              noOfPraticipants: _editedEvent.noOfPraticipants,
                              startDate: _editedEvent.startDate,
                              startTime: _editedEvent.startTime,
                              count: _editedEvent.count,
                              fee: _editedEvent.fee,
                              id: _editedEvent.id,
                              // imageId: eventimageid,
                              isGoing: _editedEvent.isGoing,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValue['fee'],
                          decoration:
                              InputDecoration(labelText: 'Registration Link'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.url,
                          onSaved: (value) {
                            _editedEvent = Event2(
                              title: _editedEvent.title,
                              description: _editedEvent.description,
                              imageURL: _editedEvent.imageURL,
                              imageId: eventimageid,
                              noOfPraticipants: _editedEvent.noOfPraticipants,
                              startDate: _editedEvent.startDate,
                              count: _editedEvent.count,
                              startTime: _editedEvent.startTime,
                              fee: value,
                              id: _editedEvent.id,
                              // imageId: eventimageid,
                              isGoing: _editedEvent.isGoing,
                            );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Center(
                              child: RaisedButton(
                                color: Colors.orange,
                                child: Text('Upload Image'),
                                onPressed: isUploading
                                    ? null
                                    : () async {
                                        file = await FilePicker.getFile();
                                        setState(() {
                                          if (file == null) {
                                            return "Please Upload an image";
                                          } else {
                                            String fileName =
                                                file.path.split('/').last;
                                            cnt = "$fileName";
                                            print(file);
                                            handleUpload();
                                            return cnt;
                                          }
                                        });
                                      },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        isUploading
                            ? cubicalProgress()
                            : Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.only(
                                  top: 8,
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(_editedEvent.imageURL),
                                        fit: BoxFit.cover)),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Starts on:'),
                        InkWell(
                          onTap: () {
                            _selectDate(
                                _sd1); // Call Function that has showDatePicker()
                          },
                          child: IgnorePointer(
                            child: new TextFormField(
                              decoration:
                                  new InputDecoration(hintText: 'Start Date'),
                              maxLength: 30,
                              controller: _sd1,
                              onSaved: (value) {
                                _editedEvent = Event2(
                                  title: _editedEvent.title,
                                  description: _editedEvent.description,
                                  imageURL: _editedEvent.imageURL,
                                  imageId: eventimageid,
                                  noOfPraticipants:
                                      _editedEvent.noOfPraticipants,
                                  startDate: value,
                                  startTime: _editedEvent.startTime,
                                  fee: _editedEvent.fee,
                                  id: _editedEvent.id,
                                  // imageId: eventimageid,
                                  isGoing: _editedEvent.isGoing,
                                  count: _editedEvent.count,
                                );
                              },
                            ),
                          ),
                        ),
                        Text('At:'),
                        InkWell(
                          onTap: () {
                            _selectTime(
                                _st1); // Call Function that has showDatePicker()
                          },
                          child: IgnorePointer(
                            child: new TextFormField(
                              decoration:
                                  new InputDecoration(hintText: 'Start Time'),
                              maxLength: 30,
                              controller: _st1,
                              onSaved: (value) {
                                _editedEvent = Event2(
                                  title: _editedEvent.title,
                                  description: _editedEvent.description,
                                  imageURL: _editedEvent.imageURL,
                                  imageId: eventimageid,
                                  noOfPraticipants:
                                      _editedEvent.noOfPraticipants,
                                  startDate: _editedEvent.startDate,
                                  startTime: value,
                                  fee: _editedEvent.fee,
                                  id: _editedEvent.id,
                                  // imageId: eventimageid,
                                  isGoing: _editedEvent.isGoing,
                                  count: _editedEvent.count,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

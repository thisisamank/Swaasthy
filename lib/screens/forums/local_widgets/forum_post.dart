import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/index.dart';
import 'package:codered/services/index.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class ForumPost extends StatefulWidget {
  final ForumPostModel data;
  final int index;

  ForumPost({this.data, this.index});

  @override
  _ForumPostState createState() => _ForumPostState();
}

class _ForumPostState extends State<ForumPost>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  bool isLoadingComments = false;

  bool isInitialFetch = true;

  DocumentSnapshot lastDocument;

  bool hasFetchedAll = false;

  void _expandHandler() {
    // if(!isExpanded){
    setState(() => isExpanded = !isExpanded);

    // }
  }

  @override
  Widget build(BuildContext context) {
    RepliesService _commentsService =
        Provider.of<RepliesService>(context, listen: false);

    List<ReplyModel> _commentsList =
        _commentsService.getComments(index: widget.index);

    if (isExpanded &&
        _commentsService.getComments(index: widget.index).length == 0 &&
        _commentsService.getCommentsCount(widget.index) >
            _commentsService.getComments(index: widget.index).length) {}

    void getComments() async {
      setState(() {
        isLoadingComments = true;
        isInitialFetch = false;
      });

      List<DocumentSnapshot> _commentsDocuments =
          await ForumsHelper.getComments(widget.data.postID,
              _commentsService.getLastDocument(widget.index));

      // ignore: null_aware_before_operator
      if (_commentsDocuments?.length > 0 && _commentsDocuments != null) {
        print("NOT NULL");

        List<ReplyModel> _commentModels = _commentsDocuments
            .map((e) => ReplyModel.getModel(e.data(), e.id))
            .toList();

        List<ReplyModel> _tempList = [];
        _tempList.addAll(_commentsList);
        _tempList.addAll(_commentModels);

        if (_commentsService.getLastDocument(widget.index) == null) {
          _commentsService.addCommentList(_commentsDocuments, widget.index);
        } else {
          _commentsService.updateCommentsList(
              index: widget.index, comments: _commentsDocuments);
        }

        print("LAST : ${_commentsDocuments.length}");

        setState(() {
          try {
            // ignore: unrelated_type_equality_checks
            if (_commentsDocuments.last == [] ||
                _commentsDocuments.last == null) {
              hasFetchedAll = true;
            }
          } catch (e) {}
          // lastDocument = _commentsDocuments.last;
          _commentsService.assignLastDocument(
              widget.index, _commentsDocuments.last);
          isLoadingComments = false;
        });
      } else {
        setState(() {
          isLoadingComments = false;
          hasFetchedAll = true;
        });
      }

      print(_commentsList.length);
    }

    if (isInitialFetch) {
      getComments();
    }

    return Container(
      decoration: BoxDecoration(color: Color(0xffFAFAFA), boxShadow: [
        BoxShadow(
            offset: Offset(0, 2),
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 3)
      ]),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          ForumPostHeader(
              user: widget.data.user, timestamp: widget.data.timestamp),

          if (widget.data.type == ForumPostType.text)
            ForumPostContent(title: widget.data.title, body: widget.data.body),

          ForumPostControls(
              postID: widget.data.postID,
              index: this.widget.index,
              isExpanded: isExpanded,
              expandHandler: _expandHandler),

          NewCommentInput(
            index: this.widget.index,
            postID: widget.data.postID,
          ),

          AnimatedSize(
            duration: Duration(milliseconds: 200),
            vsync: this,
            child: isExpanded
                ? ForumPostComments(
                    postID: widget.data.postID,
                    index: this.widget.index,
                    moreComments: getComments,
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

class NewCommentInput extends StatefulWidget {
  final int index;
  final String postID;

  const NewCommentInput({
    Key key,
    @required this.index,
    @required this.postID,
  }) : super(key: key);

  @override
  _NewCommentInputState createState() => _NewCommentInputState();
}

class _NewCommentInputState extends State<NewCommentInput> {
  TextEditingController _commentTextController;

  FocusNode _commentFocusNode = FocusNode();

  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _commentTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        newcommentsheet(
          context,
          widget.index,
          username: "himanshusharma89",
          userThumb:
              "https://avatars.githubusercontent.com/u/44980497?s=460&u=5b2102210b217bce36e5d9905ca780163bb8f8ff&v=4",
          userID: "qUOmsgFAwKPHaBSAWTnLah7sjMd2",
        );
      },
      child: Container(
        color: Color(0xffeeeeee),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                  autofocus: false,
                  enabled: false,
                  style: TextStyle(color: CodeRedColors.text),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                      hintText: "Write your reply...",
                      hintStyle:
                          TextStyle(fontSize: 14, color: CodeRedColors.text))),
            ),
          ],
        ),
      ),
    );
  }

  newcommentsheet(
    BuildContext context,
    int index, {
    @required String username,
    @required String userThumb,
    @required String userID,
  }) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          ConnectionStatus _connectionStatus =
              Provider.of<ConnectionStatus>(context, listen: true);

          return Container(
            color: CodeRedColors.inputFields,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            autofocus: true,
                            controller: _commentTextController,
                            focusNode: _commentFocusNode,
                            textCapitalization: TextCapitalization.sentences,
                            style:
                                TextStyle(color: CodeRedColors.secondaryText),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: InputBorder.none,
                                hintText: "Write your reply...",
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: CodeRedColors.secondaryText))),
                      ),
                      Container(
                          child: Center(
                              child: IconButton(
                                  icon: Icon(Icons.keyboard_hide,
                                      color: Colors.grey[600]),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    FocusScope.of(context).unfocus();
                                  }))),
                      SizedBox(width: 5),
                      Container(
                          padding: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: IconButton(
                                icon: Icon(Icons.send,
                                    color: CodeRedColors.primary),
                                color: Colors.white,
                                onPressed: () async {
                                  Navigator.pop(context);

                                  if (_connectionStatus ==
                                      ConnectionStatus.Offline) {
                                    Navigator.pop(context);
                                    displaySnackbar(context,
                                        "Internet Connection is required.");
                                  } else if (_commentTextController.value.text
                                          .trim()
                                          .length ==
                                      0) {
                                    displaySnackbar(
                                        context, "Replies can't be empty.");
                                  } else {
                                    Provider.of<RepliesService>(context,
                                            listen: false)
                                        .updateComment(
                                            index: widget.index,
                                            comment: ReplyModel(
                                                user: PostUserModel(
                                                    userID: userID,
                                                    userimage: userThumb,
                                                    username: username),
                                                body: _commentTextController
                                                    .value.text,
                                                key: UniqueKey(),
                                                timestamp: Timestamp.fromDate(
                                                    DateTime.now())));

                                    ForumsHelper.addReplyToFirestore(
                                        postID: widget.postID,
                                        data: {
                                          'body':
                                              _commentTextController.value.text,
                                          'user': {
                                            'user_id': userID,
                                            'user_name': username,
                                            'user_image': userThumb
                                          }
                                        });
                                  }

                                  _commentTextController.clear();
                                }),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

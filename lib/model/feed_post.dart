class feedPost{
  String type_post;  //like, dislike comment or follow
  String date; //when it is sent
  String userprofile_img;
  int postID; //which post is liked, if it is a follow request it will be null
  int userID;
  String username; //the user who send like, comment or follow request
  String post_img;
  String comment;
  feedPost({this.type_post,this.date, this.userprofile_img,this.postID,this.userID,this.username,this.post_img,this.comment});
}
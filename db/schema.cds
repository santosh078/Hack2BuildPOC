namespace TestEYShare;

using
{
    Country,
    Currency,
    Language,
    User,
    cuid,
    extensible,
    managed,
    temporal
}
from '@sap/cds/common';

entity Users : managed
{
    name : String(100);
    key email : String(100);
    profileImage : LargeBinary;
    mimetype : String(100);
    password : String(100);
    dob : Date;
    base_location : String(100);
    role : String(100);
    handle : String(100);
    communityId : String(100);
}

entity Photos : cuid, managed
{
    image : LargeBinary;
    mimetype : String(100);
    caption : LargeString;
    tags : many String(100);
    location : String(100);
    points : Integer;
    userId : String(100);
}

entity Comments : cuid, managed
{
    comment : LargeString;
    photoId : String(100);
    userId : String(100);
}

entity community : cuid, managed
{
    description : LargeString;
    photoId : String(100);
    user_id : String(100);
}

entity follows : cuid, managed
{
    followedId : String(100);
    followerId : String;
    mute : Boolean;
}

entity likes :  managed
{
    key photoId : String(100);
    key userId : String(100);
}
entity share : cuid, managed
{
    photoId : String(100);
    userId : String(100);
}

entity user2community
{
    key user : Association to one Users;
    key community : Association to one community;
}

entity Events:cuid, managed {   
userId : String(100);
eventName:String(100);
description : LargeString;
dateOfEvent: Date;
image : LargeBinary;
mimetype: String(100);
taggedUsers: many String(1000);
}

entity EventAttendance {   
eventId : String(100);
userId : String(100);
attending: String(20);
}



entity wall as select
from Photos
inner join follows
    on Photos.userId = follows.followedId
    and follows.mute = false
inner join Users
    on follows.followerId= Users.email  
left outer join likes
    on Photos.ID= likes.photoId
left outer join Comments
    on Photos.ID= Comments.photoId
left outer join share
    on Photos.ID= share.photoId

{
    Photos.ID,
    Photos.image,
    Photos.mimetype,
    Photos.caption,
    Photos.tags,
    Photos.location,
    Photos.points,
    Photos.userId,
    follows.followedId,
    follows.followerId,
    Users.profileImage,
    Users.mimetype as userProfileMimeType:String(50),
    Users.role,
    Users.handle,
    COUNT(likes.photoId) OVER (PARTITION BY Photos.ID) AS likesCount:Integer,
    COUNT(Comments.photoId) OVER (PARTITION BY Photos.ID) AS commentsCount:Integer,
    COUNT(share.photoId) OVER (PARTITION BY Photos.ID) AS shareCount:Integer 
};
entity Points as
    select from Photos
    inner join likes
        on Photos.ID = likes.photoId
    {
        Photos.tags,
        Photos.userId as postedUser:String(50),
        likes.userId as likedUser:String(50),
        likes.createdAt
   };



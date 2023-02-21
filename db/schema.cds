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
    key userId : UUID
        @Core.Computed;
    name : String(100);
    email : String(100);
    profileImage : LargeBinary;
    password : String(100);
    dob : Date;
    base_location : String(100);
    role : String(100);
    handle : String(100);
    photos : Association to many Photos on photos.users = $self;
    comments : Composition of many Comments on comments.users = $self;
    follows : Composition of many follows on follows.users = $self;
    likes : Composition of many likes on likes.users = $self;
    community : Association to one community;
}

entity Photos : cuid, managed 
{
    @Core.MediaType: mediaType
    @Core.ContentDisposition.Filename: filename
    data: LargeBinary;
    @Core.IsMediaType
    mediaType: String;
    filename: String;
    caption : LargeString;
    tags : many String(100);
    userId : String(100);
    location : String(100);
    points : Integer;
    comments : Association to many Comments on comments.photos = $self;
    users : Association to one Users;
    likes : Composition of many likes on likes.photos = $self;
}

entity Comments : managed
{
    key commentId : UUID
        @Core.Computed;
    comment : LargeString;
    photoId : String(100);
    userId : String(100);
    photos : Association to one Photos;
    users : Association to one Users;
}

entity community : managed
{
    key id : UUID
        @Core.Computed;
    description : LargeString;
    userId : String(100);
    photoId : String(100);
}

entity follows : managed
{
    key id : UUID
        @Core.Computed;
    followedId : String(100);
    followerId : String;
    mute : Boolean;
    users : Association to one Users;
}

entity likes : managed
{
    key id : UUID
        @Core.Computed;
    photoId : String(100);
    userId : String(100);
    users : Association to one Users;
    photos : Association to one Photos;
}

entity user2community {
  key user : Association to Users;
  key community : Association to community;
}

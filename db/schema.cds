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

entity Users : cuid, managed
{
    name : String(100)
        @Core.Computed;
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
}

entity Photos : cuid, managed
{
    image : LargeBinary
        @Core.Computed
        @Core.MediaType : imageType;
    imageType : String
        @Core.IsMediaType;
    caption : LargeString;
    tags : many String(100);
    location : String(100);
    points : Integer;
    comments : Association to many Comments on comments.photos = $self;
    users : Association to one Users;
    likes : Composition of many likes on likes.photos = $self;
}

entity Comments : cuid, managed
{
    comment : LargeString
        @Core.Computed;
    photoId : String(100);
    userId : String(100);
    photos : Association to one Photos;
    users : Association to one Users;
}

entity community : cuid, managed
{
    description : LargeString
        @Core.Computed;
    photoId : String(100);
    user_id : String(100);
}

entity follows : cuid, managed
{
    followedId : String(100)
        @Core.Computed;
    followerId : String;
    mute : Boolean;
    users : Association to one Users;
}

entity likes : cuid, managed
{
    photoId : String(100)
        @Core.Computed;
    userId : String(100);
    users : Association to one Users;
    photos : Association to one Photos;
}

entity user2community
{
    key user : Association to one Users;
    key community : Association to one community;
}

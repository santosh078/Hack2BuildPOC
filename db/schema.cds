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

entity Users
{
    key userId : UUID
        @Core.Computed;
    name : String(100);
    email : String(100);
    profileImage : LargeBinary;
    password : String(100);
    createdAt : DateTime;
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

entity Photos
{
    key photoId : UUID
        @Core.Computed;
    image : LargeBinary;
    caption : LargeString;
    tags : many String(100);
    userId : String(100);
    createdAt : DateTime;
    location : String(100);
    points : Integer;
    comments : Association to many Comments on comments.photos = $self;
    users : Association to one Users;
    likes : Composition of many likes on likes.photos = $self;
}

entity Comments
{
    key commentId : UUID
        @Core.Computed;
    createdAt : DateTime;
    comment : LargeString;
    photoId : String(100);
    userId : String(100);
    photos : Association to one Photos;
    users : Association to one Users;
}

entity community
{
    key id : UUID
        @Core.Computed;
    description : LargeString;
    userId : String(100);
    photoId : String(100);
    users : Association to many Users on users.community = $self;
}

entity follows
{
    key id : UUID
        @Core.Computed;
    createdAt : Date;
    followedId : String(100);
    followerId : String;
    mute : Boolean;
    users : Association to one Users;
}

entity likes
{
    key id : UUID
        @Core.Computed;
    createdAt : DateTime;
    photoId : String(100);
    userId : String(100);
    users : Association to one Users;
    photos : Association to one Photos;
}

entity wall as projection on Photos
{
    *,
    users.userId as user_id,
    users.name,
    users.profileImage,
    users.handle
};

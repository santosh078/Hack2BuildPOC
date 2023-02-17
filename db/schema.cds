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
    photos : Composition of many Photos on photos.users = $self;
}

entity Photos
{
    photoId : UUID;
    image : LargeBinary;
    caption : LargeString;
    tags : many String(100);
    userId : String(100);
    createdAt : DateTime;
    location : String(100);
    points : Integer;
    comments : Association to many Comments on comments.photos = $self;
    users : Association to one Users;
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
}

entity community
{
    key ID : UUID
        @Core.Computed;
    description : LargeString;
    userId : String(100);
    photoId : String(100);
}

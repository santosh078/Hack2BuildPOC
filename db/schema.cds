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

entity likes : cuid, managed
{
    photoId : String(100);
    userId : String(100);
}

entity user2community
{
    key user : Association to one Users;
    key community : Association to one community;
}

entity wall as select
from Photos
inner join follows
    on Photos.userId = follows.followedId
    and follows.mute = false
{
    Photos.image,
    Photos.mimetype,
    Photos.caption,
    Photos.tags,
    Photos.location,
    Photos.points,
    Photos.userId,
    follows.followedId,
    follows.followerId
};

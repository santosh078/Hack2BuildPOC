using { TestEYShare as my } from '../db/schema';
using { TestEYShare.CDS_Views as CDWallViews } from '../db/CDS_Views/wall_feeds_view';

using TestEYShare from '../db/schema';

@path : 'service/TestEYShare'
service TestEYShareService
{
    // entity feeds as
    //     projection on my.Photos;

    entity Users as
        projection on my.Users;
    entity wall1 as SELECT from my.Photos as photos INNER JOIN my.follows as follows on photos.userId=follows.followedId {
        key newuid() as wallId: String(36),followedId, followerId , mute,photoId,image, mimetype,caption,tags,location,points,comments,likes,photos.createdAt as createdAt
    }; 

}

annotate TestEYShareService with @requires :
[
    'authenticated-user'
];

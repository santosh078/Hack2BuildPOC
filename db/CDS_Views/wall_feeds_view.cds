namespace TestEYShare.CDS_Views;
using {TestEYShare.Photos as photos} from '../schema';
using {TestEYShare.Users as Users} from '../schema';
using {TestEYShare.follows as follows} from '../schema';

entity wall_feeds_view as
   SELECT from photos as photos
//    INNER JOIN follows as follows on (
//    photos.userId=follows.followedId and
//    follows.mute=false and
//    follows.followerId = '1234'
//    ) or  photos.userId = '1234'
//    {
//         key newuid() as wallId:String(36),
//         followedId, 
//         followerId, 
//         mute,
//         photoId,
//         image, 
//         mimetype,
//         caption,
//         tags,
//         location,
//         points,
//         comments,
//         likes,
//         photos.createdAt as createdAt,
//         photos.userId as userId
//         // extend liked_by with Users
//     }
    // where
    //         photos.userId = $user; 
    ;
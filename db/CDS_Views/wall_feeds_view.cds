namespace TestEYShare.CDS_Views;
using {TestEYShare.Photos as photos} from '../schema';
using {TestEYShare.Users as Users} from '../schema';
using {TestEYShare.follows as follows} from '../schema';

entity wall_feeds_view as
   SELECT from photos as P
   INNER join follows as F 
   on (P.userId = F.followedId and 
      F.mute=false and
      F.followedId = '1234') or P.userId = '321'
      {
        P.image,
        P.caption,
        P.tags,
        P.mimetype,
        F.mute
      }
  //  INNER JOIN follows as follows on (
  //  photos.userId=follows.followedId and
  //  follows.mute=false and
  //  follows.followerId = '1234'
  //  ) or  photos.userId = '1234'
  //  {
  //       key newuid() as wallId:String(36),
  //       follows.followedId, 
  //       follows.followerId, 
  //       follows.mute,
  //       follows.photoId,
  //       image, 
  //       mimetype,
  //       caption,
  //       tags,
  //       location,
  //       points,
  //       comments,
  //       likes      
  //   }
  //   where
  //           photos.userId = $user; 
    ;
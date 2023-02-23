namespace TestEYShare.CDS_Views;

using {TestEYShare.Photos as Photos} from '../schema';
using {TestEYShare.likes as likes} from '../schema';

entity user_points_view as
    select from Photos
    inner join likes
        on Photos.userId = likes.userId
    {
        Photos.tags,
        likes.userId,
        likes.createdAt
   };

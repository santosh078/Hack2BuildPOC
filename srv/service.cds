using {TestEYShare as my} from '../db/schema';
using {TestEYShare.CDS_Views as CDWallViews} from '../db/CDS_Views/user_points_view';
using TestEYShare.post.types as post from './types/post';
using TestEYShare from '../db/schema';

@path: 'service/TestEYShare'
service TestEYShareService {
    annotate feeds {
        points
        @Aggregation.default: #sum;
    }

    // annotate feeds with @Aggregation.ApplySupported :
    // {
    //     $Type : 'Aggregation.ApplySupportedType',
    //     AggregatableProperties :
    //     [
    //         {
    //             Property : points
    //         }
    //     ]
    // };

    // @Aggregation.CustomAggregate#points : 'Edm.Int32'
    // entity feeds as projection on my.Photos
    // {
    //     *,
    //     points
    // };
 @cds.redirection.target
    entity Users           as projection on my.Users;

    // {
    //     *
    // }
    // excluding
    // {
    //     password
    // };
    entity Points
    as  projection on my.Points;
    @cds.redirection.target
    entity Photos          as projection on my.Photos;

    entity Comments        as projection on my.Comments;
    entity community       as projection on my.community;
    entity follows         as projection on my.follows;
    entity likes           as projection on my.likes;
    entity Events          as projection on my.Events;
    entity Feeds           as projection on my.wall;
    entity share           as projection on my.share;    
    entity EventAttendance as projection on my.EventAttendance;
    action getFeeds(value : post.fetchFeed) returns String;
    action login(value : post.login)        returns String;
    action getPoints(value : post.login)        returns String;
    action getProfileDetails(value : post.login)        returns String;
}

annotate TestEYShareService with @requires: ['authenticated-user'];

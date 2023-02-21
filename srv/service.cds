using { TestEYShare as my } from '../db/schema';
using { TestEYShare.CDS_Views as CDWallViews } from '../db/CDS_Views/wall_feeds_view';


using TestEYShare from '../db/schema';

@path : 'service/TestEYShare'
service TestEYShareService
{
    annotate feeds
    {
        points
            @Aggregation.default : #sum;
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

    entity Users as projection on my.Users
    {
        *
    }
    excluding
    {
        password
    };
    entity wall
    as select from CDWallViews.wall_feeds_view;
    @cds.redirection.target
    entity Photos as projection on my.Photos;
    action fetchUser
    (
    )
    returns Users;
}

annotate TestEYShareService with @requires :
[
    'authenticated-user'
];

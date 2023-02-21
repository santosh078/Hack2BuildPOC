using { TestEYShare as my } from '../db/schema';

using TestEYShare from '../db/schema';

@path : 'service/TestEYShare'
service TestEYShareService
{
    annotate feeds
    {
        points
            @Aggregation.default : #sum;
    }

    annotate feeds with @Aggregation.ApplySupported : 
    {
        $Type : 'Aggregation.ApplySupportedType',
        AggregatableProperties :
        [
            {
                Property : points
            }
        ]
    };

    @Aggregation.CustomAggregate#points : 'Edm.Int32'
    entity feeds as projection on my.Photos
    {
        *,
        points
    };

    entity Users as projection on my.Users
    {
        *
    }
    excluding
    {
        password
    };

    action fetchUser
    (
    )
    returns Users;
}

annotate TestEYShareService with @requires :
[
    'authenticated-user'
];

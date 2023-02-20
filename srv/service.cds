using { TestEYShare as my } from '../db/schema';

using TestEYShare from '../db/schema';

@path : 'service/TestEYShare'
service TestEYShareService
{
    entity feeds as
        projection on my.Photos;
}

annotate TestEYShareService with @requires :
[
    'authenticated-user'
];

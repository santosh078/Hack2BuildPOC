const cds = require('@sap/cds')
const { Users, wall, Events, Points ,Profile,follows} = cds.entities('TestEYShare')

module.exports = class Authentication {
    /**
   * checkLogin() This middleware function verify the user is authenticate person or not for given operation.
    * @param {req} req
   * @param {res} returns 
   */
    async checkLogin(req, res) {

        return new Promise(async (reslove, reject) => {
            try {
                console.log(`req.body.email${JSON.stringify(req.body)}`);
                let emailId = req.body.email;
                // let userRecord= await SELECT `*` .from (Users,emailId);
                let userRecord = await SELECT.from(Users).where({ email: emailId });
                console.log(`fetched from table userid ${JSON.stringify(userRecord)}`);
                if (userRecord[0]) {
                    if (userRecord[0].password.trim() != req.body.password.trim()) {
                        // console.log(`inside fwaile`);
                        reslove("Invalid credentials");
                    } else {
                        // console.log(`inside resolve`);
                        reslove(userRecord[0]);
                    }

                }else{
                    if(userRecord.length ==0){
                        reslove(null);
                    }
                   
                }


            } catch (err) {
                reject(err);
            }
        })
    }
    async getWall(req, res) {

        return new Promise(async (reslove, reject) => {
            try {
                console.log(`req.body.email${JSON.stringify(req.body)}`);
                let emailId = req.body.email;
                // let userRecord= await SELECT `*` .from (Users,emailId);
                // console.log(SELECT .from(wall).where({followerId:emailId}));
                let photoRecord = await SELECT.from(wall).where({ followerId: emailId });
                let allEvnts = await SELECT.from(Events);
                //logic to create Feed page
                let oneEvntObj = {}, onePhotoRecord = {};
                if (allEvnts && allEvnts[0]) {
                    oneEvntObj = allEvnts[0];
                }
                if (photoRecord && photoRecord[0]) {
                    onePhotoRecord = photoRecord[0];
                }
                photoRecord.forEach((obj) => {
                    
                    const aKeys = Object.keys(oneEvntObj);
                    for (var i in aKeys) {
                        if (!obj[aKeys[i]] && aKeys[i] != "taggedUsers") {
                            obj.isEvent = false;
                            obj[aKeys[i]] = "";
                        }
                    }
                });
                allEvnts.forEach((obj) => {
                    const aKeys = Object.keys(onePhotoRecord);
                    for (var i in aKeys) {
                        if (!obj[aKeys[i]] && aKeys[i] != "tags") {
                            obj.isEvent = true;
                            obj[aKeys[i]] = "";
                        }
                    }
                });
                const all = [...photoRecord, ...allEvnts];
                console.log(`allEvnts from table userid ${JSON.stringify(allEvnts)}`);
                // let userRecord = await SELECT.from(Users).where({email:photoRecord.userId});
                console.log(`photoRecord from table userid ${JSON.stringify(photoRecord)}`);
                reslove({ all });

            } catch (err) {
                reject(err);
            }
        })
    }
    async getPoints(req, res) {
        return new Promise(async (reslove, reject) => {
            try {
                console.log(`req.body.email${JSON.stringify(req.body)}`);
                let emailId = req.body.email;
                // let userRecord= await SELECT `*` .from (Users,emailId);
                let likeRecord = await SELECT.from(Points).where({ postedUser: emailId });
                console.log(`fetched from table likeRecord ${JSON.stringify(likeRecord)}`);
                var rewardTags = ["plant", "charity", "donate"];
                let giveReward = false,totalPoint=0;
                likeRecord.forEach((obj) => {
                    giveReward = false;
                    obj.points=0;
                    for (var i in obj.tags) {
                        for (var j in rewardTags) {
                            if (obj.tags[i].toLowerCase().indexOf(rewardTags[j].toLowerCase())) {
                                giveReward = true;
                                break;
                            }
                        }
                    }
                    if(giveReward){
                        obj.points++;
                       totalPoint++
                    }
                });
                
                reslove({ result:likeRecord,totalPoint:totalPoint });

            } catch (err) {
                reject(err);
            }
        })
    }
    async getProfileDetails(req, res) {
        return new Promise(async (reslove, reject) => {
            try {
                console.log(`req.body.email${JSON.stringify(req.body)}`);
                let emailId = req.body.email;
                // let userRecord= await SELECT `*` .from (Users,emailId);
                let userRecord = await SELECT.from(Profile).where({ userId: emailId });
                console.log(`fetched from table likeRecord ${JSON.stringify(userRecord)}`);
                let allEvnts = await SELECT.from(Events).where({userId:emailId});
                // let followr = await SELECT.from(follows).where({followedId:emailId}).columns({count(followedId)});
                let followr=await SELECT `from ${follows} {
                    count(followedId)
                 } where followedId = ${emailId} 
            `
                console.log(`count is---- ${followr}`);
                //logic to create Feed page
                let oneEvntObj = {}, onePhotoRecord = {};
                if (allEvnts && allEvnts[0]) {
                    oneEvntObj = allEvnts[0];
                }
                if (userRecord && userRecord[0]) {
                    onePhotoRecord = userRecord[0];
                }
                userRecord.forEach((obj) => {
                    obj.isEvent = false;
                    const aKeys = Object.keys(oneEvntObj);
                    for (var i in aKeys) {
                        if (!obj[aKeys[i]] && aKeys[i] != "taggedUsers") {
                           
                            obj[aKeys[i]] = "";
                        }
                    }
                });
                allEvnts.forEach((obj) => {
                    obj.isEvent = true;
                    const aKeys = Object.keys(onePhotoRecord);
                    for (var i in aKeys) {
                        if (!obj[aKeys[i]] && aKeys[i] != "tags") {
                           
                            obj[aKeys[i]] = "";
                        }
                    }
                });
                const all = [...userRecord, ...allEvnts];
                
                reslove({ result:all });

            } catch (err) {
                reject(err);
            }
        })
    }

    
};
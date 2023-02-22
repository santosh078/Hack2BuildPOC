/**
 * Code is auto-generated by Application Logic, DO NOT EDIT.
 */
const LCAPApplicationService = require('@sap/low-code-event-handler');
const feeds_Logic = require('./code/feeds-logic');
const fetchuser_Logic = require('./code/fetchuser-logic');
const authenticationContlr = require('./controller/authentication');
const wallCtrl = require('./controller/wallController');
const cds = require("@sap/cds");

class TestEYShareService extends LCAPApplicationService {
    async init() {
        this.before('*', async req => {
           req.db= cds.connect.to ('sqlite:hack2build.db');
              req.express = req._;
            req.path = req._.req.path;
            req.originalUrl = req._.req.originalUrl;
            req.body = req.data.value;
            req.authInfo = req._.req.authInfo;          
        });
        
        this.on('fetchUser', async (request, next) => {
            
            await fetchuser_Logic({
                request
            });
            return next();
        });

        this.after('POST', 'Photos', data => {
            // console.log(`inside after post ${JSON.stringify(data)}`);
        })
        this.on('login', async (req, res, next) => {
            let authenticationCtr = new authenticationContlr();
            let userRecord = await authenticationCtr.checkLogin(req, res);
            let resStatusCode=200;
            console.log(`user record in service js ${JSON.stringify(userRecord)}`);
             if(!userRecord){   
                // res.send("Invalid credentials.Try again");
                resStatusCode=404;
                return "No record found with this email id.";
            }else{
                resStatusCode=200;
                delete userRecord.password;
                return userRecord;
            }
            // req.express.res.status(resStatusCode).json({
            //      result: userRecord
            // });
           
           
        })
        this.on('getFeeds', async (req, res, next)=> {
            let authenticationCtr = new authenticationContlr();
            let userRecord = await authenticationCtr.getWall(req, res);
            })
        return super.init();
    }
}


module.exports = {
    TestEYShareService
};
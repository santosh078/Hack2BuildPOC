/**
 * Code is auto-generated by Application Logic, DO NOT EDIT.
 */
const LCAPApplicationService = require('@sap/low-code-event-handler');
const feeds_Logic = require('./code/feeds-logic');
const fetchuser_Logic = require('./code/fetchuser-logic');
const authenticationContlr = require('./controller/authentication');
const cds = require("@sap/cds");

class TestEYShareService extends LCAPApplicationService {
    async init() {
        this.before('*', async req => {
            cds.connect.to ('sqlite:hack2build.db');
              req.express = req._;
            req.path = req._.req.path;
            req.originalUrl = req._.req.originalUrl;
            req.body = req.data.value;
            req.authInfo = req._.req.authInfo;          
        });
        this.on('READ', 'feeds', async (request, next) => {
            await feeds_Logic({
                request
            });
            return next();
        });
        var i = 0;
        this.after('READ', 'wall', each => {
            console.log(`${JSON.stringify(each)}`);
        })
        this.on('fetchUser', async (request, next) => {
            await fetchuser_Logic({
                request
            });
            return next();
        });

        this.after('POST', 'Photos', data => {
            console.log(`inside after post ${JSON.stringify(data)}`);
        })
        this.on('CurrentUser', req => {
            console.log(`user  ${JSON.stringify(req._.req)} `);
            let oResp = {
                id: req.user.id,
                firstName: req.req.authInfo.getGivenName(),
                lastName: req.req.authInfo.getFamilyName(),
                email: req.req.authInfo.getEmail()
            }
            console.log(`response ${JSON.stringify(oResp)} `);
            return oResp;
        })
        this.on('login', async (req, res, next) => {
            let authenticationCtr = new authenticationContlr();
            let checkLogin = await authenticationCtr.checkLogin(req, res);
            console.log(`user  ${JSON.stringify(req.body)} `);
            let oResp = {
                
            }
            console.log(`response ${JSON.stringify(oResp)} `);
            return oResp;
        })
        return super.init();
    }
}


module.exports = {
    TestEYShareService
};
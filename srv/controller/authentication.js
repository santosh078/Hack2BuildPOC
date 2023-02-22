const cds = require('@sap/cds')
const { Users } = cds.entities ('TestEYShare')

module.exports = class CaseManager {
     /**
    * checkLogin() This middleware function verify the user is authenticate person or not for given operation.
     * @param {req} req
    * @param {res} returns 
    */
      async checkLogin(req, res) {
        try {
            console.log(`req.body.email${JSON.stringify(req.body)}`)
            let emailId=req.body.email;
            let b = await SELECT `*` .from (Users,emailId);
            console.log(`fetched from table userid ${JSON.stringify(b)}`)
        } catch (err) {
            
        }
    }
};
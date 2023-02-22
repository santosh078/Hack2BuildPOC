const cds = require('@sap/cds')
const { Users,wall } = cds.entities ('TestEYShare')

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
                let emailId=req.body.email;
                // let userRecord= await SELECT `*` .from (Users,emailId);
                let userRecord=await SELECT.from(wall);
                console.log (`fetched from table userid ${JSON.stringify(userRecord)}`);
               if(userRecord[0]){
                if(userRecord[0].password.trim() != req.body.password.trim()){
                    console.log (`inside fwaile`);
                    reslove("Invalid credentials");
                }else{
                    console.log (`inside resolve`);
                    reslove(userRecord[0]);
                }
                
               }
               
              
            } catch (err) {
                reject(err);
            }
        })
    }
};
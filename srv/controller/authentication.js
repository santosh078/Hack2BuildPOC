module.exports = class CaseManager {
     /**
    * checkLogin() This middleware function verify the user is authenticate person or not for given operation.
     * @param {req} req
    * @param {res} returns 
    */
      async checkLogin(req, res) {
        try {
            if (req.express.req.path.indexOf('assignToMe') != -1) {
                let delLockQuery = caseQuery.lockDeleteQuery(req.argmts.Case_Id || req.argmts.Case_Ref);
                await dbObj.execQuery(req.db, delLockQuery);
                return;
            }

            let lockfetchQuery = caseQuery.lockSelectQuery(req.argmts.Case_Id || req.argmts.Case_Ref);
            let lockResp = await dbObj.execQuery(req.db, lockfetchQuery);
            if (lo.isEmpty(lockResp) || req.express.req.path.indexOf('mirror') != -1) {
                if (req.method.toUpperCase() == 'POST') {
                    let application_ID = await commonHandler.getApplicationId(req);
                    let lockInsertQuery = {
                        EMPLOYEE_ID: req.user.id,
                        CASE_DATA_ID: req.argmts.Case_Id || req.argmts.Case_Ref,
                        APPLICATION_ID: application_ID
                    };
                    if (req.express.req.path.indexOf('mirror') != -1) {
                        let delLockQuery = caseQuery.lockDeleteQuery(req.argmts.Case_Id || req.argmts.Case_Ref);
                        await dbObj.execQuery(req.db, delLockQuery);
                        lockInsertQuery.EMPLOYEE_ID = req.user.id;
                    }
                    let lockQuery = await insertQueryForLock(req, lockInsertQuery);
                    await dbObj.execQuery(req.db, lockQuery[0], lockQuery[1]);
                    req.caseIDCheck = true;
                    return;
                } else {
                    let delLockQuery = caseQuery.lockDeleteQuery(req.argmts.Case_Id || req.argmts.Case_Ref);
                    await dbObj.execQuery(req.db, delLockQuery);
                    return;
                }
            };

            if (lockResp.length != 0) {
                for (let i = 0; i <= lockResp.length - 1; i++) {
                    let createdOn = new Date(lockResp[i]['CREATED_ON']);
                    let currentDt = new Date();
                    let diffMinutes = Math.floor((currentDt - createdOn) / 60000);
                    if (diffMinutes <= 15) {
                        let formatedDate = formattedDate(currentDt);
                        if (lockResp[i]['EMPLOYEE_ID'] == req.user.id) {
                            let updateLockQuery = caseQuery.updateCreatedOn(formatedDate, lockResp[i]['ID']);
                            await dbObj.execQuery(req.db, updateLockQuery);
                        }
                    } else {
                        let delLockQuery = caseQuery.lockDeleteQueryWhenGreaterFifteenMins(lockResp[i]['ID']);
                        await dbObj.execQuery(req.db, delLockQuery);
                    }
                }
                let lockfetchQueryAfterValidate = caseQuery.lockSelectQuery(req.argmts.Case_Id || req.argmts.Case_Ref);
                let lockRespAfterValidate = await dbObj.execQuery(req.db, lockfetchQueryAfterValidate);
                if (lockRespAfterValidate.length > 0) {
                    let { EMPLOYEE_ID, APPLICATION_ID } = lockRespAfterValidate[0];
                    if (EMPLOYEE_ID == req.user.id) {
                        req.caseIDCheck = true;
                        return;
                    } else if (EMPLOYEE_ID !== req.user.id && APPLICATION_ID === 4) {
                        return res.status(403).send({
                            hasValidLock: true,
                            message: caseQuery.getSuccessMsg('caseLockByCWUser', req)
                        });
                    } else {
                        return req.express.res.status(403).send({
                            hasValidLock: true,
                            message: caseQuery.getSuccessMsg('caseLockByAnother', req) + EMPLOYEE_ID
                        });
                    }
                } else {
                    let application_ID = await commonHandler.getApplicationId(req)
                    let logInsertData = {
                        EMPLOYEE_ID: req.user.id,
                        CASE_DATA_ID: req.argmts.Case_Id || req.argmts.Case_Ref,
                        APPLICATION_ID: application_ID
                    }
                    let lockInsertQuery = await insertQueryForLock(req, logInsertData);
                    await dbObj.execTransationQuery(req.db, [
                        lockInsertQuery
                    ]);
                    if (req.dontSendResp) {
                        return;
                    } else {
                        return req.express.res.status(200).send({
                            hasValidLock: false,
                            message: caseQuery.getSuccessMsg('caselockedOnYourUser', req)
                        });
                    }
                }
            } else {
                req.caseIDCheck = false;
            }
            return;
        } catch (err) {
            error.handleError(err, res, req, "ErrCurrentLockUser");
            // we have to return true to prevent further execution
            // because response is already sent in handleError.
            return true;
        }
    }
};
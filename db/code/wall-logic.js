const { APPGYVERFUNCTIONS } = require('@sap/low-code-event-handler/functions');

/**
 * @param {Object} context - The root parameter for each application logic
 * @param {Object} context.request - User information, tenant-specific CDS model, headers and query parameters
 * populate wall related data
 * @Before(event = { "READ" }, entity = "TestEYShare.wall")
 * @param {Object} [context.results] - For the After phase only: the result of the event processing
 */
module.exports = async function(context) {
    // Your code here
};

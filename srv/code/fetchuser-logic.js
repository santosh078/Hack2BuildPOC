const { APPGYVERFUNCTIONS } = require('@sap/low-code-event-handler/functions');

/**
 * @param {Object} context - The root parameter for each application logic
 * @param {Object} context.request - User information, tenant-specific CDS model, headers and query parameters
 * 
 * @On(event = { "fetchUser" })
 * @param {Object} [context.results] - For the After phase only: the result of the event processing
 */
module.exports = async function(context) {
	let data = null;
	data = context.request.data;
	await SELECT .from `TestEYShareService.Users` .columns `userId,name,createdAt,handle,profileImage`;
};

const aws = require('aws-sdk');

const cognitoIdentityServiceProvider = new aws.CognitoIdentityServiceProvider({
  apiVersion: '2016-04-18',
});

/**
 * @type {import('@types/aws-lambda').PostConfirmationTriggerHandler}
 */
exports.handler = async (event) => {

  const tenantID = event.request.userAttributes.email;

  console.log(`tenantID: ${tenantID}`)

//  tenantID get from register event

  console.log(`EVENT: ${JSON.stringify(event)}`);

  console.log(`PROCESS ENV GROUP: ${process.env.GROUP}`);

  const groupParams = {
    GroupName: tenantID,
//    GroupName: process.env.GROUP,
    UserPoolId: event.userPoolId,
  };
  const addUserParams = {
    GroupName: tenantID,
//    GroupName: process.env.GROUP,
    UserPoolId: event.userPoolId,
    Username: event.userName,
  };
  /**
   * Check if the group exists; if it doesn't, create it.
   */
  try {
    await cognitoIdentityServiceProvider.getGroup(groupParams).promise();
  } catch (e) {
    await cognitoIdentityServiceProvider.createGroup(groupParams).promise();
  }
  /**
   * Then, add the user to the group.
   */
  await cognitoIdentityServiceProvider.adminAddUserToGroup(addUserParams).promise();

  var listGroupsParams = {
     UserPoolId: "us-east-1_ExgE92IDc"
  };

  await cognitoIdentityServiceProvider.listGroups(listGroupsParams, function(err, data) {
     if (err) console.log(err, err.stack); // an error occurred
     else     console.log(data);           // successful response
  });

  return event;
};

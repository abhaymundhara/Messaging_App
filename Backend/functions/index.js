/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

require("dotenv").config();
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { StreamChat } = require("stream-chat");
admin.initializeApp();
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

async function getChannelMembers(channelId, message, senderName) {
    const channelSnapshot = await admin
    .database()
    .ref("/channels/" + channelId)
    .once("value")

    const channelDict = channelSnapshot.val()
    const membersUids = channelDict["membersUids"]


}


const apiKey = process.env.APIKEY;
const apiSecret = process.env.API_SECRET;

const streamClient = StreamChat.getInstance(apiKey, apiSecret);

exports.createStreamUser = functions.auth.user().onCreate(async(user) => {
    logger.log("firebase user created");

    const response = await streamClient.upsertUser({
        id: user.uid,
        name: user.displayName,
        email: user.email,
        image: user.photoURL
    }) 
    logger.log("Stream user created", response);

    return response;
});

exports.deleteStreamUser = functions.auth.user().onDelete(async(user) => {
    logger.log("firebase user deleted", user);

    const response = await streamClient.deleteUser(user.uid); 
    logger.log("Stream user deleted", response);

    return response;
});

exports.getStreamUserToken = functions.https.onCall((data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError(
            "failed-precondition",
            "The function must be called while authenticated"
        );
    } else {
        try {
            return streamClient.createToken(
                context.auth.uid,
                undefined,
                Math.floor(new Date().getTime() / 1000)
            );
        } catch (err) {
            console.error(
                `Unable to get user token with ID ${context.auth.uid} on Stream. Error ${err}`
            );
            throw new functions.https.HttpsError(
                "aborted",
                "Cannot get stream user"
            );
        }
    }
});

exports.revokeStreamUserToken = functions.https.onCall((data, context) => {
    if(!context.auth){
        throw new functions.https.HttpsError(
            "failed precondition",
            "The func must be called while authenticated"
        )
    } else {
        try {
            return streamClient.revokeUsersToken(context.auth.uid);
        } catch (err) {
            console.error(`Unable to revoke user token with ID ${context.auth.uid} on Stream. Error ${err}`)
            throw new functions.https.HttpsError(
            "aborted",
            "Cannot get stream user"
        );
    }
}
});
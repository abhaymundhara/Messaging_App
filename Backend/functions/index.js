/**
 * Firebase Cloud Functions for WhatsApp Clone
 */

require("dotenv").config();
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { StreamChat } = require("stream-chat");
admin.initializeApp();
const logger = require("firebase-functions/logger");

const apiKey = process.env.APIKEY;
const apiSecret = process.env.API_SECRET;

if (!apiKey || !apiSecret) {
    throw new Error("Stream API key and secret must be set in environment variables (APIKEY, API_SECRET).");
}

const streamClient = StreamChat.getInstance(apiKey, apiSecret);

// Fixed: now actually returns the membersUids
async function getChannelMembers(channelId) {
    const channelSnapshot = await admin
        .database()
        .ref("/channels/" + channelId)
        .once("value");
    const channelDict = channelSnapshot.val();
    return channelDict ? channelDict["membersUids"] : [];
}

exports.createStreamUser = functions.auth.user().onCreate(async (user) => {
    logger.log("firebase user created");
    const response = await streamClient.upsertUser({
        id: user.uid,
        name: user.displayName,
        email: user.email,
        image: user.photoURL
    });
    logger.log("Stream user created", response);
    return response;
});

exports.deleteStreamUser = functions.auth.user().onDelete(async (user) => {
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

// Fixed: brace mismatch + wrong error code "failed precondition" -> "failed-precondition"
exports.revokeStreamUserToken = functions.https.onCall((data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError(
            "failed-precondition",
            "The function must be called while authenticated"
        );
    } else {
        try {
            return streamClient.revokeUsersToken(context.auth.uid);
        } catch (err) {
            console.error(`Unable to revoke user token with ID ${context.auth.uid} on Stream. Error ${err}`);
            throw new functions.https.HttpsError(
                "aborted",
                "Cannot revoke stream user token"
            );
        }
    }
});

const functions = require('firebase-functions');
// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.timetableUpdate = functions.firestore.document('/userTimetables/{documentId}')
    .onUpdate(async (snap, context) => {
        const userUid = context.params.documentId;
        const token = [];
        const doc = await admin.firestore()
            .collection('userNotificationTokens')
            .doc(String(userUid))
            .get()
        const data = doc.data()
        token.push(data.token);
        const payload = {
            notification: {
                title: 'Timetable Update',
                body: 'You have updated your timetable!'
            }
        }
        const response = await admin.messaging().sendToDevice(token, payload)
        // eslint-disable-next-line promise/always-return
        .then((res) =>
        { 
            console.log("Message sent successfully!" ,res.body) 
           // return "Message sent successfully! Is this an error?" + res;
        })
        .catch((error) => {
            console.log("Message failed!", error)
        }); 
        return null;
    });
exports.chatUpdate = functions.firestore.document('ChatRoom/{user1user2}/chats/{id}')
    .onWrite(async (snap,context) => {
        const data = snap.after.data()
        const sender = await data.sendBy
        const message = await data.message
        const ss = await admin.firestore()
        .collection('users')
        .where('name', '==', sender)
        .get()
        const uid = ss.docs[0].id;
        const doc = await admin.firestore()
        .collection('userNotificationTokens')
        .doc(uid)
        .get()
        const token = doc.data().token
        const payload = {
            notification: {
                title: sender,
                body: message
            }
        }
        // eslint-disable-next-line promise/always-return
        const response = await admin.messaging().sendToDevice(token, payload).then((res) => {
            console.log("Message sent successfully!", res.body) 
        });
        return null;
    })

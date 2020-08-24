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
        const chatroom = context.params.user1user2
        const data = snap.after.data()
        const sender = await data.sendBy
        const message = await data.message
        var users = await admin.firestore().collection('ChatRoom').doc(chatroom).get()
        users = users.data().users
        var name = '';
        if (users[0] === sender) {
            name = users[1];
            console.log(name);
        } else {
            name = users[0];
            console.log(name);
        }
        const ss = await admin.firestore()
        .collection('users')
        .where('name', '==', name)
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
exports.meetingsUpdate = functions.firestore.document('/meetings/{meetingsId}')
    .onCreate(async (snap,context) => {
        var data = snap.data()
        //var data = snap.after.data()
        data = await data.meeting;
        const obj = await data.meeting;
        const uids = await obj.groupUID;
        const slots = await obj.slot;
        console.log(uids[0]);
        var uid1 = uids[0];
        //var uid2 = uids[1];
        const requestor = await obj.requesterName;
        const start = slots.start < 10 ? '0' + slots.start + '00' : slots.start + '00'
        const end = slots.end < 10 ? '0' + slots.end + '00' : slots.end + '00'
        const payload = {
            notification: {
                title: 'Meeting request',
                body: 'You have a meeting request from ' + requestor + ' between ' + start + ' - ' + end
            }
        }
        const promises = []
        const send = async (val) => {
            var doc = await admin.firestore()
                    .collection('userNotificationTokens')
                    .doc(val)
                    .get()
                var token = doc.data().token
                const response = await admin.messaging()
                .sendToDevice(token, payload)
        }
        if (uids.length > 1) {
            for (id in uids) {
                console.log(uids[id])
                promises.push(send(uids[id]))
            }
            const responses = await Promise.all(promises)
            // uids.map((id, index) => {
            //     console.log(id)
            //     var doc = admin.firestore()
            //         .collection('userNotificationTokens')
            //         .doc(id)
            //         .get()
            //     var token = doc.data().token
            //     const response = await admin.messaging()
            //     .sendToDevice(token, payload)
            // })
            return null
        } else {
        var doc = await admin.firestore()
        .collection('userNotificationTokens')
        .doc(uid1)
        .get()
        var token = doc.data().token
        const response = await admin.messaging()
        .sendToDevice(token, payload)
        return null;
        }

    })

exports.meetingsOutcome = functions.firestore.document('/meetings/{meetingsId}')
.onUpdate(async (snap, context) => {
    var data = snap.after.data();
    data = await data.meeting
    var decision = await data.isAccepted;
    data = await data.meeting
    const userUid = await data.userUID
    const mates = await data.groupUID
    const slots = await data.slot;
    const memberName = await data.memberNames
    //const name = memberName[0]
    const start = slots.start < 10 ? '0' + slots.start + '00' : slots.start + '00'
    const end = slots.end < 10 ? '0' + slots.end + '00' : slots.end + '00'
    const payload = {
        notification: {
            title: 'Meeting with ' + memberName + ' between ' + start + ' - ' + end,
            body: decision ? 'Approved' : 'Rejected' 
        }
    }
    if (mates.length > 1 && decision === null) {
        return null
    }
    if (decision === true || mates.length === 1) {
        if (decision === null) {
            decision = false
        }
        const token = await admin.firestore()
        .collection('userNotificationTokens')
        .doc(userUid)
        .get().then(value => value.data().token)
        await admin.messaging().sendToDevice(token, payload);
        return null
    }
    // if (decision) {
    //     await admin.messaging().sendToDevice(token, payload);
    // } else {
    //     decision = "rejected!"
    //     await admin.messaging().sendToDevice(token, payload);
    // }
    return null;

})

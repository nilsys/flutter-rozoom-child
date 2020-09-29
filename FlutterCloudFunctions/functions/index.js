const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore.document('confs/{confId}').onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic('conf', 
{   notification: {
        title: snapshot.data().roomName,
        body: 'Пользователь ' + snapshot.data().username + ' создал новую конференцию!',
        },
    data:    
      {
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        data: snapshot.data().roomName,
        },
    });
});

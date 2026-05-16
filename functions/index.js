const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendOrderNotification = onDocumentCreated(
    "pickups/{pickupId}",
    async (event) => {
      try {
        const agentsSnapshot =
            await admin
                .firestore()
                .collection("agents")
                .where(
                    "isOnline",
                    "==",
                    true,
                )
                .get();

        const tokens = [];

        agentsSnapshot.forEach((doc) => {
          const token = doc.data().fcmToken;

          if (token) {
            tokens.push(token);
          }
        });

        if (tokens.length === 0) {
          console.log("No FCM tokens found");
          return;
        }

        const message = {
          notification: {
            title: "New Pickup Order",
            body: "A customer placed a new waste pickup request.",
          },

          tokens: tokens,
        };

        const response = await admin
            .messaging()
            .sendEachForMulticast(message);

        console.log(
            "Notifications sent successfully",
            response,
        );
      } catch (error) {
        console.error(
            "Error sending notification:",
            error,
        );
      }
    },
);

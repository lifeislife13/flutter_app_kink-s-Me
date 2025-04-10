import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import nodemailer from "nodemailer";

admin.initializeApp();

// 💌 Config Gmail
const gmailEmail = "contactkinksme@gmail.com";
const gmailPassword = "thmq jtee icbe flzj";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

// 🔔 Envoi des emails de rappel premium
async function sendReminderEmails(): Promise<number> {
  const snapshot = await admin.firestore().collection("users").get();
  const now = new Date();
  const jMoins1 = new Date(now);
  jMoins1.setDate(jMoins1.getDate() + 1);

  let count = 0;

  for (const doc of snapshot.docs) {
    const user = doc.data();
    const email = user.email;
    const premiumUntil = user.premiumUntil?.toDate?.();

    if (!email || !premiumUntil) continue;

    const isMatch =
      premiumUntil.getDate() === jMoins1.getDate() &&
      premiumUntil.getMonth() === jMoins1.getMonth() &&
      premiumUntil.getFullYear() === jMoins1.getFullYear();

    if (isMatch) {
      const mailOptions = {
        from: `Kink's Me 🔥 <${gmailEmail}>`,
        to: email,
        subject: "🔥 Votre accès Premium expire bientôt",
        html: `
          <p>Bonjour,</p>
          <p>Votre accès Premium expire dans moins de 24h.</p>
          <p><a href="https://kinksme.app/boutique">Renouvelez ici</a>.</p>
        `,
      };

      try {
        await transporter.sendMail(mailOptions);
        count++;
        console.log(`📧 Email envoyé à ${email}`);
      } catch (err) {
        console.error(`❌ Erreur d'envoi à ${email}`, err);
      }
    }
  }

  return count;
}

// ✅ 1. Fonction manuelle
export const sendPremiumReminderNow = functions.https.onRequest(async (_req, res) => {
  const count = await sendReminderEmails();
  res.status(200).send(`
    <h2 style="color:green;">📬 ${count} email(s) envoyés</h2>
    <p>Vérifie ta boîte mail pour confirmation</p>
  `);
});

// ✅ 2. Fonction planifiée (tous les jours à 10h FR)
export const sendPremiumReminder = functions.pubsub
  .schedule("every day 08:00")
  .timeZone("Europe/Paris")
  .onRun(async () => {
    const count = await sendReminderEmails();
    console.log(`⏰ Envoi planifié terminé : ${count} email(s) envoyés`);
  });

// ✅ 3. 🔔 Notification FCM : nouvel élément dans Firestore
export const notifyOnNewMessage = functions.firestore
  .document("messages/{messageId}") // ← adapte ici si ta collection est nommée autrement
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const content = data?.text || "📨 Nouveau message reçu";

    const payload: admin.messaging.Message = {
      notification: {
        title: "💬 Nouveau message dans Kink's Me",
        body: content,
      },
      topic: "allUsers",
    };

    try {
      await admin.messaging().send(payload);
      console.log("✅ Notification envoyée à tous via FCM.");
    } catch (err) {
      console.error("❌ Erreur d’envoi de la notif :", err);
    }
  });

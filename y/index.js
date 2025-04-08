const functions = require("firebase-functions");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const gmailEmail = "contactkinksme@gmail.com";
const gmailPassword = "qnyt lehx shwm npfc"; // mot de passe d'application Gmail

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

async function sendEmailsToExpiringUsers() {
  const snapshot = await admin.firestore().collection("users").get();
  const now = new Date();
  const jMoins1 = new Date(now);
  jMoins1.setDate(jMoins1.getDate() + 1);

  let sent = 0;

  for (const doc of snapshot.docs) {
    const user = doc.data();
    const email = user.email;
    const premiumUntil = user.premiumUntil?.toDate?.();

    if (!email || !premiumUntil) continue;

    const sameDay =
      premiumUntil.getDate() === jMoins1.getDate() &&
      premiumUntil.getMonth() === jMoins1.getMonth() &&
      premiumUntil.getFullYear() === jMoins1.getFullYear();

    if (sameDay) {
      const mailOptions = {
        from: `Kink's Me 🔥 <${gmailEmail}>`,
        to: email,
        subject: "🔥 Votre accès Premium arrive à expiration",
        html: `
          <p>Bonjour,</p>
          <p>Nous espérons que vous avez pleinement profité de votre Écrin Premium ! 💎</p>
          <p><strong>Il reste moins de 24h</strong> avant la fin de votre accès privilégié à la Plume Secrète, à la Kinksphère et à toutes nos fonctionnalités avancées.</p>
          <p>Envie de rester dans la confidence ? <a href="https://kinksme.app/boutique">Renouvelez votre abonnement</a> dès maintenant.</p>
          <p>Avec douceur et élégance,</p>
          <p>L’équipe de Kink’s Me</p>
        `,
      };

      try {
        await transporter.sendMail(mailOptions);
        await admin.firestore()
  .collection('users')
  .doc(doc.id)
  .collection('mailLogs')
  .add({
    type: 'premiumReminder',
    sentAt: admin.firestore.FieldValue.serverTimestamp(),
    email,
  });

        sent++;
        console.log("📧 Email envoyé à", email);
      } catch (err) {
        console.error("❌ Erreur en envoyant à", email, err);
      }
    }
  }

  return sent;
}

// ✅ Fonction planifiée (automatique)
exports.sendPremiumReminder = onSchedule("every day 08:00", async (event) => {
  const sentCount = await sendEmailsToExpiringUsers();
  console.log(`✅ ${sentCount} email(s) envoyé(s) automatiquement.`);
});

// ✅ Fonction manuelle via navigateur
exports.sendPremiumReminderNow = functions.https.onRequest(async (req, res) => {
  const sentCount = await sendEmailsToExpiringUsers();
  res.status(200).send(`
    <h2 style="color: darkred;">✨ Envoi test effectué</h2>
    <p>${sentCount} email(s) ont été envoyés avec succès.</p>
    <p>💌 Tu peux vérifier ta boîte mail maintenant !</p>
  `);
});

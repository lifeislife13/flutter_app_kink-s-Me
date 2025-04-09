import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";

admin.initializeApp();

const gmailEmail = "contactkinksme@gmail.com";
const gmailPassword = "TON_MDP_APP_GMAIL"; // mot de passe d’application sécurisé

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

export const sendPremiumReminderNow = functions.https.onRequest(async (_req, res) => {
  const snapshot = await admin.firestore().collection("users").get();
  const now = new Date();
  const jMoins1 = new Date(now);
  jMoins1.setDate(jMoins1.getDate() + 1);

  let count = 0;

  for (const doc of snapshot.docs) {
    const user = doc.data();
    const email = user.email;
    const premiumUntil = user.premiumUntil ? user.premiumUntil.toDate() : null;


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
        console.log(`✅ Email envoyé à ${email}`);
      } catch (error) {
        console.error(`❌ Erreur en envoyant à ${email}:`, error);
      }
    }
  }

  res.status(200).send(`${count} email(s) envoyés.`);
});

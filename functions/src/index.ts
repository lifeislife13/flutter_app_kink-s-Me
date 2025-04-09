import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import nodemailer from "nodemailer";

admin.initializeApp();

// 💌 Adresse et mot de passe d'application Gmail
const gmailEmail = "contactkinksme@gmail.com";
const gmailPassword = "thmq jtee icbe flzj"; // ← mets ici ton mot de passe d'application mis à jour

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

async function sendReminderEmails(): Promise<number> {
  const snapshot = await admin.firestore().collection("users").get();
  const now = new Date();
  const jMoins1 = new Date(now);
  jMoins1.setDate(jMoins1.getDate() + 1); // 🔔 On cible les abonnements qui expirent dans 24h

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

// ✅ 1. Fonction manuelle (test dans le navigateur)
export const sendPremiumReminderNow = functions.https.onRequest(async (_req, res) => {
  const count = await sendReminderEmails();
  res.status(200).send(`
    <h2 style="color:green;">📬 ${count} email(s) envoyés</h2>
    <p>Vérifie ta boîte mail pour confirmation</p>
  `);
});

// ✅ 2. Fonction planifiée (automatique chaque jour à 8h UTC → 10h FR)
export const sendPremiumReminder = functions.pubsub.schedule("every day 08:00").timeZone("Europe/Paris").onRun(async () => {
  const count = await sendReminderEmails();
  console.log(`⏰ Envoi planifié terminé : ${count} email(s) envoyés`);
});

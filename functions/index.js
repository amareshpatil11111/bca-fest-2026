/**
 * BCA Fest 2026 - Firebase Cloud Functions
 * 
 * This file contains Cloud Functions that trigger on Firestore events.
 * 
 * SETUP INSTRUCTIONS:
 * 1. Install dependencies: cd functions && npm install
 * 2. Configure email secrets (see below).
 * 3. Deploy: firebase deploy --only functions
 * 
 * EMAIL CONFIGURATION:
 * Run these commands to store credentials as Firebase Secrets:
 *   firebase functions:secrets:set GMAIL_USER
 *   firebase functions:secrets:set GMAIL_PASS
 *
 * Use an App Password (not your main password) if using Gmail:
 * https://myaccount.google.com/apppasswords
 */

const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

// Secrets (stored securely in Google Cloud Secret Manager)
const GMAIL_USER = defineSecret("GMAIL_USER");
const GMAIL_PASS = defineSecret("GMAIL_PASS");

/**
 * sendRegistrationEmail
 * 
 * Triggered when a new document is created in the "registrations" Firestore collection.
 * Sends a confirmation email to the registrant and a notification to the event organizer.
 */
exports.sendRegistrationEmail = onDocumentCreated(
  {
    document: "registrations/{registrationId}",
    secrets: [GMAIL_USER, GMAIL_PASS],
  },
  async (event) => {
    const data = event.data?.data();
    if (!data) {
      console.error("No data found in registration document.");
      return null;
    }

    const { name, email, phone } = data;
    const registrationId = event.params.registrationId;

    console.log(`Processing registration for: ${name} (${email})`);

    // Create the Nodemailer transporter using Gmail SMTP
    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: GMAIL_USER.value(),
        pass: GMAIL_PASS.value(),
      },
    });

    // ─────────────────────────────────────────────────────────────────────────
    // 1. CONFIRMATION EMAIL to the participant
    // ─────────────────────────────────────────────────────────────────────────
    const participantMailOptions = {
      from: `"BCA Fest 2026 Team" <${GMAIL_USER.value()}>`,
      to: email,
      subject: "🎉 You're Registered for BCA Fest 2026!",
      html: `
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="UTF-8">
            <style>
              body { margin: 0; padding: 0; background-color: #0A192F; font-family: 'Arial', sans-serif; color: #CCD6F6; }
              .container { max-width: 600px; margin: 0 auto; padding: 40px 20px; }
              .header { text-align: center; padding: 40px 0 32px; }
              .logo-text { font-size: 32px; font-weight: 900; letter-spacing: 1px; color: #F59E0B; }
              .divider { height: 3px; background: linear-gradient(to right, #F59E0B, #06B6D4); border-radius: 3px; margin: 16px 0; }
              .card { background: #112240; border-radius: 16px; padding: 40px; border: 1px solid rgba(6,182,212,0.2); }
              h1 { color: #CCD6F6; font-size: 26px; margin-bottom: 16px; }
              p { color: #8892B0; line-height: 1.6; margin-bottom: 16px; }
              .detail-row { display: flex; padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,0.07); }
              .label { font-weight: bold; color: #CCD6F6; width: 100px; flex-shrink: 0; }
              .value { color: #8892B0; }
              .cta-button { display: inline-block; background: #06B6D4; color: white; text-decoration: none; padding: 14px 32px; border-radius: 30px; font-weight: bold; font-size: 16px; margin: 24px 0; }
              .footer { text-align: center; padding-top: 40px; color: #4F5D75; font-size: 12px; }
              .highlight { color: #F59E0B; font-weight: bold; }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="header">
                <div class="logo-text">KLE BCA FEST 2026</div>
                <div class="divider"></div>
              </div>
              <div class="card">
                <h1>Welcome aboard, ${name}! 🚀</h1>
                <p>Your registration for <span class="highlight">BCA Fest 2026</span> has been confirmed. We are thrilled to have you participate in this celebration of innovation and technology!</p>
                
                <div style="margin: 24px 0;">
                  <div class="detail-row"><span class="label">Name</span><span class="value">${name}</span></div>
                  <div class="detail-row"><span class="label">Email</span><span class="value">${email}</span></div>
                  <div class="detail-row"><span class="label">Phone</span><span class="value">${phone}</span></div>
                  <div class="detail-row"><span class="label">Event</span><span class="value">BCA Fest 2026 - All Events Open</span></div>
                  <div class="detail-row"><span class="label">Date</span><span class="value">June 1, 2026</span></div>
                  <div class="detail-row"><span class="label">Venue</span><span class="value">KLE Society's BCA College, Gangavathi - 583227</span></div>
                  <div class="detail-row" style="border-bottom: none;"><span class="label">Ref ID</span><span class="value" style="font-family: monospace; font-size: 12px;">${registrationId}</span></div>
                </div>

                <p>Please arrive by <strong>8:30 AM</strong> on the event day for registration and check-in. Carry a valid college ID card.</p>
                
                <div style="text-align: center;">
                  <a href="https://maps.google.com/?q=KLE+BCA+College+Gangavathi" class="cta-button">Get Directions</a>
                </div>
              </div>
              <div class="footer">
                <p>KLE Society's BCA College, CBS Gunj Road, Gangavathi - 583227, Karnataka</p>
                <p>📧 bca.gvti@gmail.com &nbsp;|&nbsp; 📞 +91 80957 78378</p>
                <p style="margin-top: 16px; color: #4F5D75;">© 2026 KLE Society's BCA College. All rights reserved.</p>
              </div>
            </div>
          </body>
        </html>
      `,
    };

    // ─────────────────────────────────────────────────────────────────────────
    // 2. NOTIFICATION EMAIL to the organizer
    // ─────────────────────────────────────────────────────────────────────────
    const organizerMailOptions = {
      from: `"BCA Fest 2026 System" <${GMAIL_USER.value()}>`,
      to: GMAIL_USER.value(),  // Notify the organizer's own inbox
      subject: `[BCA Fest 2026] New Registration — ${name}`,
      html: `
        <h2>New Registration Received</h2>
        <table>
          <tr><td><strong>Name:</strong></td><td>${name}</td></tr>
          <tr><td><strong>Email:</strong></td><td>${email}</td></tr>
          <tr><td><strong>Phone:</strong></td><td>${phone}</td></tr>
          <tr><td><strong>Timestamp:</strong></td><td>${new Date().toLocaleString("en-IN")}</td></tr>
          <tr><td><strong>Reference ID:</strong></td><td>${registrationId}</td></tr>
        </table>
      `,
    };

    try {
      await transporter.sendMail(participantMailOptions);
      console.log(`Confirmation email sent to participant: ${email}`);
      
      await transporter.sendMail(organizerMailOptions);
      console.log("Organizer notification email sent.");
    } catch (error) {
      console.error("Error sending email:", error);
    }

    return null;
  }
);

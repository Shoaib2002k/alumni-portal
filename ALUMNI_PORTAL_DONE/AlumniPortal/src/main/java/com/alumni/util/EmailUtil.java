package com.alumni.util;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {

    // Configure your email and app password here:
    private static final String SENDER_EMAIL = "your_email@gmail.com"; 
    private static final String SENDER_PASSWORD = "your_app_password"; 

    public static void sendOtpEmail(String recipientEmail, String otp) {
        
        // Use a separate thread so it doesn't block the UI
        new Thread(() -> {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            Session session = Session.getInstance(props,
                    new javax.mail.Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                        }
                    });

            try {
                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(SENDER_EMAIL));
                message.setRecipients(Message.RecipientType.TO,
                        InternetAddress.parse(recipientEmail));
                message.setSubject("MEASI Alumni Portal - Verification OTP");
                message.setText("Dear User,\n\n"
                        + "Your OTP for verifying your email on the MEASI Alumni Portal is: " + otp + "\n\n"
                        + "This OTP is valid for 5 minutes.\n\n"
                        + "Regards,\nMEASI Alumni Team");

                Transport.send(message);
                System.out.println("OTP Email sent successfully to " + recipientEmail);

            } catch (MessagingException e) {
                System.out.println("Failed to send OTP Email to " + recipientEmail);
                e.printStackTrace();
            }
        }).start();
    }
}

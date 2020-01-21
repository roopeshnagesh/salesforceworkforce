public with sharing class EmailManager {
    public static void sendEmail(List<String> addresses, String subject, String htmlBody) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject(subject);
        email.setToAddresses(addresses);
        email.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}
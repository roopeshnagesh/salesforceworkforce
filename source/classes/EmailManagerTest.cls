@isTest
private class EmailManagerTest{
    
    @isTest
    static void testSendEmail() {
        Test.StartTest();
        EmailManager.sendEmail(new List<String>{'test@gmail.com'}, 'Unit Test', '<span>HTML Unit Test</span>');
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
 
        System.assertEquals(1, invocations, 'An email has not been sent');
    }
}
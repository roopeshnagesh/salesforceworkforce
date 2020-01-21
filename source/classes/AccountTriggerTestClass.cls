@isTest 
private class AccountTriggerTestClass {
    static testMethod void validateAccountNumber() {
       Account a = new Account(Name='Validate Account Number', IntacctID__c='C100');
       System.debug('Account Number before inserting Account: ' + a.AccountNumber);

       // Insert Account
       insert a;
    
       // Retrieve the Account
       a = [SELECT AccountNumber FROM Account WHERE Id =:a.Id];
       System.debug('Account Number after Account trigger fired (insert): ' + a.AccountNumber);

       // Test that the trigger correctly updated the Account Number
       System.assertEquals('C100', a.AccountNumber);
        
       // Update Account
       a.IntacctID__c='C200';
       update a;
       
       // Test that the trigger correctly handled the updating of the Account Number
       a = [SELECT AccountNumber FROM Account WHERE Id =:a.Id];
       System.debug('Account Number after Account trigger fired (update): ' + a.AccountNumber);
       System.assertEquals('C200', a.AccountNumber);
    }
}
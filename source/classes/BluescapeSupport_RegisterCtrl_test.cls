@isTest
public class BluescapeSupport_RegisterCtrl_test {
    static Account createAccount()
    {
        Account a = new Account(Name='Bluescape Community Account');
        insert a;

        return a;
    }

    static Contact createContact(Account a)
    {
        Contact c = new Contact(firstname='John', lastname='Doe', AccountId=a.Id);
        insert c;

        return c;
    }

    static User createUser(Contact c)
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User Custom'];
        User u = new User(
            Alias = 'jdoe',
            Email='johndoe@bluescape.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='johndoe@bluescape.com',
            ContactId=c.Id);
        insert u;

        return u;
    }

    static testMethod void testLoadRegisterCtrl()
    {
        Account account = createAccount();
        Contact contact = createContact(account);
        User user = createUser(contact);
        
        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_Register'));

        test.StartTest();

        BluescapeSupport_RegisterCtrl ctrl = new BluescapeSupport_RegisterCtrl();

        ctrl.username = 'JohnDoe';
        ctrl.firstName = 'John';
        ctrl.lastName = 'Doe';
        ctrl.email = 'johndoe@bluescape.com';
		ctrl.communityNickname = 'johnny';

        BluescapeSupport_RegisterCtrl.RegistrationResponse rr = new BluescapeSupport_RegisterCtrl.RegistrationResponse(true);
        rr.errorMessage = 'error';
        rr.redirectUrl = 'http://localhost/callback';
        ctrl.password = 'abcd1234';
        ctrl.confirmPassword = 'abcd1234';        
        System.assert(ctrl.registerUser() == null);
        ctrl.password = 'abcd1234';
        ctrl.confirmPassword = 'abcd123';
        System.assert(ctrl.registerUser() == null);
        
        System.assert (ctrl != null, 'Have controller');

        test.StopTest();
    }
}
@isTest
public class BluescapeSupport_BaseController_test
{
    static User createGuest()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE 'Bluescape Support Profile%'];
        User u = new User(
            Alias = 'standt',
            Email='guest@bluescape.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='guest@bluescape.com');

        return u;
    }

    static User createUser()
    {
        Account a = new Account(Name='TestAccount');
        insert a;

        Contact c = new Contact(firstname='Test', lastname='Contact', AccountId=a.Id);
        insert c;

        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User Custom'];
        User u = new User(
            Alias = 'standt',
            Email='user@bluescape.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='user@bluescape.com',
            ContactId=c.Id);
        insert u;

        return u;
    }

    static User createSuperUser()
    {
        Account a = new Account(Name='TestAccount');
        insert a;

        Contact c = new Contact(firstname='Test', lastname='Contact', AccountId=a.Id);
        insert c;

        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community SU Custom'];
        User u = new User(
            Alias = 'standt',
            Email='superuser@bluescape.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='superuser@bluescape.com',
            ContactId=c.Id);
        insert u;

        return u;
    }

    static testMethod void testControllerInit_guest()
    {
        User user = createGuest();

        test.StartTest();

        System.runAs(user) {
            BluescapeSupport_BaseController ctrl = new BluescapeSupport_BaseController();

            System.assert (ctrl.userId == null, 'Have no user id');
            System.assert (ctrl.userName == null, 'Have no user name');
            System.assert (ctrl.userAccountId == null, 'Have no user account id');
            System.assert (ctrl.userContactId == null, 'Have no user contact id');
            System.assert (ctrl.userProfile == null, 'Have no user profile');
            System.assert (ctrl.isSuperUser == false, 'User is not super user');
        }

        test.StopTest();
    }

    static testMethod void testControllerInit_user()
    {
        User user = createUser();

        test.StartTest();

        System.runAs(user) {
            BluescapeSupport_BaseController ctrl = new BluescapeSupport_BaseController();

            System.assert (ctrl.userId == UserInfo.getUserId(), 'Have user id');
            System.assert (ctrl.userName == UserInfo.getName(), 'Have user name');

            User userData = [SELECT Contact.Id, Contact.AccountId, Profile.Name FROM User WHERE Id = :user.Id];

            System.assert (ctrl.userContactId == userData.Contact.Id, 'Have user account id');
            System.assert (ctrl.userAccountId == userData.Contact.AccountId, 'Have user contact id');
            System.assert (ctrl.userProfile == userData.Profile.Name, 'Have user profile');
            System.assert (ctrl.isSuperUser == false, 'User is not super user');
        }

        test.StopTest();
    }

    static testMethod void testControllerInit_superuser()
    {
        User user = createSuperUser();

        test.StartTest();

        System.runAs(user) {
            BluescapeSupport_BaseController ctrl = new BluescapeSupport_BaseController();

            System.assert (ctrl.isSuperUser == true, 'User is super user');
        }

        test.StopTest();
    }
}
@isTest
public class BluescapeSupport_MyCasesCtrl_test
{
    static Account createAccount()
    {
        Account a = new Account(Name='TestAccount');
        insert a;

        return a;
    }

    static Contact createContact(Account a)
    {
        Contact c = new Contact(firstname='Test', lastname='Contact', AccountId=a.Id);
        insert c;

        return c;
    }

    static User createUser(Contact c)
    {
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

    static User createSuperUser(Contact c)
    {
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

    static Case createCase(Boolean isOpen, Contact contact, Account account)
    {
        Case case1 = new Case();
        case1.Subject = 'Test issue';

        if (contact != null)
        {
            case1.ContactId = contact.Id;
        }

        if (account != null)
        {
            case1.AccountId = account.Id;
        }

        insert case1;

        if (!isOpen)
        {
            case1.Status = 'Closing (Pending review)';
            update case1;

            case1.Status = 'Closed';
            update case1;
        }

        return case1;
    }

    static testMethod void testControllerInit_user()
    {
        Account account = createAccount();
        Contact contact = createContact(account);
        User user = createUser(contact);
        Case caseRec1 = createCase(true, contact, null);
        Case caseRec2 = createCase(false, contact, null);

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_MyCases'));
        System.currentPageReference().getParameters().put('v', 'zzzz');
        System.currentPageReference().getParameters().put('p', '10');
        System.currentPageReference().getParameters().put('sf', null);
        System.currentPageReference().getParameters().put('sd', null);

        test.StartTest();

        System.runAs(user) {
            BluescapeSupport_MyCasesController ctrl = new BluescapeSupport_MyCasesController();

            System.assert (ctrl.caseViews.size() == 4, 'Have case views');
            System.assert (ctrl.caseViews[0].getValue() == 'u', 'Have case view 1 value');
            System.assert (ctrl.caseViews[1].getValue() == 'uo', 'Have case view 2 value');
            System.assert (ctrl.caseViews[2].getValue() == 'a', 'Have case view 3 value');
            System.assert (ctrl.caseViews[3].getValue() == 'ao', 'Have case view 4 value');

            System.assert (ctrl.curView == 'u', 'Have curView');

            System.assert (ctrl.caseList.size() == 2, 'Have cases');
            System.assert (ctrl.caseList[0].id == caseRec1.Id, 'Have case 1');
            System.assert (ctrl.caseList[1].id == caseRec2.Id, 'Have case 2');

            System.assert (ctrl.pageData.sortField == 'CaseNumber', 'Have sortField');
            System.assert (ctrl.pageData.sortDir == 'asc', 'Have sortDir');
            System.assert (ctrl.pageData.pageNumber == 1, 'Have pageNumber');
            System.assert (ctrl.pageData.recordCount == 2, 'Have recordCount');
        }

        test.StopTest();
    }

    static testMethod void testControllerInit_user_requestAccount()
    {
        Account account = createAccount();
        Contact contact1 = createContact(account);
        Contact contact2 = createContact(account);
        User user = createUser(contact1);
        Case caseRec1 = createCase(true, contact1, account);
        Case caseRec2 = createCase(true, contact2, account);

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_MyCases'));
        System.currentPageReference().getParameters().put('v', 'a');
        System.currentPageReference().getParameters().put('p', '1');
        System.currentPageReference().getParameters().put('sf', null);
        System.currentPageReference().getParameters().put('sd', null);

        test.StartTest();

        System.runAs(user) {
            BluescapeSupport_MyCasesController ctrl = new BluescapeSupport_MyCasesController();

            System.assert (ctrl.curView == 'u', 'Have curView');
            System.assert (ctrl.caseList.size() == 1, 'Have cases');
            System.assert (ctrl.pageData.recordCount == 1, 'Have recordCount');
        }

        test.StopTest();
    }

    static testMethod void testControllerInit_userOpenOnly()
    {
        Account account = createAccount();
        Contact contact = createContact(account);
        User user = createUser(contact);
        Case caseRec1 = createCase(true, contact, null);
        Case caseRec2 = createCase(false, contact, null);

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_MyCases'));
        System.currentPageReference().getParameters().put('v', 'uo');
        System.currentPageReference().getParameters().put('p', '1');
        System.currentPageReference().getParameters().put('sf', 'ContactId');
        System.currentPageReference().getParameters().put('sd', 'desc');

        test.StartTest();

        System.runAs(user) {
            BluescapeSupport_MyCasesController ctrl = new BluescapeSupport_MyCasesController();

            System.assert (ctrl.curView == 'uo', 'Have curView');

            System.assert (ctrl.caseList.size() == 1, 'Have cases');
            System.assert (ctrl.caseList[0].id == caseRec1.Id, 'Have case 1');

            System.assert (ctrl.pageData.sortField == 'ContactId', 'Have sortField');
            System.assert (ctrl.pageData.sortDir == 'desc', 'Have sortDir');
            System.assert (ctrl.pageData.pageNumber == 1, 'Have pageNumber');
            System.assert (ctrl.pageData.recordCount == 1, 'Have recordCount');
        }

        test.StopTest();
    }

    static testMethod void testControllerInit_superuser()
    {
        Account account = createAccount();
        Contact contact1 = createContact(account);
        Contact contact2 = createContact(account);
        User user = createSuperUser(contact1);
        Case caseRec1 = createCase(true, contact1, account);
        Case caseRec2 = createCase(false, contact2, account);

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_MyCases'));
        System.currentPageReference().getParameters().put('v', 'a');
        System.currentPageReference().getParameters().put('p', '1');
        System.currentPageReference().getParameters().put('sf', null);
        System.currentPageReference().getParameters().put('sd', null);

        test.StartTest();

        System.runAs(user) {
            BluescapeSupport_MyCasesController ctrl = new BluescapeSupport_MyCasesController();

            System.assert (ctrl.curView == 'a', 'Have curView');
            System.assert (ctrl.caseList.size() == 2, 'Have cases');
            System.assert (ctrl.pageData.recordCount == 2, 'Have recordCount');
        }

        test.StopTest();
    }

    static testMethod void testControllerInit_superuserOpenOnly()
    {
        Account account = createAccount();
        Contact contact1 = createContact(account);
        Contact contact2 = createContact(account);
        User user = createSuperUser(contact1);
        Case caseRec1 = createCase(true, contact1, account);
        Case caseRec2 = createCase(false, contact2, account);

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_MyCases'));
        System.currentPageReference().getParameters().put('v', 'ao');
        System.currentPageReference().getParameters().put('p', '1');
        System.currentPageReference().getParameters().put('sf', null);
        System.currentPageReference().getParameters().put('sd', null);

        test.StartTest();

        System.runAs(user) {
            BluescapeSupport_MyCasesController ctrl = new BluescapeSupport_MyCasesController();

            System.assert (ctrl.curView == 'ao', 'Have curView');
            System.assert (ctrl.caseList.size() == 1, 'Have cases');
            System.assert (ctrl.pageData.recordCount == 1, 'Have recordCount');
        }

        test.StopTest();
    }
}
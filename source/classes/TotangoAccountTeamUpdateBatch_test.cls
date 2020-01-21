@isTest
public class TotangoAccountTeamUpdateBatch_test {

    @isTest
    public static void testQueryLocator()
    {
        TotangoAccountTeamUpdateBatch batch = new TotangoAccountTeamUpdateBatch();
        Database.QueryLocator qryLoc = batch.start(null);

        System.assert (qryLoc.getQuery() == 'SELECT Id FROM Account WHERE Type = \'Customer\' OR Type = \'Haworth Dealer\'');
    }

    @isTest
    public static void testFinish()
    {
        TotangoAccountTeamUpdateBatch batch = new TotangoAccountTeamUpdateBatch();

        batch.finish(null);
    }

    private static Account createAccount()
    {
        Account acct = new Account(Name='TestAccount1');
        insert acct;

        return acct;
    }

    private static User createUser(Account acct, Integer userNo)
    {
        Contact c = new Contact(firstname='Test', lastname='Contact', AccountId=acct.Id);
        insert c;

        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User Custom'];
        User u = new User(
            Alias = 'standt',
            Email = 'user' + userNo + '@bluescape.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'user' + userNo + '@bluescape.com',
            ContactId = c.Id);
        insert u;

        return u;
    }

    private static List<sObject> createTeam(Account acct)
    {
        User user1 = createUser(acct, 1);
        User user2 = createUser(acct, 2);

        AccountTeamMember member1 = new AccountTeamMember(
            UserId = user1.Id,
            AccountId = acct.Id,
            TeamMemberRole = 'Regional Sales Manager'
            );

        AccountTeamMember member2 = new AccountTeamMember(
            UserId = user2.Id,
            AccountId = acct.Id,
            TeamMemberRole = 'Solutions Consultant'
            );

        return new List<sObject> {user1, member1, user2, member2};
    }

    @isTest
    public static void testExecute()
    {
        Account acct = createAccount();

        // Entitlement test
        Product2 prod1 = TotangoAccountDerivedCalculator_test.createProduct('FeeUserSvcShare');
        String pbookId = Test.getStandardPricebookId();
        PricebookEntry entry1 = TotangoAccountDerivedCalculator_test.createPricebookEntry(pbookId, prod1.Id);
        ServiceContract contract1 = TotangoAccountDerivedCalculator_test.createServiceContract(pbookId, acct.Id);
        ContractLineItem lineItem1 = TotangoAccountDerivedCalculator_test.createContractLineItem(contract1.Id, entry1.Id, 2);
        Entitlement ent1 = TotangoAccountDerivedCalculator_test.createEntitlement(acct.Id, 'User Licenses', lineItem1, Date.today().addDays(-1), Date.today().addDays(3));

        // Team test
        List<sObject> usersMembers = createTeam(acct);
        User user1 = (User) usersMembers[0];
        User user2 = (User) usersMembers[2];

        TotangoAccountTeamUpdateBatch batch = new TotangoAccountTeamUpdateBatch();
        batch.execute(null, new List<sObject> {acct});

        System.assert (acct.Totango_Sales_Manager__c == user1.Name, 'have sales manager');
        System.assert (acct.Totango_Success_Manager__c == user2.Name, 'have success manager');
        System.assert (acct.Totango_Purchased_Floating_Licenses__c == 2, 'have float lic count');
    }
}
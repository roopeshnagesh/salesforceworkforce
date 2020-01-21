@isTest
public class TotangoAccountDerivedCalculator_test {

    public static Account createAccount()
    {
        Account acct = new Account(Name='TestAccount1');
        insert acct;

        return acct;
    }

    public static User createUser(Account acct, Integer userNo)
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

    public static AccountTeamMember createTeamMember(Account acct, User user, String role)
    {
        AccountTeamMember member = new AccountTeamMember(
            UserId = user.Id,
            AccountId = acct.Id,
            TeamMemberRole = role
            );

        return member;
    }

    // See: SalesOrderUtils.apxc

    public static Product2 createProduct(String code)
    {
        Product2 product = new Product2();
        product.Name = 'Test product';
        product.ProductCode = code;
        insert product;

        return product;
    }

    public static ServiceContract createServiceContract(String pricebookId, String accountId)
    {
        ServiceContract serviceContract = new ServiceContract();
        serviceContract.Name = 'Service Contract';
        serviceContract.Pricebook2Id = pricebookId;
        serviceContract.AccountId = accountId;
        insert serviceContract;

        return serviceContract;
    }

    public static Pricebook2 createPricebook(Boolean isStandard)
    {
        Pricebook2 pbook = new Pricebook2();
        pbook.Name = 'Standard PBook';
        insert pbook;

        return pbook;
    }

    public static PricebookEntry createPricebookEntry(String pricebookId, String product2Id)
    {
        PricebookEntry entry = new PricebookEntry();
        entry.Product2Id = product2Id;
        entry.UnitPrice = 100;
        entry.Pricebook2Id = pricebookId;
        entry.IsActive = true;
        insert entry;

        return entry;
    }

    public static ContractLineItem createContractLineItem(String serviceContractId, String pricebookEntryId, Integer quantity)
    {
        ContractLineItem contractLineItem = new ContractLineItem();
        contractLineItem.PricebookEntryId = pricebookEntryId;
        contractLineItem.Quantity = quantity;
        contractLineItem.UnitPrice = 100;
        contractLineItem.ServiceContractId = serviceContractId;
        insert contractLineItem;

        return contractLineItem;
    }

    public static Entitlement createEntitlement(String acctId, String type, ContractLineItem lineItem, Date startDate, Date endDate)
    {
        Entitlement ent = new Entitlement(
            Name = 'Foo Entitlement',
            AccountId = acctId,
            Type = type,
            ContractLineItemId = lineItem.Id,
            StartDate = startDate,
            EndDate = endDate,
            Quantity__c = lineItem.Quantity
            );
        insert ent;

        return ent;
    }

    @isTest
    public static void testAccountTeamWithAccount()
    {
        Account acct = createAccount();
        User user1 = createUser(acct, 1);
        User user2 = createUser(acct, 2);
        AccountTeamMember member1 = createTeamMember(acct, user1, 'Regional Sales Manager');
        AccountTeamMember member2 = createTeamMember(acct, user2, 'Solutions Consultant');

        System.assert (acct.Totango_Sales_Manager__c == null);
        System.assert (acct.Totango_Success_Manager__c == null);

        TotangoAccountDerivedCalculator.updateTotangoDerivedFields_AccountTeam(acct);

        System.assert (acct.Totango_Sales_Manager__c == user1.Name);
        System.assert (acct.Totango_Success_Manager__c == user2.Name);

        Account acctCopy = [SELECT Totango_Sales_Manager__c, Totango_Success_Manager__c FROM Account WHERE Id = :acct.Id];

        System.assert (acctCopy.Totango_Sales_Manager__c == null);
        System.assert (acctCopy.Totango_Success_Manager__c == null);
    }

    @isTest
    public static void testAccountTeamWithAccountId()
    {
        Account acct = createAccount();
        User user1 = createUser(acct, 1);
        User user2 = createUser(acct, 2);
        AccountTeamMember member1 = createTeamMember(acct, user1, 'Regional Sales Manager');
        AccountTeamMember member2 = createTeamMember(acct, user2, 'Solutions Consultant');

        System.assert (acct.Totango_Sales_Manager__c == null);
        System.assert (acct.Totango_Success_Manager__c == null);

        TotangoAccountDerivedCalculator.updateTotangoDerivedFields_AccountTeam(acct.Id);

        System.assert (acct.Totango_Sales_Manager__c == null);
        System.assert (acct.Totango_Success_Manager__c == null);

        Account acctCopy = [SELECT Totango_Sales_Manager__c, Totango_Success_Manager__c FROM Account WHERE Id = :acct.Id];

        System.assert (acctCopy.Totango_Sales_Manager__c == user1.Name);
        System.assert (acctCopy.Totango_Success_Manager__c == user2.Name);
    }

    @isTest
    public static void testEntitlementUpdate_RenewalDate_WithAccount()
    {
        Account acct = createAccount();

        System.assert (acct.Totango_Renewal_Date__c == null, 'renewal date is null');
        System.assert (acct.Totango_Purchased_Named_Licenses__c == null, 'named lic count is null');
        System.assert (acct.Totango_Purchased_Floating_Licenses__c == null, 'float lic count is null');

        Product2 prod1 = createProduct('FeeUsrSvc');
        String pbookId = Test.getStandardPricebookId();
        PricebookEntry entry1 = createPricebookEntry(pbookId, prod1.Id);
        ServiceContract contract1 = createServiceContract(pbookId, acct.Id);
        ContractLineItem lineItem1 = createContractLineItem(contract1.Id, entry1.Id, 7);
        Entitlement ent1 = createEntitlement(acct.Id, 'User Licenses', lineItem1, Date.today().addDays(-1), Date.today().addDays(3));

        System.assert (acct.Totango_Renewal_Date__c == null, 'have renewal date');

        TotangoAccountDerivedCalculator.updateTotangoDerivedFields_Entitlements(acct);

        Entitlement entCopy = [SELECT Renewal_Date__c FROM Entitlement WHERE Id = :ent1.Id];

        System.assert (acct.Totango_Renewal_Date__c == entCopy.Renewal_Date__c, 'have renewal date');
    }

    @isTest
    public static void testEntitlementUpdate_RenewalDate_WithAccountId()
    {
        Account acct = createAccount();

        System.assert (acct.Totango_Renewal_Date__c == null, 'renewal date is null');
        System.assert (acct.Totango_Purchased_Named_Licenses__c == null, 'named lic count is null');
        System.assert (acct.Totango_Purchased_Floating_Licenses__c == null, 'float lic count is null');

        Product2 prod1 = createProduct('FeeUsrSvc');
        String pbookId = Test.getStandardPricebookId();
        PricebookEntry entry1 = createPricebookEntry(pbookId, prod1.Id);
        ServiceContract contract1 = createServiceContract(pbookId, acct.Id);
        ContractLineItem lineItem1 = createContractLineItem(contract1.Id, entry1.Id, 7);
        Entitlement ent1 = createEntitlement(acct.Id, 'User Licenses', lineItem1, Date.today().addDays(-1), Date.today().addDays(3));

        TotangoAccountDerivedCalculator.updateTotangoDerivedFields_Entitlements(acct.Id);

        Account renewalDateAcct = [SELECT Totango_Renewal_Date__c FROM Account WHERE Id = :acct.Id];
        Entitlement entCopy = [SELECT Renewal_Date__c FROM Entitlement WHERE Id = :ent1.Id];

        System.assert (renewalDateAcct.Totango_Renewal_Date__c == entCopy.Renewal_Date__c, 'have renewal date');
    }

    @isTest
    public static void testEntitlementUpdate_NamedLicenseCount_WithAccountId()
    {
        Account acct = createAccount();
        Product2 prod1 = createProduct('FeeUsrSvc');
        String pbookId = Test.getStandardPricebookId();
        PricebookEntry entry1 = createPricebookEntry(pbookId, prod1.Id);
        ServiceContract contract1 = createServiceContract(pbookId, acct.Id);
        ContractLineItem lineItem1 = createContractLineItem(contract1.Id, entry1.Id, 7);
        ContractLineItem lineItem2 = createContractLineItem(contract1.Id, entry1.Id, 14);
        Entitlement ent1 = createEntitlement(acct.Id, 'User Licenses', lineItem1, Date.today().addDays(-1), Date.today().addDays(3));
        Entitlement ent2 = createEntitlement(acct.Id, 'User Licenses', lineItem2, Date.today().addDays(-1), Date.today().addDays(3));

        TotangoAccountDerivedCalculator.updateTotangoDerivedFields_Entitlements(acct.Id);

        Account namedLicAcct = [SELECT Totango_Purchased_Floating_Licenses__c, Totango_Purchased_Named_Licenses__c FROM Account WHERE Id = :acct.Id];

        System.assert (namedLicAcct.Totango_Purchased_Named_Licenses__c == 21, 'have named lic count');
        System.assert (namedLicAcct.Totango_Purchased_Floating_Licenses__c == null, 'have no float lic');
    }

    @isTest
    public static void testEntitlementUpdate_FloatingLicenseCount_WithAccountId()
    {
        Account acct = createAccount();
        Product2 prod1 = createProduct('FeeUserSvcShare');
        Product2 prod2 = createProduct('FeeUserSvcFloat');
        String pbookId = Test.getStandardPricebookId();
        PricebookEntry entry1 = createPricebookEntry(pbookId, prod1.Id);
        PricebookEntry entry2 = createPricebookEntry(pbookId, prod2.Id);
        ServiceContract contract1 = createServiceContract(pbookId, acct.Id);
        ContractLineItem lineItem1 = createContractLineItem(contract1.Id, entry1.Id, 2);
        ContractLineItem lineItem2 = createContractLineItem(contract1.Id, entry2.Id, 3);
        Entitlement ent1 = createEntitlement(acct.Id, 'User Licenses', lineItem1, Date.today().addDays(-1), Date.today().addDays(3));
        Entitlement ent2 = createEntitlement(acct.Id, 'User Licenses', lineItem2, Date.today().addDays(-1), Date.today().addDays(3));

        TotangoAccountDerivedCalculator.updateTotangoDerivedFields_Entitlements(acct.Id);

        Account floatLicAcct = [SELECT Totango_Purchased_Floating_Licenses__c FROM Account WHERE Id = :acct.Id];

        System.assert (floatLicAcct.Totango_Purchased_Floating_Licenses__c == 5, 'have float lic count');
    }
}
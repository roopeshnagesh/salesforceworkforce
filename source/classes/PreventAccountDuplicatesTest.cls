@isTest
public class PreventAccountDuplicatesTest {

    @isTest
    public static void testDupeAccountInsertRejected()
    {
        Test.startTest();

        String acctName = 'Test Account';

        Account acct1 = new Account(Name=acctName);
        insert acct1;

        try
        {
            Account acct2 = new Account(Name=acctName);
            insert acct2;
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown = e.getMessage().contains('An account with that name already exists.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

        Test.stopTest();
    }

    @isTest
    public static void testDupeAccountUpdateRejected()
    {
        Test.startTest();

        Account acct1 = new Account(Name='Test Account 1');
        insert acct1;

        Account acct2 = new Account(Name='Test Account 2');
        insert acct2;

        try
        {
            acct2.Name = acct1.Name;
            update acct2;
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown = e.getMessage().contains('An account with that name already exists.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

        Test.stopTest();
    }

    @isTest
    public static void testSameAccountUpdateAccepted()
    {
        Test.startTest();

        Account acct1 = new Account(Name='Test Account 1');
        insert acct1;

        acct1.Website = 'http://bluescape.com';
        update acct1;

        Account acct2 = [SELECT Id, Name, Website FROM Account WHERE Id = :acct1.Id];
        System.AssertEquals(acct2.Website, 'http://bluescape.com');

        Test.stopTest();
    }

    @isTest
    public static void testSimilarAccountInsertAccepted()
    {
        Test.startTest();

        String acct1Name = 'First Test Account';
        String acct2Name = 'Test Account';

        Account acct1 = new Account(Name=acct1Name);
        insert acct1;

        Account acct2 = new Account(Name=acct2Name);
        insert acct2;

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name IN (:acct1Name, :acct2Name)];
        System.AssertEquals(accounts.size(), 2);

        Test.stopTest();
    }
}
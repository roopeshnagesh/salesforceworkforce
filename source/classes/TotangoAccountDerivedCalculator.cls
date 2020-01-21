public class TotangoAccountDerivedCalculator {

    public static void updateTotangoDerivedFields_AccountTeam(String accountId)
    {
        Account acct = [SELECT Id
                        FROM Account
                        WHERE Id = :accountId];

        updateTotangoDerivedFields_AccountTeam(acct);

        update acct;
    }

    public static void updateTotangoDerivedFields_AccountTeam(Account acct)
    {
        try
        {
            AccountTeamMember rsm = [SELECT User.Name FROM AccountTeamMember WHERE Account.Id = :acct.Id AND TeamMemberRole = 'Regional Sales Manager' ORDER BY CreatedDate DESC LIMIT 1];
            acct.Totango_Sales_Manager__c = rsm.User.Name;
        }
        catch (Exception e)
        {
            acct.Totango_Sales_Manager__c = null;
        }

        try
        {
            AccountTeamMember csm = [SELECT User.Name FROM AccountTeamMember WHERE Account.Id = :acct.Id AND TeamMemberRole = 'Solutions Consultant' ORDER BY CreatedDate DESC LIMIT 1];
            acct.Totango_Success_Manager__c = csm.User.Name;
        }
        catch (Exception e)
        {
            acct.Totango_Success_Manager__c = null;
        }
    }

    public static void updateTotangoDerivedFields_Entitlements(String accountId)
    {
        Account acct = [SELECT Id, Totango_Renewal_Date__c, Totango_Purchased_Named_Licenses__c, Totango_Purchased_Floating_Licenses__c
                        FROM Account
                        WHERE Id = :accountId];

        updateTotangoDerivedFields_Entitlements(acct);

        update acct;
    }

    public static void updateTotangoDerivedFields_Entitlements(Account acct)
    {
        try
        {
            AggregateResult[] aggRenewalDate = [SELECT MIN(Renewal_Date__c) maxDate FROM Entitlement WHERE Account.Id = :acct.Id AND Type = 'User Licenses' AND Status = 'Active'];
            acct.Totango_Renewal_Date__c = (Date) aggRenewalDate[0].get('maxDate');
        }
        catch (Exception e)
        {
            acct.Totango_Renewal_Date__c = null;
        }

        try
        {
            AggregateResult[] aggNamedLicenses = [SELECT SUM(Quantity__c) sumLic FROM Entitlement WHERE Account.Id = :acct.Id AND Type = 'User Licenses' AND Status = 'Active' AND Product__c IN ('FeeUsrSvc', 'UserPro', 'UserEnt', 'FeeUser-Enterprise-SLED')];
            acct.Totango_Purchased_Named_Licenses__c = (Decimal) aggNamedLicenses[0].get('sumLic');
        }
        catch (Exception e)
        {
            acct.Totango_Purchased_Named_Licenses__c = 0;
        }

        try
        {
            AggregateResult[] aggFloatingLicenses = [SELECT SUM(Quantity__c) sumLic FROM Entitlement WHERE Account.Id = :acct.Id AND Type = 'User Licenses' AND Status = 'Active' AND (Product__c IN ('FeeUserSvcFloat', 'FeeUserSvcShare', 'FeeUsrSvcConc'))];
            acct.Totango_Purchased_Floating_Licenses__c = (Decimal) aggFloatingLicenses[0].get('sumLic');
        }
        catch (Exception e)
        {
            acct.Totango_Purchased_Floating_Licenses__c = 0;
        }
    }

}
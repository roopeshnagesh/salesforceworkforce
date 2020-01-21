global class TotangoAccountTeamUpdateBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext info)
    {
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Type = \'Customer\' OR Type = \'Haworth Dealer\'');
    }

    global void execute(Database.BatchableContext info, List<sObject> scope)
    {
        List<Account> acctsToUpdate = new List<Account>();

        for(SObject obj : scope) {
            Account acct = (Account) obj;
            TotangoAccountDerivedCalculator.updateTotangoDerivedFields_AccountTeam(acct);
            TotangoAccountDerivedCalculator.updateTotangoDerivedFields_Entitlements(acct);
            acctsToUpdate.add(acct);
        }

        update acctsToUpdate;
    }

    global void finish(Database.BatchableContext info)
    {

    }
}
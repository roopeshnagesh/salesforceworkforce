trigger PreventAccountDuplicates on Account (before insert, before update) {
    List<Account> newAccts = Trigger.new;

    for (Account acct : newAccts)
    {
        List<Account> duplicateAcctList;

        if (Trigger.isUpdate) {
            duplicateAcctList = [SELECT Id, Name FROM Account WHERE Name LIKE :acct.Name AND Id != :acct.Id];
        }
        else {
            duplicateAcctList = [SELECT Id, Name FROM Account WHERE Name LIKE :acct.Name];
        }

        if (duplicateAcctList.size() > 0)
        {
            acct.addError('An account with that name already exists.');
        }
    }
}
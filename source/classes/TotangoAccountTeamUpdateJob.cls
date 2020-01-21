global class TotangoAccountTeamUpdateJob implements Schedulable {

    global void execute(SchedulableContext sc)
    {
        TotangoAccountTeamUpdateBatch updateAccounts = new TotangoAccountTeamUpdateBatch();

        Database.executeBatch(updateAccounts, 5);
    }
}
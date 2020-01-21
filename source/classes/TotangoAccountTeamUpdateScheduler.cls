global class TotangoAccountTeamUpdateScheduler {

    global void scheduleUpdate()
    {
        TotangoAccountTeamUpdateJob updateJob = new TotangoAccountTeamUpdateJob();
        String sch = '0 30 * ? * *';
        String jobID = system.schedule('TotangoAccountTeamUpdateJob', sch, updateJob);
    }
}
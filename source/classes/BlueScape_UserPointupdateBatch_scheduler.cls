global class BlueScape_UserPointupdateBatch_scheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
        BlueScape_UserPointupdateBatch b = new BlueScape_UserPointupdateBatch(); 
        if(!test.isRunningTest())
        {
        database.executebatch(b,100);
        }
         System.abortJob(sc.getTriggerId());
       ProcessUserPointUpdate();
    
    
   }
   
   public void ProcessUserPointUpdate()
   {
      DateTime dt = System.now();
           datetime nextScheduleTime = dt;
           nextScheduleTime = nextScheduleTime.addMinutes(5);
           string minute = string.valueof(nextScheduleTime.minute());
           string second = string.valueof(nextScheduleTime.second());
           string cronvalue = second + ' ' + minute + ' * * * ?';
           String jobName  = 'Bluescape User Points Update ';
           jobName = jobName + nextScheduleTime.hour() + ':' + minute + ':' + second;
           if(!test.isRunningTest())
           {
           BlueScape_UserPointupdateBatch_scheduler  obj= new BlueScape_UserPointupdateBatch_scheduler();
           String CronId = system.schedule(jobName, cronvalue, obj);
           system.debug('***CronId '+CronId);
           }
   }
}
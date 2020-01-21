@isTest
Public class BlueScape_UserPointupdate_schedulerTest
{
    static testMethod void testMethod1()
    {
        Test.startTest();
        BlueScape_UserPointupdateBatch_scheduler sh1=new BlueScape_UserPointupdateBatch_scheduler();
        String sch = '0 0 10 * * ?'; 
        system.schedule('test', sch, sh1); 
        Test.stopTest(); 
    }
}
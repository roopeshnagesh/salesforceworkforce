@isTest(seeAllData=true)
Public class BlueScape_UserPointupdateBatchTest
{
    static testMethod void testMethod1()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        contact c =  new contact();
        c.lastName = 'test';
        c.Total_Discussion_Points__c =10;
        c.Total_Idea_Points__c = 3; 
        //c.Total_Points__c = 4;
        insert c;
       
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing11', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id,Total_Discussion_Points__c = 10,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser121@testorg.com');
        insert u;
        
        List<NetworkMember> lstMember=new List<NetworkMember>();
        
        NetworkMember objMember=new NetworkMember();
        //objMember.MemberId=u.Id;
        //objMember.DigestFrequency='D';
        lstMember.add(objMember);
        //insert lstMember;
        
        Network objNetwork=new Network();
        // objNetwork.Name='test Ntw';
        //insert objNetwork; 
        test.startTest();
        BlueScape_UserPointupdateBatch obj=new BlueScape_UserPointupdateBatch();
       database.executebatch(obj,50000);
        test.stopTest();
    }
  
}
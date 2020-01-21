@isTest
Public class Bluescape_CommUserToGroupTrig_HanlrTest
{
static testMethod void testMethod1()
{
Bluescape_Discussion_Setting__c BDS=new Bluescape_Discussion_Setting__c();
bds.Group_Id__c='0F9230000008brh';
insert bds;

CollaborationGroup cg=new CollaborationGroup();
cg.Name='test';
cg.CollaborationType = 'Private';
//cg.Id=bds.Group_Id__c;
insert cg;

Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt1', Email='standarduser@testorg121.com', 
      EmailEncodingKey='UTF-8', LastName='Testing12', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduse1211r@testorg.com');
insert u;

set<Id> setUser=new set<Id>();
setUser.add(u.Id);
//update setUser;

Bluescape_CommUserToGroupTrig_Handler.AddToGroups(setUser);
AvoidRecursiveTrigger.Run=true;
Bluescape_CommUserToGroupTrig_Handler.UpdatePhotoURL(setUser);
}
}
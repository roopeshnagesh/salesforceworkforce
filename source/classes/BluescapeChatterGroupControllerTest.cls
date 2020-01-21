@isTest
private class BluescapeChatterGroupControllerTest
{
  static testMethod void testMethod1() 
    {
         Test.startTest();
           Bluescape_Discussion_Setting__c  discussionSettingObj = new Bluescape_Discussion_Setting__c();
           discussionSettingObj.Name  ='Link 1';
           discussionSettingObj.Group_Id__c = '0D1567890433';
           insert discussionSettingObj;
           BluescapeChatterGroupController obj = new BluescapeChatterGroupController();
           obj.groupid = null;
         Test.stopTest();
    }
}
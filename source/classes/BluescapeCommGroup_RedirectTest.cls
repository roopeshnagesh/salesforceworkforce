@isTest
private class BluescapeCommGroup_RedirectTest
{
   static testMethod void testMethod1() 
    {
         Test.startTest();
           BluescapeCommunityGroup_Redirect objRedirect = new BluescapeCommunityGroup_Redirect();
           Bluescape_Discussion_Setting__c  discussionSettingObj = new Bluescape_Discussion_Setting__c();
           discussionSettingObj.Name  ='Link 1';
           discussionSettingObj.Group_Id__c = '0D1567890433';
           insert discussionSettingObj;
           objRedirect.RedirectToCommunityGroup();
           BluescapeDiscussionController obj = new BluescapeDiscussionController();
           obj.RedirectToCommunityGroup();
           
         Test.stopTest();
    }
}
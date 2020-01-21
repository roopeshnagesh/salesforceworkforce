public with sharing class BluescapeDiscussionController
{
   public BluescapeDiscussionController()
   {
      
   }
   
   public Pagereference RedirectToCommunityGroup()
   {
      List< Bluescape_Discussion_Setting__c > DiscussionSettingList =   [SELECT Id, Group_Id__c, Name FROM Bluescape_Discussion_Setting__c Limit 1];
      if(DiscussionSettingList.size() > 0 )
      {
      
         //community2/_ui/core/userprofile/UserProfilePage?u=005E0000007t8y4&tab=sfdc.ProfilePlatformFeed
         //PageReference objChatter = new PageReference('/_ui/core/chatter/groups/GroupProfilePage?g='+DiscussionSettingList[0].Group_Id__c);
         PageReference objChatter = new PageReference('/_ui/core/userprofile/UserProfilePage?u='+UserInfo.getUserId());
         objChatter.setRedirect(true);
         return objChatter ;
      }
      return null;
   }
}
public with sharing class BluescapeChatterGroupController
{
   public CollaborationGroup  groupObj {get;set;}
   public Id groupid {get;set;}
   public BluescapeChatterGroupController()
   {
      groupObj = new CollaborationGroup ();
      List < Bluescape_Discussion_Setting__c  > discussionSettnigList =  [ SELECT Id, Group_Id__c, Name FROM Bluescape_Discussion_Setting__c Limit 1 ];
      List < CollaborationGroup > collationGroupList = [SELECT Id, Name FROM CollaborationGroup where Id =:discussionSettnigList[0].Group_Id__c];
      if(collationGroupList.size() > 0)
      groupid =  collationGroupList[0].Id;
   }
}
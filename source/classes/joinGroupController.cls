public with sharing class joinGroupController{

public joinGroupController(){}

public PageReference addToGroup() {
  Id userId = UserInfo.getUserId();
  Set<Id> userIds = new Set<Id>();
  userIds.add(userId);
  Bluescape_CommUserToGroupTrig_Handler.AddToGroups(userIds);
  /*CollaborationGroup chatterGroup=[select Id from CollaborationGroup Where Name='All Bluescape'];
  string groupURL = '/_ui/core/chatter/groups/GroupProfilePage?g='+chatterGroup.Id;*/
  
  PageReference pageRef = new PageReference('/apex/BluescapeHome');
  return pageRef ;
}
}
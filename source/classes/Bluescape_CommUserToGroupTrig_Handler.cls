public without sharing class Bluescape_CommUserToGroupTrig_Handler{
    @Future(Callout=true)
    public static void AddToGroups(Set<Id> userIds)
    {
    AvoidRecursiveTrigger.Run=false;
            
        // set up the groups that the user should be added to
        List<Bluescape_Discussion_Setting__c> groupLst=[SELECT Id, Name, Group_Id__c FROM Bluescape_Discussion_Setting__c limit 1];
        System.debug('***groupLst***'+groupLst);
        List < User > userUpdateList = new  List < User >();
        String communityProfileName = System.Label.BlueScape_Community_Profile_Name;
        if(groupLst.size()>0){     
            Id groupId=groupLst[0].Group_Id__c; 
            system.debug('***GroupId***'+groupId);  
            List<CollaborationGroup> chatterGroups=[select id, Name from CollaborationGroup where Id = :groupId];        
            System.debug('***chatterGroups***'+chatterGroups);
            List<CollaborationGroupMember> chatterGroupMembers=new List<CollaborationGroupMember>();
            //List<FeedItem> feedPosts=new List<FeedItem>();
               
             // loop the users that have been created
             for (User u : [select id,contactId, Username,Profile.Name,Small_Phot_URL__c,SmallPhotoUrl  from User where id in :userIds and IsActive=true])
             {
               if(u.SmallPhotoUrl != null)
               {
                    String [] arr = u.SmallPhotoUrl.split('.com/');
                    if(arr.size() >= 2)
                    {
                        String customLabelValue = System.Label.Community_URL_Name;
                        String newURL = '/'+ customLabelValue +'/'+arr[1];
                        System.debug('*****newURL***'+newURL);
                        u.Small_Phot_URL__c=newURL ;
                        userUpdateList.add(u);
                    }
               }
                
              
                if(u.contactId!= null && u.Profile.Name==communityProfileName){                    
                    // loop the groups
                    for (CollaborationGroup chatterGroup : chatterGroups)
                    {
                        // add the user to the group
                        CollaborationGroupMember cand = new CollaborationGroupMember(CollaborationGroupId=chatterGroup.id,MemberId = u.Id);
                        chatterGroupMembers.add(cand);
                        // announce this!
                        /*FeedItem fpost = new FeedItem(ParentId=chatterGroup.id,Body = u.username + ' added to group All Bluescape');
                        feedPosts.add(fpost);
                        fpost = new FeedItem(ParentId=u.id,Body = 'You have been added to the ' + chatterGroup.name);
                        feedPosts.add(fpost);*/
                    }
                }
               
            }
            System.debug('***chatterGroupMembers***'+chatterGroupMembers.size());
            if(chatterGroupMembers.size()>0){
                insert chatterGroupMembers;
            }
            
            if(userUpdateList.size() > 0)
            {
              // update userUpdateList;
            }
            //insert feedPosts;
        }
    }
    
    @Future(Callout=true)
    public static void UpdatePhotoURL(Set<Id> userIds)
    {
    AvoidRecursiveTrigger.Run=false;
        List < User > userUpdateList = new  List < User >();
         for (User u : [select id, Username,Profile.Name,Small_Phot_URL__c,SmallPhotoUrl  from User where id in :userIds and IsActive=true])
             {
               if(u.SmallPhotoUrl != null)
               {
                    String [] arr = u.SmallPhotoUrl.split('.com/');
                    if(arr.size() >= 2)
                    {
                        String customLabelValue = System.Label.Community_URL_Name;
                        String newURL = '/'+ customLabelValue +'/'+arr[1];
                        System.debug('*****newURL***'+newURL);
                        u.Small_Phot_URL__c=newURL ;
                        userUpdateList.add(u);
                    }
               }
               }
    
      if(userUpdateList.size() > 0)
            {
               update userUpdateList;
            }
            }
    
}
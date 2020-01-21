global class BlueScape_UserPointupdateBatch implements Database.Batchable<sObject>, Database.Stateful{

  
    global Database.QueryLocator start(Database.BatchableContext BC){
          List<Network> networkList = new List<Network>(); 
        String query='SELECT Id, NetworkId, MemberId, DigestFrequency, CreatedDate, ReputationPoints, LastChatterActivityDate FROM NetworkMember';
    
        String customLabelValue = System.Label.Bluescape_Custmer_Commnity_Name;
        networkList = [SELECT Id, Name FROM Network where Name =:customLabelValue];
        if(networkList.size()>0){
            String networkId = networkList[0].Id;
            System.debug('networkId 1'+networkId);            
            query += ' where NetworkId =\''+ networkId +'\' limit 50000';
            System.debug('query:'+query);
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<NetworkMember> scope)
    {    
        Map<Id,Double> userIdeaPointMap = new Map<Id,Double>();
        Set < String > userIdSet = new Set < String >();
        Set < String >  contactIdSet = new Set < String >();
        Map < String,String  > userContactMap = new Map < String , String >();
        Map < String , Contact > contactMap = new Map < String , Contact >();
        for(NetworkMember s : scope){
            userIdeaPointMap.put(s.MemBerId,Double.ValueOf(s.ReputationPoints)); 
            userIdSet.add(s.MemBerId);
        }
        System.debug('***userIdeaPointMap***'+userIdeaPointMap);
        System.debug('***userIdeaPointMap Size***'+userIdeaPointMap.size());
        
        List<User> usersLst = [Select Id,Name,ContactId ,Total_Discussion_Points__c From User where Id In:userIdeaPointMap.keyset() And IsActive=true];
        for ( User userItem : usersLst)
        {
            if( userItem.ContactId != null)
            {
                contactIdSet.add( userItem.ContactId );
                userContactMap.put( userItem.Id ,userItem.ContactId);
            }
        }
        
        List < Contact > contactList = [SELECT Id, Total_Discussion_Points__c, Total_Idea_Points__c, Total_Points__c FROM Contact where Id IN :contactIdSet ];
        
        for ( Contact item : contactList )
        {
            contactMap.put(item.id,item);
        }
        List<User> usersToUpdate = new List<User>();
        List < Contact > contactUpdateList = new List < Contact > ();
        for(User u : usersLst)
        {
            if(userContactMap.containsKey( u.Id ))
            {
                String contactIdVal = userContactMap.get(u.Id);
                if( contactMap.containsKey( contactIdVal ))
                {
                    Contact contactObj = contactMap.get( contactIdVal );
                    contactObj.Total_Discussion_Points__c = userIdeaPointMap.get(u.Id);
                    contactUpdateList.add( contactObj ); 
                }
            }
         

        }
        if(contactUpdateList.size()>0)
        {
            update contactUpdateList;
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
    }
}
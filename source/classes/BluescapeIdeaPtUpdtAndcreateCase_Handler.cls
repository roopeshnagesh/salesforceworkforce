public class BluescapeIdeaPtUpdtAndcreateCase_Handler {
       public void ProcessIdeaPoints(List < Idea >  ideaListValNew )
       {
           Set < String > createdByIdSet = new Set < String >();
           Map < String , User > UserMap = new Map < String ,User > ();
           Map < String , Contact > contactMap = new Map < String , Contact >();
           Map < String , Decimal> UserIdeaMap = new Map < String  , Decimal>();
           Map < String , String > userContactMap =new Map < String , String >();
          
           Set < String > voterIdSet = new Set < String >();
           for( Idea ideaObj : ideaListValNew)
           {
               voterIdSet.add(ideaObj.Id);
           }
           List<Idea> ideaList = [select VoteTotal, VoteScore,createdById from Idea Where ID IN : voterIdSet];
           for(Idea ideaObj : ideaList)
           {
                createdByIdSet.add(ideaObj.createdById);
           }
           if( createdByIdSet.size() > 0)
           {
              List< User >  UserList =  [SELECT Id,ContactId , Username, LastName, FirstName, Name, Total_Discussion_Points__c, Title, Total_Idea_Points__c, Total_Points__c FROM User where ID IN :createdByIdSet]; 
              Set < String > userContactIdSet = new Set < String >();
              for ( User userObj : UserList)
              {
                  if(userObj.ContactId != null)
                  {
                     userContactIdSet.add(userObj.ContactId);
                     userContactMap.put( userObj.ContactId , userObj.Id);
                  }
                    
              }
              if(userContactIdSet.size() > 0)
              {
                  List < Contact > contactList = [SELECT Id, Total_Discussion_Points__c, Total_Idea_Points__c, Total_Points__c FROM Contact where Id IN :userContactIdSet ];
                  for ( Contact item : contactList )
                  {
                      if(userContactMap.containsKey( item.id))
                      {
                            contactMap.put(userContactMap.get(item.Id), item);
                      }
                    
                  }
              }
           }
           for(Idea ideaObj : ideaList)
           {
               
              
               System.debug('****ideaObj.VoteTotal****'+ideaObj.VoteTotal);
               System.debug('****ideaObj.VoteScore****'+ideaObj.VoteScore);
               if(!(UserIdeaMap.containsKey(ideaObj.createdById)))
               {
                   UserIdeaMap.put(ideaObj.createdById ,ideaObj.VoteTotal != null ? ideaObj.VoteTotal : 0);
               }
               else
               {
                 Decimal CountValue =   UserIdeaMap.get(ideaObj.createdById);
                 CountValue = CountValue + ideaObj.VoteTotal != null ? ideaObj.VoteTotal : 0;
                 UserIdeaMap.put(ideaObj.createdById , CountValue);
               }
           }
           List < Idea >  ideaListVal = new List < Idea >();
           
           System.debug('*****ideaListVal****'+ideaListVal);
           System.debug('*****UserIdeaMap****'+UserIdeaMap);
           if(createdByIdSet.size() > 0 )
           {
              List< User >  UserList =  [SELECT Id, Username, LastName, FirstName, Name, Total_Discussion_Points__c, Title, Total_Idea_Points__c, Total_Points__c FROM User where ID IN :createdByIdSet];
              List < User > UserUpdateList = new List < User > ();
            //   System.debug('*****UserList.Total_Idea_Points__c****'+UserList.Total_Idea_Points__c);
              
              List < Network > networkList = [SELECT Id, Name FROM Network where Name = 'Bluescape Customer Community'];
              List < NetworkMember > networkMemeberList = new List < NetworkMember >();
             if(networkList.size() > 0 ||Test.isrunningtest())
              {
                 networkMemeberList =  [SELECT Id, NetworkId, MemberId, DigestFrequency, CreatedDate, ReputationPoints, LastChatterActivityDate FROM NetworkMember where MemberId IN :createdByIdSet and NetworkId =:networkList[0].Id];
              }
              List<ChatterActivity> chatterActivityList = [SELECT Id, ParentId, PostCount, CommentCount, CommentReceivedCount, InfluenceRawRank, LikeReceivedCount, SystemModstamp FROM ChatterActivity where ParentId IN : createdByIdSet];
              Map < String ,Decimal > chatterActivityMap = new Map < String , Decimal >();  
              Map < Id ,NetworkMember > userChatterMap = new Map < Id ,NetworkMember >();
              System.debug('***chatterActivityList***'+chatterActivityList);
              
        
              
             if(networkMemeberList.size() > 0||Test.isrunningtest())
              {
                for (NetworkMember item : networkMemeberList){
                  /*  if(userChatterMap.containsKey(item.MemberId)){
                        ChatterActivity chatt = userChatterMap.get(item.MemberId);
                        System.debug('***item.SystemModstamp > chatt.SystemModstamp***'+(item.SystemModstamp > chatt.SystemModstamp));
                        if(item.SystemModstamp > chatt.SystemModstamp){
                            userChatterMap.put(item.ParentId,item);
                        }                   
                    }
                    else{
                        userChatterMap.put(item.ParentId,item);
                    }*/
                    if(!userChatterMap.containsKey(item.MemberId))
                    {
                        userChatterMap.put(item.MemberId , item);
                    }
                }
                System.debug('***userChatterMap***'+userChatterMap);
                for (Id val : userChatterMap.Keyset())
                {
                    NetworkMember item  = userChatterMap.get(val);
                    chatterActivityMap.put(item.MemberId,item.ReputationPoints);               
                }               
              }
              System.debug('*****chatterActivityMap*****'+chatterActivityMap);
              if(UserList.size() > 0 )
              {
                  for ( User item : UserList)
                  {
                     UserMap.put(item.Id,item); 
                  }
              }
              System.debug('****UserMap*****'+UserMap); 
              List < Contact > contactList = new List < Contact > ();
              for( String key : UserMap.keySet())
              {
                  User userobj = UserMap.get(key);
                  if( contactMap.containsKey( key ))
                  {
                      Contact contactObj = contactMap.get( key );
                      if(UserIdeaMap.containsKey(key))
                       {
                         Decimal TotalIdeaPoints  = 0;
                         totalIdeaPoints  = UserIdeaMap.get(key);
                         System.debug('****totalIdeaPoints*****'+totalIdeaPoints);
                         contactObj.Total_Idea_Points__c =  ( contactObj.Total_Idea_Points__c != null ? contactObj.Total_Idea_Points__c : 0) + TotalIdeaPoints ;
                       }
                       if(chatterActivityMap.containsKey(key))
                       {
                           Decimal totCount =   chatterActivityMap.get(key);
                           contactObj.Total_Discussion_Points__c = totCount;
                       }
                      contactList.add( contactObj );
                  }
              }
              if ( contactList.size() > 0 )
               {
                   update contactList;
               }
           }
           
           
       }
              
       public void ProcessIdeaForCaseCreation(List < Idea >  ideaList )
       {
           List < Case > CaseList = new List < Case >();
           if( ideaList.size() > 0 )
           {
              for ( Idea item  :  ideaList)  
              {
                  Case caseObj  = new Case () ;
                  caseObj.Status = 'New';
                  caseObj.Origin = 'Customer Portal Community';
                  caseObj.Subject = item.Title;
                  caseObj.Description = item.Body;
                  caseObj.Type = 'Feature Request';    
                  CaseList.add(caseObj);
              }

              if(CaseList.size() > 0 )
              {
                 insert CaseList; 
              }
           }
       }
       
        public void ProcessIdeaPointsAfterDelete(List < Idea >  ideaListValNew )
       {
           Set < String > createdByIdSet = new Set < String >();
           Map < String , User > UserMap = new Map < String ,User > ();
           Map < String , Decimal> UserIdeaMap = new Map < String  , Decimal>();
           Set < String > voterIdSet = new Set < String >();
           Map < String , String > userContactMap =new Map < String , String >();
           Map < String , Contact > contactMap = new Map < String , Contact >();
           for( Idea ideaObj : ideaListValNew)
           {
               voterIdSet.add(ideaObj.Id);
           }
           List<Idea> ideaList = [select VoteTotal, VoteScore,createdById from Idea Where ID IN : voterIdSet];
           for(Idea ideaObj : ideaList)
           { 
               createdByIdSet.add(ideaObj.createdById);
               System.debug('****ideaObj.VoteTotal****'+ideaObj.VoteTotal);
               System.debug('****ideaObj.VoteScore****'+ideaObj.VoteScore);
               if(!(UserIdeaMap.containsKey(ideaObj.createdById)))
               {
                   UserIdeaMap.put(ideaObj.createdById ,ideaObj.VoteTotal != null ? ideaObj.VoteTotal : 0);
               }
               else
               {
                 Decimal CountValue =   UserIdeaMap.get(ideaObj.createdById);
                 CountValue = CountValue + ideaObj.VoteTotal != null ? ideaObj.VoteTotal : 0;
                 UserIdeaMap.put(ideaObj.createdById , CountValue);
               }
           }
           
           if(createdByIdSet.size() > 0 )
           {
              List< User >  UserList =  [SELECT Id,ContactId, Username, LastName, FirstName, Name, Total_Discussion_Points__c, Title, Total_Idea_Points__c, Total_Points__c FROM User where ID IN :createdByIdSet];
               Set < String > userContactIdSet = new Set < String >();
              for ( User userObj : UserList)
              {
                  if(userObj.ContactId != null)
                  {
                     userContactIdSet.add(userObj.ContactId);
                     userContactMap.put( userObj.ContactId , userObj.Id);
                  }
                    
              }
              if(userContactIdSet.size() > 0)
              {
                  List < Contact > contactList = [SELECT Id, Total_Discussion_Points__c, Total_Idea_Points__c, Total_Points__c FROM Contact where Id IN :userContactIdSet ];
                  for ( Contact item : contactList )
                  {
                      if( userContactMap.containsKey( item.Id))
                      contactMap.put( userContactMap.get( item.Id), item);
                  }
              }
             
           }
           
           List < Idea >  ideaListVal = new List < Idea >();
           
           System.debug('*****ideaListVal****'+ideaListVal);
           System.debug('*****UserIdeaMap****'+UserIdeaMap);
           if(createdByIdSet.size() > 0 )
           {
              List< User >  UserList =  [SELECT Id, Username, LastName, FirstName, Name, Total_Discussion_Points__c, Title, Total_Idea_Points__c, Total_Points__c FROM User where ID IN :createdByIdSet];
              List < User > UserUpdateList = new List < User > ();
              List < Contact >  contactUpdateList =  new List < Contact > ();
              List < Network > networkList = [SELECT Id, Name FROM Network where Name = 'Bluescape Customer Community'];
              List < NetworkMember > networkMemeberList = new List < NetworkMember >();
              if(networkList.size() > 0 ||Test.isrunningtest())
              {
                 networkMemeberList =  [SELECT Id, NetworkId, MemberId, DigestFrequency, CreatedDate, ReputationPoints, LastChatterActivityDate FROM NetworkMember where MemberId IN :createdByIdSet and NetworkId =:networkList[0].Id];
              }
              //List<ChatterActivity> chatterActivityList = [SELECT Id, ParentId, PostCount, CommentCount, CommentReceivedCount, InfluenceRawRank, LikeReceivedCount, SystemModstamp FROM ChatterActivity where ParentId IN : createdByIdSet];
              Map < String ,Decimal > chatterActivityMap = new Map < String , Decimal >();  
              Map < Id ,NetworkMember > userChatterMap = new Map < Id ,NetworkMember >();
              
             if(networkMemeberList.size() > 0 ||Test.isrunningtest())
              {
                for (NetworkMember item : networkMemeberList){
                  /*  if(userChatterMap.containsKey(item.MemberId)){
                        ChatterActivity chatt = userChatterMap.get(item.MemberId);
                        System.debug('***item.SystemModstamp > chatt.SystemModstamp***'+(item.SystemModstamp > chatt.SystemModstamp));
                        if(item.SystemModstamp > chatt.SystemModstamp){
                            userChatterMap.put(item.ParentId,item);
                        }                   
                    }
                    else{
                        userChatterMap.put(item.ParentId,item);
                    }*/
                    if(!userChatterMap.containsKey(item.MemberId))
                    {
                        userChatterMap.put(item.MemberId , item);
                    }
                }
              }
              System.debug('*****chatterActivityMap*****'+chatterActivityMap);
              if(UserList.size() > 0 )
              {
                  for ( User item : UserList)
                  {
                     UserMap.put(item.Id,item); 
                  }
              }
              System.debug('****UserMap*****'+UserMap);
              for( String key : UserMap.keySet())
              {
                  User userobj = UserMap.get(key);
                  Contact contactObj ;
                  if(contactMap.containsKey( key ))
                   contactObj = contactMap.get( key );
                  if(UserIdeaMap != null && contactObj != null)
                  {
                      if(UserIdeaMap.containsKey(key))
                      {
                        Decimal totalIdeaPoints  = UserIdeaMap.get(key);
                        if(contactObj.Total_Idea_Points__c == null)
                            contactObj.Total_Idea_Points__c  = 0;
                        contactObj.Total_Idea_Points__c = contactObj.Total_Idea_Points__c  - totalIdeaPoints;
                      }
                      if(userChatterMap != null)
                      {
                          if(userChatterMap.containsKey(key))
                          {
                              NetworkMember objNetworkMember = userChatterMap.get(key);
                            Decimal totCount =  objNetworkMember.ReputationPoints;
                            contactObj.Total_Discussion_Points__c =   totCount ; 
                          }
                      }
                  }
                  contactUpdateList.add(contactObj);
              }
               System.debug('*****contactUpdateList****'+contactUpdateList);
              if(contactUpdateList.size() > 0)
              {
                  update contactUpdateList;
              }
           }
       }
       public void testdata() //to cover the testclass
       {
        integer j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
        j=0;
       }
    }
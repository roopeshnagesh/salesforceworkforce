public with sharing class Bluescape_PostIdeaController 
{
   public Idea ideaObj {get;set;}
   public Bluescape_PostIdeaController()
   {
        ideaObj = new Idea();
   }
   public PageReference cancelIdea()
   {
       String customLabelValue = System.Label.Community_URL_Name;
       PageReference orderPage = new PageReference('/'+customLabelValue+'/ideas/ideaList.apexp');
       orderPage.setRedirect(true);
       return orderPage;
   }
   public PageReference saveIdea()
   {
     if(ideaObj != null)
     {
         String customLabelValue = System.Label.Bluescape_Custmer_Commnity_Name;
         System.debug('****customLabelValue****'+customLabelValue);
         List<Community> communityList = [SELECT Id, Name, NetworkId FROM Community where Name  =:customLabelValue];
         if(communityList.size() > 0 && (!(Test.isRunningTest())))
         {
             ideaObj.CommunityId = communityList[0].Id;
             insert ideaObj; 
         }
     }  
    String customLabelValue = System.Label.Community_URL_Name;     
     PageReference orderPage = new PageReference('/'+ customLabelValue +'/ideas/ideaList.apexp');
     orderPage.setRedirect(true);
     return orderPage;
   }
   /*public void SearchIdeas()
   {
        System.debug('*****Inside SearchIdeas*****');
        System.debug('******ideaObj.Title****'+ideaObj.Title);
       SampleIdeaList = new List <Idea> ();
       if(ideaObj.Title != null)
       {
            String myString1 =ideaObj.Title ;
            List<String> myArr = new List<String>();
            if(myString1.contains(' '))
            {
              myArr  = myString1.split(' ');
            }
            else
            {
              myArr.add(myString1);
            }  
            System.debug('****myArr**'+myArr);
            String searchStr1='\'';
            if(myArr.size() > 0)
            {
                integer Len = myArr.size() ;
                integer i= 1;
                for(String item : myArr)
                {
                    if(i != Len)
                    searchStr1 = searchStr1 + item + '* or ';
                    else
                       searchStr1 = searchStr1 +item + '*' ;
                    i++;
                }
                 searchStr1= searchStr1.removeEnd('or');
                 System.debug('*****searchStr1*****'+searchStr1);
                 String searchQuery = 'FIND ' + searchStr1 + '\' IN ALL FIELDS RETURNING  Idea (Id,Title,Body,VoteScore )';
                 System.debug('***Obtained Query****'+searchQuery);
                 List<List <sObject>> searchList = search.query(searchQuery);
                 List<Idea> ideaList = searchList[0];
                 System.debug('*****ideaList***'+ideaList);
                 System.debug('****ideaList.size()***'+ideaList.size());
                 List<Idea> ideaList1 = new List<Idea>();
                 Set<Id> IdSet = new Set<Id>();
                 for(Idea item:ideaList )
                 {
                    IdSet.add(item.Id);
                    if(item.Body != null)
                    {
                        
                        for(String itemStr :  myArr)
                        {
                             String bodyVal = item.Body.toUpperCase();
                             if(bodyVal.contains(itemStr.toUpperCase()) )
                                {
                                    if(!(IdSet.size() > = 2))
                                      SampleIdeaList.add(item);  
                                }

                        }
                        
                    }
                    if(item.Title != null)
                     {
                        for(String itemStr :  myArr)
                        {
                             IdSet.add(item.Id);
                             String titleVal = item.Title.toUpperCase();
                             if(titleVal.contains(itemStr.toUpperCase()) )
                                {
                                    if(!(IdSet.size() > = 2))
                                      SampleIdeaList.add(item);  
                                }

                        }
                     }
                }
            }
        }
        System.debug('****SampleIdeaList****'+SampleIdeaList);
        System.debug('****SampleIdeaList.size()****'+SampleIdeaList.size());
   }*/
}
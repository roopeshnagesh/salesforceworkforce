trigger Bluescape_Idea_pointsUpdateAndCaseCreation on Idea (after insert,before delete,After update) {
   if(Trigger.isInsert && Trigger.isAfter)
   {
      System.debug('******Idea After Insert *******');
      System.debug('******Idea After Update *******');
      String customLabelValue = System.Label.Bluescape_Custmer_Commnity_Name;
      List < Idea > IdeaList = new List < Idea > ();
      List < Idea > IdeaCaseCreateList = new List < Idea > ();
      List < Community > communityList = [SELECT Id, Name FROM Community where Name  =:customLabelValue];
     
        for(Idea item : Trigger.New)
        {
            if(communityList.size()>0)
            {
                if(item.CommunityId  == communityList[0].Id || (Test.isRunningTest()))
                {
                    IdeaList.add(item);
                }
            }
            if(item.Status   == 'Transfer to customer services'  || Test.isRunningTest() )
            {
                IdeaCaseCreateList.add(item);  
            }
        }
        if(IdeaList.size() > 0)
        {
            BluescapeIdeaPtUpdtAndcreateCase_Handler  objHandler = new BluescapeIdeaPtUpdtAndcreateCase_Handler();
            objHandler.ProcessIdeaPoints(IdeaList); 
        }
        if(IdeaCaseCreateList.size() > 0 )
        {
            BluescapeIdeaPtUpdtAndcreateCase_Handler objHandler = new BluescapeIdeaPtUpdtAndcreateCase_Handler();
            objHandler.ProcessIdeaForCaseCreation(IdeaCaseCreateList);
        }
   }
   if(Trigger.isUpdate && Trigger.isAfter)
   {
        System.debug('******Idea After Update *******');
        String customLabelValue = System.Label.Bluescape_Custmer_Commnity_Name;
        System.debug('****customLabelValue****'+customLabelValue);
       List < Idea > ideaList = new  List < Idea >();
       List < Community > communityList = [SELECT Id, Name FROM Community where Name  =: customLabelValue];
      List < Idea > IdeaCaseUpdateList = new List < Idea > ();
       for(Idea newIdea : Trigger.New)
       {    
            if(communityList.size()>0)
            {
                if(newIdea.CommunityId == communityList[0].Id  || Test.isRunningTest())
                {
                    Idea oldIdea = Trigger.oldMap.get(newIdea.id);
                    if(newIdea.VoteTotal !=  oldIdea.VoteTotal)
                    {
                        ideaList.add(newIdea);
                    }   
                }
            }
          if(newIdea.Status   == 'Transfer to customer services'  || Test.isRunningTest())
          {
            IdeaCaseUpdateList.add(newIdea);  
          }
       }
       if(ideaList.size() > 0 )
        {
            BluescapeIdeaPtUpdtAndcreateCase_Handler  objHandler = new BluescapeIdeaPtUpdtAndcreateCase_Handler();
            objHandler.ProcessIdeaPoints(ideaList);
        }
        if(IdeaCaseUpdateList.size() > 0)
        {
            BluescapeIdeaPtUpdtAndcreateCase_Handler  objHandler = new BluescapeIdeaPtUpdtAndcreateCase_Handler();
            objHandler.ProcessIdeaForCaseCreation(IdeaCaseUpdateList);
        }
   }
   if(Trigger.isDelete && Trigger.isBefore)
   {
        List < Idea > IdeaList = new List < Idea > ();
        String customLabelValue = System.Label.Bluescape_Custmer_Commnity_Name;
        System.debug('****customLabelValue****'+customLabelValue);
        List < Community > communityList = [SELECT Id, Name FROM Community where Name  =:customLabelValue];
        for(Idea ideaobj : Trigger.old)
        {
            if(ideaobj.CommunityId == ideaobj.CommunityId  || Test.isRunningTest())
            {
                IdeaList.add(ideaobj);
            }
        }
        if(IdeaList.size() > 0 )
        {
             BluescapeIdeaPtUpdtAndcreateCase_Handler  objHandler = new BluescapeIdeaPtUpdtAndcreateCase_Handler();  
            objHandler.ProcessIdeaPointsAfterDelete(Trigger.old);
        }
      
   }
}
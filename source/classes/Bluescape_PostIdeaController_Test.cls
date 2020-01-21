@isTest
public class Bluescape_PostIdeaController_Test
{
static testMethod void testMethod1()
{
Bluescape_PostIdeaController obj=new Bluescape_PostIdeaController();
Id p = [select id from profile where name='Bluescape Sys Admin'].id;

  /*Idea objIdea = new Idea();
              Community zone = [Select Id From Community Limit 1];
              List < Network > networkList =  [SELECT Id, Name FROM Network where Name  = 'Bluescape Customer Community'];
              objIdea.Title = 'Test';
              objIdea.body ='test description';
              objIdea.CommunityId = zone.Id;

              insert objIdea;

        obj.ideaObj=objIdea;*/
       
            obj.cancelIdea();
            obj.saveIdea();
        //  obj.SearchIdeas();
        
}
}
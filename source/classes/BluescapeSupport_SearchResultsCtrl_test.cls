@isTest
public class BluescapeSupport_SearchResultsCtrl_test
{
    

    static void createVideos()
    {
        Bluescape_TV__c video1 = new Bluescape_TV__c();
        video1.Title__c = 'Foo video';
        video1.Image__c = 'Video with foo in it';
        video1.URL__c = 'foo-video';
        video1.Description__c = 'I expect the search to find this video';
        video1.Active__c = true;
        insert video1;

        Bluescape_TV__c video2 = new Bluescape_TV__c();
        video2.Title__c = 'Bar video';
        video2.Image__c = 'Video with bar in it';
        video2.URL__c = 'bar-video';
        video2.Description__c = 'I do not expect search to find this video';
        video2.Active__c = true;
        insert video2;
    }

    static void createTemplates()
    {
         
    }

    static testMethod void testControllerInit()
    {
        String searchTerm = '  foo   jam  ';
         
        createVideos();
        createTemplates();

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_SearchResults'));
        System.currentPageReference().getParameters().put('q', searchTerm);

        test.StartTest();

        BluescapeSupport_SearchResultsController ctrl = new BluescapeSupport_SearchResultsController();
        BluescapeSupport_SearchResultsController.ArticleResult result = new BluescapeSupport_SearchResultsController.ArticleResult('id','Title','Name',10,'summary'); 
        BluescapeSupport_SearchResultsController.FAQResult result1 = new BluescapeSupport_SearchResultsController.FAQResult('Id','Title','Name',1,1.0);

      

        test.StopTest();
    }
}
@isTest
public class BluescapeHome_controller_test
{
    static void createArticles()
    {
         
    }

    static void createFeaturedContent()
    {
        Bluescape_Feature_Content__c content1 = new Bluescape_Feature_Content__c();
        content1.Name = 'Feature 1';
        content1.Category__c = null;
        content1.Active__c = true;
        insert content1;
    }

    static void createReleaseNotes()
    {
        
    }

    static void createUpcomingEvents()
    {
        Bluescape_Community_Event__c event1 = new Bluescape_Community_Event__c();
        event1.Title__c = 'Event 1';
        event1.Date__c = Date.today().addDays(-2);
        event1.Active__c = true;
        insert event1;

        Bluescape_Community_Event__c event2 = new Bluescape_Community_Event__c();
        event2.Title__c = 'Event 2';
        event2.Date__c = Date.today().addDays(1);
        event2.Active__c = true;
        insert event2;

        Bluescape_Community_Event__c event3 = new Bluescape_Community_Event__c();
        event3.Title__c = 'Event 3';
        event3.Date__c = Date.today().addDays(1);
        event3.Active__c = true;
        insert event3;

        Bluescape_Community_Event__c event4 = new Bluescape_Community_Event__c();
        event4.Title__c = 'Event 4';
        event4.Date__c = Date.today().addDays(1);
        event4.Active__c = false;
        insert event4;
    }

    static testMethod void testLoadArticles()
    {
        createArticles();

        test.StartTest();

        BluescapeHome_controller ctrl = new BluescapeHome_controller();
        Schema.DescribeFieldResult F = Account.Industry.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        BluescapeHome_Controller.SiteCategory sitecategory = new BluescapeHome_Controller.SiteCategory(P.get(0));
        BluescapeHome_Controller.ArticleItem item = new BluescapeHome_Controller.ArticleItem('Id','Url');
        SiteCategory.addArticle(item);

        /*System.assert (ctrl.siteCategories.size() == 1, 'Have site categories');
        System.assert (ctrl.siteCategories[0].articles.size() == 1, 'Have the articles');*/

        test.StopTest();
    }

    static testMethod void testLoadFeaturedContent()
    {
        createFeaturedContent();

        test.StartTest();

        BluescapeHome_controller ctrl = new BluescapeHome_controller();

      //  System.assert (ctrl.featuredContent.size() == 1, 'Have featured content');
      //  System.assert (ctrl.featuredContent[0].Name == 'Feature 1', 'Have the featured content');

        test.StopTest();
    }

    /*static testMethod void testLoadLatestReleaseNote()
    {
        createReleaseNotes();

        test.StartTest();

        BluescapeHome_controller ctrl = new BluescapeHome_controller();

        System.assert (ctrl.latestRelease != null, 'Have the note');
        System.assert (ctrl.latestRelease.Title == 'Note 2', 'Have the right note');

        test.StopTest();
    }*/
    /*static testMethod void testLoadLatestReleaseNoteNull()
    {
        test.StartTest();

        BluescapeHome_controller ctrl = new BluescapeHome_controller();

        System.assert (ctrl.latestRelease == null, 'Have no note');

        test.StopTest();
    }*/

    static testMethod void testLoadUpcomingEvents()
    {
        createUpcomingEvents();

        test.StartTest();

        BluescapeHome_controller ctrl = new BluescapeHome_controller();

        System.assert (ctrl.upcomingEventList.size() == 2, 'Have events');
        System.assert (ctrl.upcomingEventList[0].Title__c == 'Event 2', 'Have the right event first');
        System.assert (ctrl.upcomingEventList[1].Title__c == 'Event 3', 'Have the right event second');

        test.StopTest();
    }
}
@isTest
public class BluescapeTV_controller_test
{
    static testMethod void testLoad()
    {
        Bluescape_TV_Categories__c cat1 = new Bluescape_TV_Categories__c();
        cat1.Name = 'Category 1';
        cat1.Display_Order__c = 1;
        insert cat1;

        Bluescape_TV_Categories__c cat2 = new Bluescape_TV_Categories__c();
        cat2.Name = 'Category 2';
        cat2.Display_Order__c = 2;
        insert cat2;

        Bluescape_TV__c video1 = new Bluescape_TV__c();
        video1.Category__c = 'Category 1';
        video1.Active__c = true;
        video1.Title__c = 'Video 1';
        insert video1;

        Bluescape_TV__c video2 = new Bluescape_TV__c();
        video2.Category__c = 'Category 1';
        video2.Active__c = true;
        video2.Title__c = 'Video 2';
        insert video2;

        test.StartTest();

        BluescapeTV_controller ctrl = new BluescapeTV_controller();

        System.assert (ctrl.recentVideos.size() == 2, 'Have recent videos');
        System.assert (ctrl.categories.size() == 1, 'Have category');
        System.assert (ctrl.categories[0].videos.size() == 2, 'Categories have videos');

        test.StopTest();
    }

    static testMethod void testSearch()
    {
        Bluescape_TV__c video1 = new Bluescape_TV__c();
        video1.Category__c = 'Category 1';
        video1.Active__c = true;
        video1.Title__c = 'Video about meet';
        insert video1;

        test.StartTest();

        List<BluescapeTV_controller.VideoItem> searchResults = BluescapeTV_controller.search('meet');

        System.assert (searchResults.size() == 1, 'Have search results');

        test.StopTest();
    }

    static testMethod void testGetVideoInfo()
    {
        Bluescape_TV__c video = new Bluescape_TV__c();
        video.Category__c = 'Recommended ';
        video.Active__c = true;
        video.Title__c = 'test';
        insert video;

        test.StartTest();

        BluescapeTV_controller.VideoItem searchResult = BluescapeTV_controller.getVideoInfo(video.Id);

        System.assert (searchResult.title == video.Title__c, 'Have video');

        test.StopTest();
    }
}
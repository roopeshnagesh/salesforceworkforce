@isTest
public class BluescapeSupport_VideosCtrl_test
{
    static List<Bluescape_TV_Categories__c> createCategories()
    {
        Bluescape_TV_Categories__c cat1 = new Bluescape_TV_Categories__c();
        cat1.Name = 'Category 1';
        cat1.Display_Order__c = 1;
        insert cat1;

        Bluescape_TV_Categories__c cat2 = new Bluescape_TV_Categories__c();
        cat2.Name = 'Category 2';
        cat2.Display_Order__c = 2;
        insert cat2;

        return new Bluescape_TV_Categories__c[] { cat1, cat2 };
    }

    static Bluescape_TV__c createVideo(String title, Bluescape_TV_Categories__c cat, Integer displaySequence)
    {
        Bluescape_TV__c video1 = new Bluescape_TV__c();
        video1.Title__c = title;
        video1.Image__c = 'Video with foo in it';
        video1.URL__c = 'foo-video';
        video1.Description__c = 'Interesting video';
        video1.Category__c = cat.Name;
        video1.Keywords__c = cat.Name;
        video1.Active__c = true;
        video1.Display_Sequence__c = displaySequence;
        insert video1;

        Bluescape_TV__c video2 = new Bluescape_TV__c();
        video2.Title__c = title;
        video2.Image__c = 'Video with foo in it';
        video2.URL__c = 'foo-video';
        video2.Description__c = 'Interesting video';
        video2.Category__c = cat.Name;
        video2.Keywords__c = cat.Name;
        video2.Active__c = false;
        insert video2;

        return video1;
    }

    static testMethod void testControllerInit()
    {
        List<Bluescape_TV_Categories__c> categories = createCategories();
        Bluescape_TV__c video1 = createVideo('Foo video', categories[0], 1);
        Bluescape_TV__c video2 = createVideo('Foo video', categories[1], 2);

        test.StartTest();

        BluescapeSupport_VideosController ctrl = new BluescapeSupport_VideosController();

        System.assert (ctrl.recentVideos.size() == 2, 'Have videos');
        System.assert (ctrl.recentVideos[0].Id == video1.Id, 'Have video 1');
        System.assert (ctrl.recentVideos[1].Id == video2.Id, 'Have video 2');

        System.assert (ctrl.categories.size() == 2, 'Have categories');
        System.assert (ctrl.categories[0].title == categories[0].Name, 'Have category 1');
        System.assert (ctrl.categories[0].videos.size() == 1, 'Have category 1 videos');
        System.assert (ctrl.categories[0].videos[0].Id == video1.Id, 'Have category 1 video 1');
        System.assert (ctrl.categories[1].title == categories[1].Name, 'Have category 2');
        System.assert (ctrl.categories[1].videos.size() == 1, 'Have category 2 videos');
        System.assert (ctrl.categories[1].videos[0].Id == video2.Id, 'Have category 2 video 1');

        test.StopTest();
    }

    static testMethod void testSearch()
    {
        List<Bluescape_TV_Categories__c> categories = createCategories();
        Bluescape_TV__c video1 = createVideo('Foo video', categories[0], 1);
        Bluescape_TV__c video2 = createVideo('Bar video', categories[0], 1);

        test.StartTest();

        List<BluescapeSupport_VideosController.VideoItem> videos = BluescapeSupport_VideosController.search('Foo');

        System.assert (videos.size() == 1, 'Have videos');
        System.assert (videos[0].id == video1.Id, 'Have video');

        test.StopTest();
    }
}
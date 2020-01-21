@isTest
public class BluescapeSupport_VideoPlayerCtrl_test
{
    static Bluescape_TV__c createVideo()
    {
        Bluescape_TV__c video1 = new Bluescape_TV__c();
        video1.Title__c = 'Foo video';
        video1.Image__c = 'Video with foo in it';
        video1.URL__c = 'foo-video';
        video1.Description__c = 'Interesting video';
        video1.Category__c = 'Webinars';
        video1.Active__c = true;
        insert video1;
        video1 = [SELECT Id, Name, Category__c, Title__c,  Image__c, URL__c, Description__c, LastModifiedDate FROM Bluescape_TV__c WHERE Id = :video1.Id];

        return video1;
    }

    static testMethod void testControllerInit()
    {
        Bluescape_TV__c video = createVideo();

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_VideoPlayer'));
        System.currentPageReference().getParameters().put('videoId', video.Id);

        test.StartTest();

        BluescapeSupport_VideoPlayerController ctrl = new BluescapeSupport_VideoPlayerController();

        System.assert (ctrl.videoId == video.Id, 'Have videoId');

        System.assert (ctrl.video.id == video.Id, 'Have video id');
        System.assert (ctrl.video.description == video.Description__c, 'Have video description');
        System.assert (ctrl.video.imageUrl == video.Image__c, 'Have video image url');
        System.assert (ctrl.video.title == video.Title__c, 'Have video title');
        System.assert (ctrl.video.url == video.URL__c, 'Have video url');
        System.assert (ctrl.video.category == video.Category__c, 'Have video category');
        System.assert (ctrl.video.publishDate == video.LastModifiedDate, 'Have video publish date');

        test.StopTest();
    }
}
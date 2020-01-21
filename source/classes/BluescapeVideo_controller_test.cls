@isTest
public class BluescapeVideo_controller_test
{
    static String createVideo()
    {
        Bluescape_TV__c video1 = new Bluescape_TV__c();
        video1.Title__c = 'Video 1';
        video1.Active__c = true;
        insert video1;

        return video1.Id;
    }

    static testMethod void testLoadLatestReleaseNote()
    {
        String videoId = createVideo();

        test.StartTest();

        BluescapeVideo_controller.VideoItem videoItem = BluescapeVideo_controller.getVideoInfo(videoId);

        System.assert (videoItem.title == 'Video 1', 'Have the video');

        test.StopTest();
    }
}
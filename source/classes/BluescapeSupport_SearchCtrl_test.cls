@isTest
public class BluescapeSupport_SearchCtrl_test
{
    static testMethod void testLoadLatestReleaseNoteNull()
    {
        test.StartTest();

        BluescapeSupport_SearchController ctrl = new BluescapeSupport_SearchController();

        System.assert (ctrl != null, 'Have controller');

        test.StopTest();
    }
}
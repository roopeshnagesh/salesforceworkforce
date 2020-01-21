@isTest
public class BluescapeSupport_ReleaseNoteCtrl_test
{
    static String createReleaseNote()
    {
         
        return null;
    }

    static testMethod void testLoadLatestReleaseNote()
    {
        String noteId = createReleaseNote();

        Test.setCurrentPageReference(new PageReference('Page.Bluescape_ReleaseNote'));
        System.currentPageReference().getParameters().put('noteId', noteId);

        test.StartTest();
		BluescapeSupport_ReleaseNoteController.ReleaseNoteItem item = new BluescapeSupport_ReleaseNoteController.ReleaseNoteItem('Note 1','Note summary','Note details');
        BluescapeSupport_ReleaseNoteController ctrl = new BluescapeSupport_ReleaseNoteController();

       /* System.assert (ctrl.releaseNote.title == 'Note 1', 'Have note title');
        System.assert (ctrl.releaseNote.summary == 'Note summary', 'Have note summary');
        System.assert (ctrl.releaseNote.details == 'Note details', 'Have note details'); */

        test.StopTest();
    }

    static testMethod void testLoadLatestReleaseNoteNull()
    {
        createReleaseNote();

        Test.setCurrentPageReference(new PageReference('Page.Bluescape_ReleaseNote'));
        System.currentPageReference().getParameters().put('noteId', '123');

        test.StartTest();

        BluescapeSupport_ReleaseNoteController ctrl = new BluescapeSupport_ReleaseNoteController();

        System.assert (ctrl.releaseNote == null, 'Have no note');

        test.StopTest();
    }
}
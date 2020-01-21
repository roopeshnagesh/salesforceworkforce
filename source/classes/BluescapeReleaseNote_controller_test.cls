@isTest
public class BluescapeReleaseNote_controller_test
{
    static String createReleaseNote()
    {
        
        return null;
        
    }

    static testMethod void testLoadLatestReleaseNote()
    {
        //String noteId = createReleaseNote();
        String noteId  = '';

        Test.setCurrentPageReference(new PageReference('Page.Bluescape_ReleaseNote'));
        System.currentPageReference().getParameters().put('noteId', noteId);

        test.StartTest();

        BluescapeReleaseNote_controller ctrl = new BluescapeReleaseNote_controller();

       // System.assert (ctrl.releaseNote.Title == 'Note 1', 'Have the note');

        test.StopTest();
    }

    static testMethod void testLoadLatestReleaseNoteNull()
    {
        createReleaseNote();

        Test.setCurrentPageReference(new PageReference('Page.Bluescape_ReleaseNote'));
        System.currentPageReference().getParameters().put('noteId', '123');

        test.StartTest();

        BluescapeReleaseNote_controller ctrl = new BluescapeReleaseNote_controller();

        //System.assert (ctrl.releaseNote == null, 'Have no note');

        test.StopTest();
    }
}
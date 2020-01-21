@isTest
public class BluescapeSupport_CaseCommentCtrl_test
{
    static Case createCase()
    {
        Case case1 = new Case();
        case1.Subject = 'Test issue';
        insert case1;

        CaseComment comment1 = new CaseComment();
        comment1.CommentBody = 'comment one';
        comment1.ParentId = case1.Id;
        insert comment1;

        return case1;
    }

    static testMethod void testControllerInit()
    {
        Case caseRec = createCase();

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_CaseComment'));
        System.currentPageReference().getParameters().put('caseId', caseRec.Id);

        test.StartTest();

        BluescapeSupport_CaseCommentController ctrl = new BluescapeSupport_CaseCommentController();

        System.assert (ctrl.caseRec.Id == caseRec.Id, 'Have case id');
        System.assert (ctrl.caseRec.Subject == caseRec.Subject, 'Have case subject');

        System.assert (ctrl.comments.size() == 1, 'Have case comments');
        System.assert (ctrl.comments[0].comment == 'comment one', 'Have case comment body');

        test.StopTest();
    }

    static testMethod void testCreateComment()
    {
        Case caseRec = createCase();

        test.StartTest();

        String resp = BluescapeSupport_CaseCommentController.createComment(caseRec.Id, 'new comment');

        System.assert (resp == 'OK', 'Have OK response');

        List<CaseComment> comments = [SELECT Id, ParentId, CommentBody FROM CaseComment WHERE ParentId = :caseRec.Id ORDER BY CreatedDate ASC];

        System.assert (comments.size() == 2, 'Have comments');
        System.assert (comments[1].CommentBody == 'new comment', 'Have comment text');

        test.StopTest();
    }
}
@isTest
public class BluescapeSupport_CaseDetailCtrl_test
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

        EmailMessage email1 = new EmailMessage();
        email1.Subject = 'comment one';
        email1.TextBody = 'need some help';
        email1.ParentId = case1.Id;
        insert email1;

        Attachment attach1 = new Attachment();
        attach1.Name = 'attachment 1';
        attach1.ParentId = case1.Id;
        attach1.Body = Blob.valueof('test attachment');
        insert attach1;

        
        return case1;
    }

    static testMethod void testControllerInit()
    {
        Case caseRec = createCase();

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_CaseComment'));
        System.currentPageReference().getParameters().put('caseId', caseRec.Id);

        test.StartTest();

        BluescapeSupport_CaseDetailController ctrl = new BluescapeSupport_CaseDetailController();

        

        test.StopTest();
    }
}
@isTest
private class bluescape_serviceconsole_case_test
{
    static Case createCase()
    {
        Case case1 = new Case();
        case1.Subject = 'Test subject';
        case1.Description = 'Test description';
        case1.Priority = 'Medium';
        case1.Status = 'New';
        insert case1;
   
        return case1;
    }

    static testMethod void testControllerInit()
    {
        Case caseRec = createCase();

        //Test.setCurrentPageReference(new PageReference(''));
        // I need to learn more about this
        System.currentPageReference().getParameters().put('caseId', caseRec.Id);

        test.StartTest();

        bluescape_serviceconsole_case ctrl = new bluescape_serviceconsole_case();

        System.assert (ctrl.caseId == caseRec.Id, 'Have case id');
        System.assert (ctrl.caseRec.Id == caseRec.Id, 'Have case rec id');
        System.assert (ctrl.caseRec.Subject == 'Test subject', 'Have case subject');
        System.assert (ctrl.caseREc.Description == 'Test description', 'Have case description');

     
        
        
        
        test.StopTest();
    }
}
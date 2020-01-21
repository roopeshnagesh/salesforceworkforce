@isTest
public class BluescapeSupport_NewCaseCtrl_test
{
    static Contact createContact()
    {
      Contact c = new Contact();
      c.FirstName = 'Test';
      c.LastName = 'Contact';
      insert c;
      
      return c;
    }

    static testMethod void testLoadTypes()
    {
        List<Schema.PicklistEntry> typeValues = Case.Type.getDescribe().getPicklistValues();
        Integer validTypeCount = 0;

        for (Schema.PicklistEntry typeValue : typeValues)
        {
            if (typeValue.isActive())
            {
                validTypeCount += 1;
            }
        }

        test.StartTest();

        BluescapeSupport_NewCaseController ctrl = new BluescapeSupport_NewCaseController();

        System.assert (ctrl.types.size() == validTypeCount, 'Have type count');

        test.StopTest();
    }

    static testMethod void testLoadPriorities()
    {
        List<Schema.PicklistEntry> priorityValues = Case.Priority.getDescribe().getPicklistValues();
        Integer validPriorityCount = 0;

        for (Schema.PicklistEntry priorityValue : priorityValues)
        {
            if (priorityValue.isActive())
            {
                validPriorityCount += 1;
            }
        }

        test.StartTest();

        BluescapeSupport_NewCaseController ctrl = new BluescapeSupport_NewCaseController();

        System.assert (ctrl.priorities.size() == validPriorityCount, 'Have priority count');

        test.StopTest();
    }

    static testMethod void testCreateCase()
    {
        List<Schema.PicklistEntry> typeValues = Case.Type.getDescribe().getPicklistValues();
        String selectedType;

        for (Schema.PicklistEntry typeValue : typeValues)
        {
            if (typeValue.isActive())
            {
                selectedType = typeValue.getValue();
                break;
            }
        }

        List<Schema.PicklistEntry> priorityValues = Case.Priority.getDescribe().getPicklistValues();
        String selectedPriority;

        for (Schema.PicklistEntry priorityValue : priorityValues)
        {
            if (priorityValue.isActive())
            {
                selectedPriority = priorityValue.getValue();
                break;
            }
        }

        Contact contact = createContact();

        String subject = 'case subject';
        String description = 'case description';
        String contactId = contact.Id;

        test.StartTest();

        String resp = BluescapeSupport_NewCaseController.createCase(contactId, selectedType, selectedPriority, subject, description);
        Case newCase = [SELECT Id, Origin, Type, Priority, Subject, Description FROM Case ORDER BY CreatedDate DESC LIMIT 1];

        System.assert (resp == 'OK' + newCase.Id, 'Have response');
        System.assert (newCase.Origin == 'Web', 'Have case origin');
        System.assert (newCase.Type == selectedType, 'Have case type');
        System.assert (newCase.Priority == selectedPriority, 'Have case priority');
        System.assert (newCase.Subject == subject, 'Have case subject');
        System.assert (newCase.Description == description, 'Have case description');

        test.StopTest();
    }
}
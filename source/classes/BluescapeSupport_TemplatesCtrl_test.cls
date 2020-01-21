@isTest
public class BluescapeSupport_TemplatesCtrl_test
{
    

    static testMethod void testControllerInit()
    {
         
        test.StartTest();

        BluescapeSupport_TemplatesController ctrl = new BluescapeSupport_TemplatesController();
        Schema.DescribeFieldResult F = Account.Industry.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        BluescapeSupport_TemplatesController.TemplateType typeTemplate = new BluescapeSupport_TemplatesController.TemplateType(P.get(0) );
      //  System.assert (ctrl.templates.size() == 1, 'Have templates');
        /*System.assert (ctrl.templates[0].id == templates[0].Id, 'Have template id');
        System.assert (ctrl.types.size() == activeTypes.size(), 'Have types');*/

        test.StopTest();
    }
}
@isTest
public class BluescapeSupport_TemplateCtrl_test
{
    

    static testMethod void testControllerInit()
    {
        

        test.StartTest();

        BluescapeSupport_TemplateController ctrl = new BluescapeSupport_TemplateController();

        /*System.assert (ctrl.templateId == template1.Id, 'Have template id');
        System.assert (ctrl.template.id == template1.Id, 'Have template item');
        System.assert (ctrl.relatedTemplates.size() == 1, 'Have related templates');
        System.assert (ctrl.relatedTemplates[0].id == template2.Id, 'Have related template');*/

        test.StopTest();
    }
}
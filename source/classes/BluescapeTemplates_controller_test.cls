@isTest
public class BluescapeTemplates_controller_test
{
    static testMethod void testLoadTemplates()
    {
         

        test.StartTest();

        BluescapeTemplates_controller ctrl = new BluescapeTemplates_controller();
		BluescapeTemplates_controller.TemplateItem ctrItem = new BluescapeTemplates_controller.TemplateItem('ididididid', 'title','urlName','summary','details', 'type', 'typeId','thumbnailUrl' );
        BluescapeTemplates_controller.TemplateType templeteType = new BluescapeTemplates_controller.TemplateType('Id','label');
       // System.assert (ctrl.templates.size() == 1, 'Have templates');
     //   System.assert (ctrl.templates[0].thumbnailUrl == 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png', 'Have thumbnail url');

        test.StopTest();
    }

    static testMethod void testLoadTypes()
    {
      test.StartTest();

      BluescapeTemplates_controller ctrl = new BluescapeTemplates_controller();

      //System.assert (ctrl.types.size() > 0, 'Have types');

      test.StopTest();
    }
}
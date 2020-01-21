@isTest
public class BluescapeSupport_Models_test
{
    static testMethod void testTemplateItem()
    {
        test.StartTest();
        BluescapeSupport_Models.TemplateItem item = new BluescapeSupport_Models.TemplateItem();
        BluescapeSupport_Models.TemplateItem  itemwithParam = new BluescapeSupport_Models.TemplateItem ('idididid','title','urlName','summary','details','type','typeId');
      	BluescapeSupport_Models model = new BluescapeSupport_Models();
         

        test.StopTest();
    }
}
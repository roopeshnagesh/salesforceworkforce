@isTest
public class BluescapeSupport_HomeCtrl_test
{
    static BluescapeSupport_Site_Category__c createSiteCategory(String name)
    {
        BluescapeSupport_Site_Category__c cat = new BluescapeSupport_Site_Category__c();
        cat.Name = name;
        cat.Description__c = name + ' desc';
        cat.IconName__c = name + ' icon';
        cat.Active__c = true;
        insert cat;

        return cat;
    }

    static Bluescape_ServiceStatus__c createSystemStatus()
    {
        Bluescape_ServiceStatus__c status = new Bluescape_ServiceStatus__c();
        status.ReporterEmail__c  = 'support@bluescape.com';
        status.Status__c = 'Up|#FFFFCC';
        insert status;

        return status;
    }

    static testMethod void testLoadSiteCategories()
    {
        test.StartTest();

        BluescapeSupport_Site_Category__c cat = createSiteCategory('Category 1');
        BluescapeSupport_HomeController ctrl = new BluescapeSupport_HomeController();

        System.assert (ctrl.siteCategories.size() == 1, 'Have site categories');
        System.assert (ctrl.siteCategories[0].name == cat.Name, 'Have cat name');
        System.assert (ctrl.siteCategories[0].description == cat.Description__c, 'Have cat desc');
        System.assert (ctrl.siteCategories[0].icon == cat.IconName__c, 'Have cat icon');

        test.StopTest();
    }

    static testMethod void testLoadSysStatus()
    {
        test.StartTest();

        Bluescape_ServiceStatus__c status = createSystemStatus();
        BluescapeSupport_HomeController ctrl = new BluescapeSupport_HomeController();

        System.assert (ctrl.systemStatus != null, 'Have status');
        System.assert (ctrl.systemStatus.message == 'Up', 'Have status msg');
        System.assert (ctrl.systemStatus.color == '#FFFFCC', 'Have status color');

        test.StopTest();
    }
}
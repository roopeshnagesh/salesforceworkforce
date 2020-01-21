@isTest
public class BluescapeSupport_NavCtrl_test
{
    static List<BluescapeSupport_Site_Category__c> createSiteCategories()
    {
        BluescapeSupport_Site_Category__c cat1 = new BluescapeSupport_Site_Category__c();
        cat1.Name = 'Category 1';
        cat1.Active__c = true;
        insert cat1;

        BluescapeSupport_Site_Category__c cat2 = new BluescapeSupport_Site_Category__c();
        cat2.Name = 'Category 2';
        cat2.Active__c = false;
        insert cat2;

        return new BluescapeSupport_Site_Category__c[] { cat1, cat2 };
    }

    static testMethod void testControllerInit()
    {
        List<BluescapeSupport_Site_Category__c> siteCategories = createSiteCategories();

        test.StartTest();

        BluescapeSupport_NavController ctrl = new BluescapeSupport_NavController();

        System.assert (ctrl.siteCategories.size() == 1, 'Have site categories');
        System.assert (ctrl.siteCategories[0].name == siteCategories[0].Name, 'Have site category name');

        test.StopTest();
    }
}
@isTest
public class BluescapeSupport_FAQCtrl_test
{
     

    static BluescapeSupport_Site_Category__c createSiteCategory()
    {
        BluescapeSupport_Site_Category__c siteCategory = new BluescapeSupport_Site_Category__c();
        siteCategory.Name = 'Intro to testing';
        insert siteCategory;

        return siteCategory;
    }

    static testMethod void testControllerInit()
    {
        test.StartTest();

        BluescapeSupport_Site_Category__c siteCategory = createSiteCategory();

        

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_FAQ'));
        System.currentPageReference().getParameters().put('cat', siteCategory.Name);
		BluescapeSupport_FAQController.FAQItem faq =  new BluescapeSupport_FAQController.FAQItem('idididid','title','summary',1);
        BluescapeSupport_FAQController ctrl = new BluescapeSupport_FAQController();

        /*System.assert (ctrl.categoryName == siteCategory.Name, 'Have category');
        System.assert (ctrl.faqs.size() == 2, 'Have faqs');
        System.assert (ctrl.faqs[0].id == faq2.Id, 'Have faq id');
        System.assert (ctrl.faqs[0].title == faq2.Title, 'Have faq title');
        System.assert (ctrl.faqs[0].summary == faq2.Summary, 'Have faq summary');
        System.assert (ctrl.faqs[0].displaySequence == faq2.Display_Sequence__c, 'Have faq display sequence');*/

        test.StopTest();
    }
}
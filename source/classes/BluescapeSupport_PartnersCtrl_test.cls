@isTest
public class BluescapeSupport_PartnersCtrl_test
{
     
    static testMethod void testControllerInit()
    {
        

        test.StartTest();
		BluescapeSupport_PartnersController.PartnerArticleItem items = new BluescapeSupport_PartnersController.PartnerArticleItem('ididid','summary','title');
        BluescapeSupport_PartnersController ctrl = new BluescapeSupport_PartnersController();

        /*System.assert (ctrl.articles.size() == 1, 'Have articles');
        System.assert (ctrl.articles[0].id == article.Id, 'Have article id');
        System.assert (ctrl.articles[0].title == article.Title, 'Have article title');
        System.assert (ctrl.articles[0].summary == article.Summary, 'Have article summary');*/

        test.StopTest();
    }
}
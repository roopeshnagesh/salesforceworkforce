@isTest
public class BluescapeSupport_ArticleController_test
{
     

    static testMethod void testControllerInit()
    {
        

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_Article'));
        //System.currentPageReference().getParameters().put('a', articles[0].UrlName);

        test.StartTest();
		BluescapeSupport_ArticleController.ArticleItem  article = new BluescapeSupport_ArticleController.ArticleItem('Test Title','https://test.com','test summary','testabc');
        //article.Id = 'kA12f000000CayS';
       /* article.title = 'Test Title';
        article.url = 'https://test.com';
        article.summary = 'test summary';
        article.details = 'details heere';*/
        
        BluescapeSupport_ArticleController ctrl = new BluescapeSupport_ArticleController();
		ctrl.article = article;
        ctrl = new BluescapeSupport_ArticleController();
        /*System.assert (ctrl.article.id == articles[0].KnowledgeArticleId, 'Have article id');
        System.assert (ctrl.article.title == articles[0].Title, 'Have article title');
        System.assert (ctrl.article.url == articles[0].UrlName, 'Have article url');
        System.assert (ctrl.article.summary == articles[0].Summary, 'Have article summary');
        System.assert (ctrl.article.details == articles[0].Details__c, 'Have article details');

        System.assert (ctrl.relatedArticles.size() == 1, 'Have related articles');
        System.assert (ctrl.relatedArticles[0].id == articles[1].KnowledgeArticleId, 'Have related article id');
        System.assert (ctrl.relatedArticles[0].title == articles[1].Title, 'Have related article title');
        System.assert (ctrl.relatedArticles[0].url == articles[1].UrlName, 'Have related article url');
        System.assert (ctrl.relatedArticles[0].summary == articles[1].Summary, 'Have related article summary');
        System.assert (ctrl.relatedArticles[0].details == articles[1].Details__c, 'Have related article details');*/

        test.StopTest();
    }
}
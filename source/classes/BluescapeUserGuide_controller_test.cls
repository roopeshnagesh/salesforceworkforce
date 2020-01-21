@isTest
public class BluescapeUserGuide_controller_test{
    
    static String createArticles()
    {
         
        return null;
    }
    
    static testMethod void testLoadArticles()
    {
        String catLabel = createArticles();
        
        
        Test.setCurrentPageReference(new PageReference('Page.Bluescape_UserGuide'));
        //System.currentPageReference().getParameters().put('name', catLabel);
        ApexPages.currentPage().getParameters().put('name', 'catLabel');
        test.StartTest();
        Schema.DescribeFieldResult F = Account.Industry.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        BluescapeUserGuide_controller.SiteCategory sitecategory = new BluescapeUserGuide_controller.SiteCategory(P.get(0));
        BluescapeUserGuide_controller.ArticleItem articleItem = new BluescapeUserGuide_controller.ArticleItem('ididid','url'); 
        sitecategory.addArticle(articleItem);
         
        BluescapeUserGuide_controller ctrl = new BluescapeUserGuide_controller();
        
        
        /*  System.assert (ctrl.siteCategory != null, 'Have a site category');
System.assert (ctrl.siteCategory.label == catLabel, 'Have the site category');
System.assert (ctrl.siteCategory.articles.size() == 1, 'Have articles');
System.assert (ctrl.siteCategory.articles[0].title == 'Test Article 1', 'Have articles');*/
        
        test.StopTest();
    }
}
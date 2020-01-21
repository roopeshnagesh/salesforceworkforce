@isTest
public class BluescapeSupport_SiteCategoryCtrl_test
{
     

    static BluescapeSupport_Site_Category__c createSiteCategory()
    {
        BluescapeSupport_Site_Category__c siteCategory = new BluescapeSupport_Site_Category__c();
        siteCategory.Name = 'Site Category';
        insert siteCategory;

        return siteCategory;
    }

    static BluescapeSupport_Site_Sub_Category__c createSiteSubCategory(Integer displaySequence)
    {
        BluescapeSupport_Site_Sub_Category__c siteSubCategory = new BluescapeSupport_Site_Sub_Category__c();
        siteSubCategory.Name = 'Sub Category ' + displaySequence;
        siteSubCategory.Display_Sequence__c = displaySequence;
        siteSubCategory.Active__c = true;
        insert siteSubCategory;

        return siteSubCategory;
    }

    static testMethod void testControllerInit()
    {
        test.StartTest();

        BluescapeSupport_Site_Category__c siteCategory = createSiteCategory();
        BluescapeSupport_Site_Sub_Category__c siteSubCategory1 = createSiteSubCategory(1);
        BluescapeSupport_Site_Sub_Category__c siteSubCategory2 = createSiteSubCategory(2);

       

        Test.setCurrentPageReference(new PageReference('Page.BluescapeSupport_SiteCategory'));
        System.currentPageReference().getParameters().put('name', siteCategory.Name);
		BluescapeSupport_SiteCategoryController.ArticleItem article =  new BluescapeSupport_SiteCategoryController.ArticleItem('idididid', 'title', 'url','subCatergoryId');
        BluescapeSupport_Site_Sub_Category__c subcatObj = new BluescapeSupport_Site_Sub_Category__c();
        BluescapeSupport_SiteCategoryController.SubCategoryItem subcatergory = new BluescapeSupport_SiteCategoryController.SubCategoryItem(subcatObj);
		//Object com ;
        //Integer num =  subcatergory.compareTo(com);
        BluescapeSupport_SiteCategoryController ctrl = new BluescapeSupport_SiteCategoryController();
        BluescapeSupport_Site_Category__c childSite = new BluescapeSupport_Site_Category__c();
        
        
		BluescapeSupport_SiteCategoryController.SiteCategoryItem siteCatItem = new BluescapeSupport_SiteCategoryController.SiteCategoryItem(childSite);
        siteCatItem.addArticle(article);
        siteCatItem.setHaveFAQ(true);
        
        /*System.assert (ctrl.categoryName == siteCategory.Name, 'Have search term');
        System.assert (ctrl.siteCategory.name == siteCategory.Name, 'Have site category name');
        System.assert (ctrl.siteCategory.articles.size() == 3, 'Have site category articles');
        System.assert (ctrl.siteCategory.articles[0].id == article1.KnowledgeArticleId, 'Have article id');
        System.assert (ctrl.siteCategory.articles[0].title == article1.Title, 'Have article title');
        System.assert (ctrl.siteCategory.articles[0].url == article1.UrlName, 'Have article url');
        System.assert (ctrl.siteCategory.articles[1].id == article2.KnowledgeArticleId, 'Have article id');
        System.assert (ctrl.siteCategory.articles[1].title == article2.Title, 'Have article title');
        System.assert (ctrl.siteCategory.articles[1].url == article2.UrlName, 'Have article url');
        System.assert (ctrl.siteCategory.haveFAQ == true, 'Have faq');
        System.assert (ctrl.subCategories.size() == 2, 'Have subcategories');
        System.assert (ctrl.subCategories[0].articles.size() == 1, 'Have subcategory articles');
        System.assert (ctrl.subCategories[0].displaySequence == siteSubCategory1.Display_Sequence__c, 'Have subcategory display sequence');
        System.assert (ctrl.subCategories[1].articles.size() == 1, 'Have subcategory articles');
        System.assert (ctrl.subCategories[1].displaySequence == siteSubCategory2.Display_Sequence__c, 'Have subcategory display sequence');
        System.assert (ctrl.uncategorizedArticles.size() == 1, 'Have uncategorized articles');
        System.assert (ctrl.uncategorizedArticles[0].id == article3.KnowledgeArticleId, 'Have uncategorized article');*/

        test.StopTest();
    }
}
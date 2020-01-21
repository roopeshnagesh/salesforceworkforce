global class BluescapeSupport_SiteCategoryController extends BluescapeSupport_BaseController
{
    public static String DEFAULT_LABEL = 'Other';

    public String categoryName { get; set; }
    public SiteCategoryItem siteCategory { get; set; }
    public List<SubCategoryItem> subCategories { get; set; }
    public List<ArticleItem> uncategorizedArticles { get; set; }

    public BluescapeSupport_SiteCategoryController()
    {
        this.categoryName = ApexPages.currentPage().getParameters().get('name');

        loadSiteCategory(this.categoryName);
        loadArticles(this.siteCategory);
        loadFAQ(this.siteCategory);
        loadSubCategories(this.siteCategory);
    }

    private void loadSiteCategory(String name)
    {
        BluescapeSupport_Site_Category__c categoryRec = [SELECT Id, Name FROM BluescapeSupport_Site_Category__c WHERE Name = :name];
        siteCategory = new SiteCategoryItem(categoryRec);
    }

    private void loadArticles(SiteCategoryItem cat)
    {
        
    }

    private void loadFAQ(SiteCategoryItem cat)
    {
         
    }

    private void loadSubCategories(SiteCategoryItem cat)
    {
        List<BluescapeSupport_Site_Sub_Category__c> subCategoryRecs = [SELECT Id, Name, Display_Sequence__c FROM BluescapeSupport_Site_Sub_Category__c WHERE Active__c = true];
        Map<String, SubCategoryItem> subCategoryMap = new Map<String, SubCategoryItem>();
        uncategorizedArticles = new List<ArticleItem>();

        for (ArticleItem article : cat.articles)
        {
            if (!subCategoryMap.containsKey(article.subCategoryId)) {
                for (BluescapeSupport_Site_Sub_Category__c subCat : subCategoryRecs) {
                    if (subCat.Id == article.subCategoryId) {
                        subCategoryMap.put(article.subCategoryId, new SubCategoryItem(subCat));
                        break;
                    }
                }
            }

            SubCategoryItem subCategory = (SubCategoryItem) subCategoryMap.get(article.subCategoryId);

            if (subCategory != null) {
              subCategory.articles.add(article);
            }
            else {
              uncategorizedArticles.add(article);
            }
        }

        subCategories = subCategoryMap.values();
        subCategories.sort();
    }

    global class SiteCategoryItem
    {
        public String id { get; set; }
        public String name { get; set; }
        public Boolean haveFAQ { get; set; }
        public List<ArticleItem> articles { get; set; }
        public Map<String, List<ArticleItem>> subCategories { get; set; }

        public SiteCategoryItem(BluescapeSupport_Site_Category__c cat)
        {
            this.id = cat.Id;
            this.name = cat.Name;
            this.haveFAQ = false;
            this.articles = new List<ArticleItem>();
            this.subCategories = new Map<String, List<ArticleItem>>();
        }

        public void addArticle(ArticleItem article)
        {
            this.articles.add(article);
        }

        public void setHaveFAQ(Boolean haveFAQ)
        {
            this.haveFAQ = haveFAQ;
        }
    }

    global class SubCategoryItem implements Comparable
    {
        public String label { get; set; }
        public Decimal displaySequence { get; set; }
        public List<ArticleItem> articles { get; set; }

        public SubCategoryItem(BluescapeSupport_Site_Sub_Category__c subCat)
        {
            this.label = getMyLabel(subCat.Name);
            this.displaySequence = subCat.Display_Sequence__c;
            this.articles = new List<ArticleItem>();
        }

        private String getMyLabel(String suggestion)
        {
            if (suggestion == null) {
                return DEFAULT_LABEL;
            }
            return suggestion;
        }

        global Integer compareTo(Object compareTo)
        {
            SubCategoryItem other = (SubCategoryItem) compareTo;

            if (this.displaySequence < other.displaySequence) {
                return -1;
            } else if (other.displaySequence < this.displaySequence) {
                return 1;
            }

            return 0;
        }

    }

    global class ArticleItem
    {
        public String id { get; set; }
        public String title { get; set; }
        public String url { get; set; }
        public String subCategoryId { get; set; }
        public ArticleItem(String id, String title, String url,String subCategoryId ){
            this.Id = Id;
            this.title = title;
            this.url = url;
            this.subCategoryId = subCategoryId;
        }
        
    }
}
global class BluescapeHome_Controller
{
    public List<Bluescape_Feature_Content__c> featuredContent { get; set; }
    public List<Bluescape_Community_Event__c> upcomingEventList { get; set; }
    public List<SiteCategory> siteCategories { get; set; }
    
    public Double offset { get {
                               TimeZone tz = UserInfo.getTimeZone();
                               return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
                           }}

    public BluescapeHome_Controller()
    {
        loadArticles();
        loadFeaturedContent();
        loadLatestRelease();
        loadUpcomingEventList();
    }

    public void loadArticles()
    {
        
    }

    public void loadFeaturedContent()
    {
        featuredContent = [SELECT Id, Name, Title__c, URL__c, Image__c, Description__c, Video__c, Display_Sequence__c FROM Bluescape_Feature_Content__c where Active__c = true AND Category__c != 'Template' AND Category__c != 'Release Notes' ORDER BY Display_Sequence__c DESC];
    }

    public void loadLatestRelease()
    {
        
    }

    public void loadUpcomingEventList()
    {
        upcomingEventList =  [SELECT Title__c, Date__c, Description__c, URL__c, Active__c, Id, Name FROM Bluescape_Community_Event__c where Active__c = true AND Date__c > YESTERDAY ORDER BY Date__c ASC Limit 5];
    }

    global class SiteCategory
    {
        public String label { get; set; }
        public String value { get; set; }
        public List<ArticleItem> articles { get; set; }

        public SiteCategory(Schema.PicklistEntry entry)
        {
            this.label = entry.getLabel();
            this.value = entry.getValue();
            this.articles = new List<ArticleItem>();
        }

        public void addArticle(ArticleItem article)
        {
            this.articles.add(article);
        }
    }

    global class ArticleItem
    {
        public String title { get; set; }
        public String url { get; set; }
        
        public ArticleItem(String title, String url){
            
            this.title = title;
            this.url = url;
            
        }

         
    }
}
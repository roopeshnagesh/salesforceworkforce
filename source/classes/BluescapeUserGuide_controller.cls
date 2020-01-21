global class BluescapeUserGuide_controller
{
    public SiteCategory siteCategory { get; set; }

    public BluescapeUserGuide_controller()
    {
        String catName = ApexPages.currentPage().getParameters().get('name');
        system.debug('CatName***' + catName);

        loadSiteCategory(catName);
        loadArticles();
    }

    private void loadSiteCategory(String label)
    {
         
    }

    private void loadArticles()
    {
       
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
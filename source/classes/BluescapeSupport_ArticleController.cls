global class BluescapeSupport_ArticleController extends BluescapeSupport_BaseController
{
    public String articleUrl { get; set; }
    public ArticleItem article {get; set;}
    public List<ArticleItem> relatedArticles { get; set; }

    public BluescapeSupport_ArticleController()
    {
        this.articleUrl = ApexPages.currentPage().getParameters().get('a');

        loadArticle(this.articleUrl);
        loadRelatedArticles(this.article);
    }

    private void loadArticle(String articleUrl)
    {
        
    }

    private void loadRelatedArticles(ArticleItem article)
    {
        this.relatedArticles = new List<ArticleItem>();

        if (article != null) {
            List<String> articleKeywords = article.Title.split('\\s');
            List<String> keywordQuery = new List<String>();

            for (Integer i = 0; i < articleKeywords.size(); i++)
            {
                if (articleKeywords[i].length() >= 3)
                {
                  keywordQuery.add('%' + articleKeywords[i] + '%');
                }
            }

            
        }
    }

    global class ArticleItem
    {
        //public String id {get; set;}
        public String title {get; set;}
        public String url {get; set;}
        public String summary {get; set;}
        public String details {get; set;}

         
        
        public ArticleItem(String title,String url,string summary,string details){
            this.title = title;
            this.url = url;
            this.summary = summary;
            this.details = details;
        }
    }

}
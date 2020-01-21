global class BluescapeSupport_PartnersController extends BluescapeSupport_BaseController
{
    public List<PartnerArticleItem> articles { get; set; }

    public BluescapeSupport_PartnersController()
    {
        loadArticles();
    }

    private void loadArticles()
    {
        articles = new List<PartnerArticleItem>();

        
    }

    global class PartnerArticleItem
    {
        public String id { get; set; }
        public String title { get; set; }
        public String summary { get; set; }
        
        public PartnerArticleItem (String Id, String summary ,String title){
            this.title = title;
            this.summary = summary;
            this.Id = id;
        }
        

         
    }
}
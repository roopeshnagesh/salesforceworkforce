global class BluescapeSupport_SearchResultsController extends BluescapeSupport_BaseController
{
    public String searchTerm {get; set;}
    public List<String> searchTerms {get; set;}
    public List<ArticleResult> articles {get; set;}
    public List<FAQResult> faqs {get; set;}
    public List<VideoResult> videos {get; set;}
    public List<BluescapeSupport_Models.TemplateItem> templates { get; set; }

    public BluescapeSupport_SearchResultsController()
    {
        this.searchTerm = ApexPages.currentPage().getParameters().get('q');
        this.searchTerms = getSearchTerms(this.searchTerm);

        searchArticles(this.searchTerms);
        searchFAQ(this.searchTerms);
        searchVideos(this.searchTerms);
        searchTemplates(this.searchTerms);
    }

    private List<String> getSearchTerms(String searchTerm)
    {
        List<String> terms = this.searchTerm.split('\\s+');
        List<String> finalTerms = new List<String>();

        for (String term : terms)
        {
          term = term.trim();

          if (term.length() > 0) {
              finalTerms.add(term);
          }
        }

        return finalTerms;
    }

    global void searchArticles(List<String> searchTerms)
    {
        Map<String, ArticleResult> articleMap = new Map<String, ArticleResult>();

        for (String searchTerm : searchTerms)
        {
            String queryString = '%' + searchTerm + '%';
             
        }

        this.articles = articleMap.values();
        this.articles.sort();
    }

    global void searchFAQ(List<String> searchTerms)
    {
        Map<String, FAQResult> faqMap = new Map<String, FAQResult>();

        for (String searchTerm : searchTerms)
        {
            String queryString = '%' + searchTerm + '%';
            
        }

        this.faqs = faqMap.values();
        this.faqs.sort();
    }

    global void searchVideos(List<String> searchTerms)
    {
        Map<String, VideoResult> videoMap = new Map<String, VideoResult>();

        for (String searchTerm : searchTerms)
        {
            String queryString = '%' + searchTerm + '%';
            List<Bluescape_TV__c> results = [SELECT Id, Category__c, Title__c, URL__c, Image__c, Description__c, Keywords__c FROM Bluescape_TV__c WHERE Active__c=true AND (Title__c LIKE :queryString OR Description__c LIKE :queryString) ORDER BY Display_Sequence__c ASC LIMIT 25];

            for(Bluescape_TV__c result : results)
            {
                if (videoMap.containsKey(result.Id)) {
                  VideoResult existingResult = videoMap.get(result.Id);
                  existingResult.score += 1;
                } else {
                  videoMap.put(result.Id, new VideoResult(result));
                }
            }
        }

        this.videos = videoMap.values();
        this.videos.sort();
    }

    global void searchTemplates(List<String> searchTerms)
    {
        Map<String, BluescapeSupport_Models.TemplateItem> templateMap = new Map<String, BluescapeSupport_Models.TemplateItem>();

        for (String searchTerm : searchTerms)
        {
            String queryString = '%' + searchTerm + '%';
           
        }

        this.templates = templateMap.values();
    }

    global class ArticleResult implements Comparable
    {
        public String id {get; set;}
        public String title {get; set;}
        public String url {get; set;}
        public String summary {get; set;}
        public Integer score {get; set;}
        
        public ArticleResult(String title, String url,string id,integer score,string summary){
            
            this.title = title;
            this.url = url;
            this.id = id;
            this.score = 0;
            this.summary = summary;
            
        }

        

        global Integer compareTo(Object compareTo)
        {
            ArticleResult other = (ArticleResult) compareTo;

            if (this.score < other.score) {
                return 1;
            } else if (this.score > other.score) {
                return -1;
            } else {
              return 0;
            }
        }
    }

    global class FAQResult implements Comparable
    {
        public String id {get; set;}
        public String title {get; set;}
        public String summary {get; set;}
        public Decimal displaySequence {get; set;}
        public Integer score {get; set;}
        
        public FAQResult(String title, String summary,string id,integer score,Decimal displaySequence){
            
            this.title = title;
            //this.url = url;
            this.id = id;
            this.score = 0;
            this.summary = summary;
            this.displaySequence = 1.0;
            
        }

         

        global Integer compareTo(Object compareTo)
        {
            FAQResult other = (FAQResult) compareTo;

            if (this.score < other.score) {
                return 1;
            } else if (this.score > other.score) {
                return -1;
            } else {
              return 0;
            }
        }
    }

    global class VideoResult implements Comparable
    {
        public String id {get; set;}
        public String description {get; set;}
        public String imageUrl {get; set;}
        public String title {get; set;}
        public String url {get; set;}
        public String category {get; set;}
        public String keywords {get; set;}
        public Integer score {get; set;}

        public VideoResult(Bluescape_TV__c tv)
        {
            this.id = tv.Id;
            this.description = tv.Description__c != null ?  tv.Description__c : '';
            this.imageUrl = tv.Image__c.replaceAll('/community/', '');
            this.title = tv.Title__c != null ? tv.Title__c : '';
            this.url = tv.URL__c;
            this.category = tv.Category__c;
            this.keywords = tv.Keywords__c;
            this.score = 1;
        }

        global Integer compareTo(Object compareTo)
        {
            VideoResult other = (VideoResult) compareTo;

            if (this.score < other.score) {
                return 1;
            } else if (this.score > other.score) {
                return -1;
            } else {
              return 0;
            }
        }
    }

}
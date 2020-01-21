global class BluescapeSupport_FAQController extends BluescapeSupport_BaseController
{
    public String categoryName { get; set; }
    public BluescapeSupport_Site_Category__c category { get; set; }
    public List<FAQItem> faqs {get; set;}

    public BluescapeSupport_FAQController()
    {
        this.categoryName = ApexPages.currentPage().getParameters().get('cat');

        loadCategory(this.categoryName);
        loadFAQs(this.category);
    }

    private void loadCategory(String cat)
    {
        category = [SELECT Id FROM BluescapeSupport_Site_Category__c WHERE Name = :cat];
    }

    private void loadFAQs(BluescapeSupport_Site_Category__c category)
    {
        
    }

    global class FAQItem
    {
        public String id {get; set;}
        public String title {get; set;}
        public String summary {get; set;}
        public Decimal displaySequence {get; set;}
	
        public FAQItem(String Id, String title, String summary, Decimal displaySequence){
            this.Id =  Id;
            this.title = title;
            this.summary = summary;
            this.displaySequence = displaySequence;
        }
        
    }

}
global class BluescapeSupport_VideoPlayerController extends BluescapeSupport_BaseController
{
    public String videoId { get; set; }
    public VideoItem video { get; set; }

    public BluescapeSupport_VideoPlayerController()
    {
        this.videoId = ApexPages.currentPage().getParameters().get('videoId');

        loadVideo(this.videoId);
    }

    private void loadVideo(String videoId)
    {
        Bluescape_TV__c result = [SELECT Id, Name, Category__c, Title__c,  Image__c, URL__c, Description__c, LastModifiedDate FROM Bluescape_TV__c WHERE Id = :videoId AND Active__c = true];

        this.video = new VideoItem(result);
    }

    global class VideoItem
    {
        public String id {get; set;}
        public String description {get; set;}
        public String imageUrl {get; set;}
        public String title {get; set;}
        public String url {get; set;}
        public String category {get; set;}
        public Datetime publishDate { get; set; }

        public VideoItem(Bluescape_TV__c vid)
        {
            this.id = vid.Id;
            this.description = vid.Description__c != null ?  vid.Description__c : '';
            this.imageUrl = vid.Image__c;
            this.title = vid.Title__c != null ? vid.Title__c : '';
            this.url = vid.URL__c;
            this.category = vid.Category__c;
            this.publishDate = vid.LastModifiedDate;
        }
    }

}
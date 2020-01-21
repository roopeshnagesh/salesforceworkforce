global class BluescapeVideo_controller
{
    @RemoteAction
    global static VideoItem getVideoInfo(String videoId)
    {
        String Id = videoId;

        Bluescape_TV__c result = [SELECT Id, Name, Category__c, Title__c,  Image__c,URL__c, Description__c, Home_Page__c, Keywords__c FROM Bluescape_TV__c WHERE Id = :Id AND Active__c = true];

        return new VideoItem(result);
    }

    public BluescapeVideo_controller()
    {

    }

    global class VideoItem
    {
        public String id {get; set;}
        public String description {get; set;}
        public String imageUrl {get; set;}
        public String title {get; set;}
        public String url {get; set;}
        public String category {get; set;}
        public String keywords {get; set;}

        public VideoItem(Bluescape_TV__c vid)
        {
            this.id = vid.Id;
            this.description = vid.Description__c != null ?  vid.Description__c : '';
            this.imageUrl = vid.Image__c;
            this.title = vid.Title__c != null ? vid.Title__c : '';
            this.url = vid.URL__c;
            this.category = vid.Category__c;
            this.keywords = vid.Keywords__c;
        }
    }

}
global class BluescapeTV_controller {

    public List <VideoItem> recentVideos {get; set;}
    public List <VideoCategory> categories {get; set;}

    @RemoteAction
    global static List<VideoItem> search(String searchString)
    {
        List<VideoItem> videosLst = new List<VideoItem>();
        String queryString = '%'+searchString+'%';
        List<Bluescape_TV__c> searchResults = [SELECT Id, Name, Category__c, Title__c,  Image__c,URL__c, Description__c, Home_Page__c, Keywords__c, Display_Sequence__c, Active__c, Home_Page_Display_Sequence__c FROM Bluescape_TV__c WHERE Title__c LIKE :queryString AND Active__c=true ORDER BY Display_Sequence__c ASC];

        for(Bluescape_TV__c item : searchResults) {
            videosLst.add(new VideoItem(item));
        }

        if(videosLst.size()!=0) {
            return videosLst;
        }
        else{
            return new List<VideoItem>();
        }
    }

    @RemoteAction
    global static VideoItem getVideoInfo(String videoId)
    {
        String Id = videoId;
        Bluescape_TV__c result = [SELECT Id, Name, Category__c, Title__c,  Image__c,URL__c, Description__c, Home_Page__c, Keywords__c FROM Bluescape_TV__c WHERE Id = :Id AND Active__c = true];
        return new VideoItem(result);
    }

    public BluescapeTV_controller()
    {
        load();
    }

    public void load()
    {
        List<Bluescape_TV__c> recentVideoResults = [SELECT Id, Name, Category__c, Title__c, URL__c, Image__c, Description__c, Keywords__c FROM Bluescape_TV__c WHERE Active__c = true ORDER BY LastModifiedDate DESC];
        recentVideos = new List<VideoItem>();
		System.debug(recentVideoResults.size());
        for (Bluescape_TV__c video : recentVideoResults)
        {
            recentVideos.add(new VideoItem(video));
        }

        List <Bluescape_TV_Categories__c> categoryResults = [ SELECT Id, Name, Display_Order__c FROM Bluescape_TV_Categories__c ORDER BY Display_Order__c ASC ];
        categories = new List <VideoCategory>();

        for(Bluescape_TV_Categories__c category : categoryResults)
        {
            List<Bluescape_TV__c> categoryVids = [SELECT Id, Name, Category__c, Title__c, URL__c, Image__c, Description__c, Home_Page__c, Keywords__c, Display_Sequence__c, Active__c, Home_Page_Display_Sequence__c FROM Bluescape_TV__c WHERE Active__c=true AND Category__c=:category.Name ORDER BY Display_Sequence__c ASC];

            if (categoryVids.size() > 0)
            {
                VideoCategory categoryItem = new VideoCategory(category);
                categoryItem.setVideos(categoryVids);
                categories.add(categoryItem);
            }
        }
    }

    global class VideoCategory
    {
        public String id {get; set;}
        public String title {get; set;}
        public List<VideoItem> videos {get; set;}

        public VideoCategory(Bluescape_TV_Categories__c cat)
        {
            this.id = cat.Id;
            this.title = cat.Name;
        }

        public void setVideos(List<Bluescape_TV__c> videos)
        {
            this.videos = new List<VideoItem>();

            for (Bluescape_TV__c video : videos)
            {
                this.videos.add(new VideoItem(video));
            }
        }
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
        public Integer IndexValue {get; set;}

        public VideoItem(Bluescape_TV__c tv)
        {
            this.id = tv.Id;
            this.description = tv.Description__c != null ?  tv.Description__c : '';
            this.imageUrl = tv.Image__c;
            this.title = tv.Title__c != null ? tv.Title__c : '';
            this.url = tv.URL__c;
            this.category = tv.Category__c;
            this.keywords = tv.Keywords__c;
        }
    }
}
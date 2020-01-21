global class BluescapeSupport_VideosController extends BluescapeSupport_BaseController
{
    public List <RecentVideoItem> recentVideos {get; set;}
    public List <VideoCategory> categories {get; set;}

    @RemoteAction
    global static List<VideoItem> search(String searchString)
    {
        String queryString = '%'+searchString+'%';
        List<Bluescape_TV__c> searchResults = [SELECT Id, Name, Category__c, Title__c, URL__c, Image__c, Description__c, Keywords__c, Display_Sequence__c, LastModifiedDate FROM Bluescape_TV__c WHERE Active__c=true AND Title__c LIKE :queryString ORDER BY Display_Sequence__c ASC];

        List<VideoItem> videosList = new List<VideoItem>();

        for(Bluescape_TV__c item : searchResults)
        {
            videosList.add(new VideoItem(item));
        }

        return videosList;
    }

    public BluescapeSupport_VideosController()
    {
        load();
    }

    public void load()
    {
        List<Bluescape_TV__c> videos = [SELECT Id, Name, Category__c, Title__c, URL__c, Image__c, Description__c, Keywords__c, Display_Sequence__c, LastModifiedDate FROM Bluescape_TV__c WHERE Active__c = true];

        recentVideos = new List<RecentVideoItem>();
        for (Bluescape_TV__c video : videos)
        {
            recentVideos.add(new RecentVideoItem(video));
        }
        recentVideos.sort();

        Map<String, VideoCategory> categoryMap = new Map<String, VideoCategory>();

        for(Bluescape_TV__c video : videos)
        {
            if (categoryMap.containsKey(video.Category__c) == false) {
                categoryMap.put(video.Category__c, new VideoCategory(video.Category__c));
            }

            VideoCategory cat = categoryMap.get(video.Category__c);
            cat.addVideo(video);
        }

        categories = categoryMap.values();
        categories.sort();
    }

    global class VideoCategory implements Comparable
    {
        public String id {get; set;}
        public String title {get; set;}
        public List<VideoItem> videos {get; set;}

        public VideoCategory(String name)
        {
            this.id = name.deleteWhitespace();
            this.title = name;
            this.videos = new List<VideoItem>();
        }

        public void addVideo(Bluescape_TV__c video)
        {
            this.videos.add(new VideoItem(video));
        }

        global Integer compareTo(Object compareTo)
        {
            VideoCategory other = (VideoCategory) compareTo;

            if (this.title.length() < other.title.length()) return -1;
            if (this.title.length() > other.title.length()) return 1;
            if (this.title < other.title) return -1;
            if (this.title > other.title) return 1;
            return 0;
        }
    }

    global virtual class VideoItem implements Comparable
    {
        public String id {get; set;}
        public String description {get; set;}
        public String imageUrl {get; set;}
        public String title {get; set;}
        public String url {get; set;}
        public String category {get; set;}
        public String keywords {get; set;}
        public Decimal displaySequence {get; set;}
        public Datetime lastModifiedDate { get; set; }

        public VideoItem(Bluescape_TV__c tv)
        {
            this.id = tv.Id;
            this.description = tv.Description__c != null ?  tv.Description__c : '';
            this.imageUrl = tv.Image__c != null ? tv.Image__c.replaceFirst('^/community/', '') : '';
            this.title = tv.Title__c != null ? tv.Title__c : '';
            this.url = tv.URL__c;
            this.category = tv.Category__c;
            this.keywords = tv.Keywords__c;
            this.displaySequence = tv.Display_Sequence__c;
            this.lastModifiedDate = tv.LastModifiedDate;
        }

        global virtual Integer compareTo(Object compareTo)
        {
            VideoItem other = (VideoItem) compareTo;

            if (this.displaySequence < other.displaySequence) return -1;
            if (this.displaySequence > other.displaySequence) return 1;
            if (this.title < other.title) return -1;
            if (this.title > other.title) return 1;
            return 0;
        }
    }

    global class RecentVideoItem extends VideoItem
    {
        public RecentVideoItem(Bluescape_TV__c tv)
        {
            super(tv);
        }

        global override Integer compareTo(Object compareTo)
        {
            VideoItem other = (VideoItem) compareTo;

            if (this.lastModifiedDate < other.lastModifiedDate) return -1;
            if (this.lastModifiedDate > other.lastModifiedDate) return 1;
            if (this.displaySequence < other.displaySequence) return -1;
            if (this.displaySequence > other.displaySequence) return 1;
            if (this.title < other.title) return -1;
            if (this.title > other.title) return 1;
            return 0;
        }
    }
}
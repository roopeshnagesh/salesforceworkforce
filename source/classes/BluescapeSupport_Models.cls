global class BluescapeSupport_Models
{
    global class TemplateItem
    {
        public String id {get; set;}
        public String title {get; set;}
        public String urlName {get; set;}
        public String summary {get; set;}
        public String details { get; set; }
        public String type { get; set; }
        public String typeId { get; set; }
        public String thumbnailUrl { get; set; }
		private pattern ThumbnailUrlRegExp ;
       
        public TemplateItem(){
               ThumbnailUrlRegExp = pattern.compile('src="([^"]+)"');
        }
        public TemplateItem(String Id, String title, String urlName,String summary,String details,String type, String typeId){
            this.Id =  Id;
            this.title = title;
            this.summary = summary;
            this.urlName = urlName;
            this.details = details;
            this.type = type;
            this.typeId = typeId;
            
        }
        
		
         
    }

}
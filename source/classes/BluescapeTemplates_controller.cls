global class BluescapeTemplates_controller {

    public List<TemplateItem> templates { get; set; }
    public List<TemplateType> types { get; set; }

    public BluescapeTemplates_controller()
    {
        loadTemplates();
        loadTypes();
    }

    public void loadTemplates()
    {
       
    }

    public void loadTypes()
    {
       
    }

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

        private pattern ThumbnailUrlRegExp = pattern.compile('src="([^"]+)"');
        
        
        public TemplateItem(String id, String title,String urlName,String summary, String details,String type, String typeId, String thumbnailUrl ){
            this.id = id;
            this.title = title;
            this.urlName = urlName;
            this.summary = summary;
            this.details = details;
            this.type = type;
            this.typeId = typeId;
            this.thumbnailUrl = thumbnailUrl;
            
            
            
        }

          
    }

    global class TemplateType
    {
        public String label { get; set; }
        public String value { get; set; }
        global TemplateType(string label, string value){
            this.label = label;
            this.value = value;
            
        }

        public TemplateType(Schema.PicklistEntry entry)
        {
            this.label = entry.getLabel();
            this.value = entry.getValue().replaceAll('[\\s\\&]', '_');
        }
    }
}
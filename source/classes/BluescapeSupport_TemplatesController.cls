global class BluescapeSupport_TemplatesController extends BluescapeSupport_BaseController
{
    public List<BluescapeSupport_Models.TemplateItem> templates { get; set; }
    public List<TemplateType> types { get; set; }

    public BluescapeSupport_TemplatesController()
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

    global class TemplateType
    {
        public String label { get; set; }
        public String value { get; set; }

        public TemplateType(Schema.PicklistEntry entry)
        {
            this.label = entry.getLabel();
            this.value = entry.getValue().replaceAll('[\\s\\&]', '_');
        }
    }
}
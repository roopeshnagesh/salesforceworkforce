global class BluescapeSupport_TemplateController extends BluescapeSupport_BaseController
{
    public String templateId { get; set; }
    public BluescapeSupport_Models.TemplateItem template {get; set;}
    public List<BluescapeSupport_Models.TemplateItem> relatedTemplates { get; set; }

    public BluescapeSupport_TemplateController()
    {
        this.templateId = ApexPages.currentPage().getParameters().get('templateId');

        loadTemplate(this.templateId);
        loadRelatedTemplates(this.templateId);
    }

    private void loadTemplate(String templateId)
    {
       
    }

    private void loadRelatedTemplates(String templateId)
    {
        this.relatedTemplates = new List<BluescapeSupport_Models.TemplateItem>();

      
    }
}
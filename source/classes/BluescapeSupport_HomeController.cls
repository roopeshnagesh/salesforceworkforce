global class BluescapeSupport_HomeController extends BluescapeSupport_BaseController
{
    public List<SiteCategory> siteCategories { get; set; }
    public StatusItem systemStatus { get; set; }

    public BluescapeSupport_HomeController()
    {
        loadSiteCategories();
        loadSystemStatus();
    }

    private void loadSiteCategories()
    {
        siteCategories = new List<SiteCategory>();

        List<BluescapeSupport_Site_Category__c> cats = [SELECT Name, Description__c, IconName__c, Active__c FROM BluescapeSupport_Site_Category__c WHERE Active__c = true ORDER BY Display_Sequence__c ASC];

        for (BluescapeSupport_Site_Category__c cat : cats)
        {
            SiteCategory siteCategory = new SiteCategory(cat.Name, cat.Description__c, cat.IconName__c);
            siteCategories.add(siteCategory);
        }
    }

    private void loadSystemStatus()
    {
        try
        {
            Bluescape_ServiceStatus__c status = [SELECT Status__c, LastModifiedDate FROM Bluescape_ServiceStatus__c ORDER BY LastModifiedDate DESC LIMIT 1];
            systemStatus = new StatusItem(status);
        }
        catch (Exception e)
        {
            systemStatus = null;
        }
    }

    global class SiteCategory
    {
        public String name { get; set; }
        public String description { get; set; }
        public String icon { get; set; }

        public SiteCategory(String name, String description, String icon)
        {
            this.name = name;
            this.description = description;
            this.icon = icon;
        }
    }

    global class StatusItem
    {
        public String color { get; set; }
        public String message { get; set; }

        public StatusItem(Bluescape_ServiceStatus__c status)
        {
            List<String> parts = status.Status__c.split('\\|');

            message = parts[0];
            color = parts[1];
        }
    }
}
global class BluescapeSupport_NavController
{
    public List<SiteCategory> siteCategories { get; set; }

    public BluescapeSupport_NavController()
    {
        loadSiteCategories();
    }

    private void loadSiteCategories()
    {
        siteCategories = new List<SiteCategory>();

        List<BluescapeSupport_Site_Category__c> cats = [SELECT Name, IconName__c, Active__c FROM BluescapeSupport_Site_Category__c WHERE Active__c = true ORDER BY Display_Sequence__c ASC];

        for (BluescapeSupport_Site_Category__c cat : cats)
        {
            SiteCategory siteCategory = new SiteCategory(cat.Name);
            siteCategories.add(siteCategory);
        }
    }

    global class SiteCategory
    {
        public String name { get; set; }

        public SiteCategory(String name)
        {
            this.name = name;
        }
    }
}
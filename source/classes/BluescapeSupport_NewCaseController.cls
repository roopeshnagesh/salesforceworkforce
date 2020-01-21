global class BluescapeSupport_NewCaseController extends BluescapeSupport_BaseController
{
    public List<SelectOption> types { get; set; }
    public List<SelectOption> priorities  { get; set; }

    public BluescapeSupport_NewCaseController()
    {
        loadMetaData();
    }

    private void loadMetaData()
    {
        List<Schema.PicklistEntry> typeValues = Case.Type.getDescribe().getPicklistValues();
        types = new List<SelectOption>();
        for (Schema.PicklistEntry typeValue : typeValues)
        {
            if (typeValue.isActive())
            {
                types.add(new SelectOption(typeValue));
            }
        }

        List<Schema.PicklistEntry> priorityValues = Case.Priority.getDescribe().getPicklistValues();
        priorities = new List<SelectOption>();
        for (Schema.PicklistEntry priorityValue : priorityValues)
        {
            if (priorityValue.isActive())
            {
                priorities.add(new SelectOption(priorityValue));
            }
        }
    }

    @RemoteAction
    global static String createCase(String contactId, String type, String priority, String subject, String description)
    {
        Case newCase = new Case();

        try
        {
            newCase.ContactId = contactId;
            newCase.Origin = 'Web';
            newCase.Type = type;
            newCase.Priority = priority;
            newCase.Subject = subject;
            newCase.Description = description;
            insert newCase;
        }
        catch (Exception e)
        {
            return e.getMessage();
        }

        return 'OK' + newCase.Id;
    }

    global class SelectOption
    {
        public String value {get; set;}
        public String label {get; set;}

        public SelectOption(Schema.PicklistEntry entry)
        {
            this.value = entry.getValue();
            this.label = entry.getLabel();
        }
    }
}
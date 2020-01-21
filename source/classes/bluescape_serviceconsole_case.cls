public class bluescape_serviceconsole_case {
    public String caseId { get; set; }
    public Case caseRec { get; set; }
    public String subject { get; set; }
    public String description { get; set; }
    
    public bluescape_serviceconsole_case()
    {
        this.caseId = ApexPages.currentPage().getParameters().get('caseId');

        loadCase();
    }
    
    private void loadCase()
    {
        caseRec = [SELECT Id, CaseNumber, CommunityId, ClosedDate, ContactId, ContactEmail, CreatedDate, Description, IsClosed, Origin, Priority, Reason, Status, Subject, Type, (Select Subject,ActivityType,Description from ActivityHistories) FROM Case where Id = :this.caseId];
    }
}
global class BluescapeSupport_CaseCommentController extends BluescapeSupport_BaseController
{
    public List<CommentItem> comments { get; set; }
    public Case caseRec { get; set; }

    public BluescapeSupport_CaseCommentController()
    {
        String caseId = ApexPages.currentPage().getParameters().get('caseId');

        loadCase(caseId);
        loadComments(caseId);
    }

    private void loadCase(String caseId)
    {
        caseRec = [SELECT Id, CaseNumber, CommunityId, ClosedDate, ContactId, ContactEmail, CreatedDate, Description, IsClosed, Origin, Priority, Reason, Status, Subject, Type, (Select Subject,ActivityType,Description from ActivityHistories) FROM Case where Id = :caseId];
    }

    private void loadComments(String caseId)
    {
        List<CaseComment> results = [SELECT Id, CommentBody, CreatedBy.Name, CreatedDate FROM CaseComment where ParentId = :caseId AND IsDeleted = false ORDER BY CreatedDate DESC];

        comments = new List<CommentItem>();

        for (CaseComment result : results)
        {
            comments.add(new CommentItem(result));
        }
    }

    @RemoteAction
    global static String createComment(String caseId, String text)
    {
        try
        {
            CaseComment comment = new CaseComment();
            comment.CommentBody = text;
            comment.ParentId = caseId;
            insert comment;
        }
        catch (Exception e)
        {
            return e.getMessage();
        }

        return 'OK';
    }

    global class CommentItem
    {
        public String id {get; set;}
        public String comment {get; set;}
        public String creator {get; set;}
        public String creationDate {get; set;}

        public CommentItem(CaseComment rec)
        {
            this.id = rec.Id;
            this.comment = rec.CommentBody;
            this.creator = rec.CreatedBy.Name;
            this.creationDate = rec.CreatedDate.format('EEE, d MMM yyyy h:mm aaa');
        }
    }
}
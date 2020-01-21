global class BluescapeSupport_CaseDetailController extends BluescapeSupport_BaseController
{
    public String caseId { get; set; }
    public Case caseRec { get; set; }
    public List<CommentItem> comments { get; set; }
    // public List<CaseHistory> history { get; set; }
    public List<EmailItem> emails { get; set; }
    public List<AttachmentItem> attachments { get; set; }
    public List<ArticleItem> articles { get; set; }

    public BluescapeSupport_CaseDetailController()
    {
        this.caseId = ApexPages.currentPage().getParameters().get('caseId');

        loadCase();
        loadComments();
        // loadHistory();
        loadEmails();
        loadAttachments();
        // http://blog.jeffdouglas.com/2010/04/28/uploading-an-attachment-using-visualforce-and-a-custom-controller/
        loadArticles();
    }

    private void loadCase()
    {
        caseRec = [SELECT Id, CaseNumber, CommunityId, ClosedDate, ContactId, ContactEmail, CreatedDate, Description, IsClosed, Origin, Priority, Reason, Status, Subject, Type, (Select Subject,ActivityType,Description from ActivityHistories) FROM Case where Id = :this.caseId];
    }

    private void loadComments()
    {
        List<CaseComment> results = [SELECT Id, CommentBody, CreatedBy.Name, CreatedDate FROM CaseComment where ParentId = :this.caseId AND IsDeleted = false ORDER BY CreatedDate ASC];

        comments = new List<CommentItem>();

        for (CaseComment result : results)
        {
            comments.add(new CommentItem(result));
        }
    }

    // private void loadHistory()
    // {
    //     history = [SELECT Id, Field, OldValue, NewValue FROM CaseHistory WHERE CaseId = :this.caseId AND IsDeleted = false];
    // }

    private void loadEmails()
    {
        List<EmailMessage> results = [SELECT Id, CreatedBy.Name, CreatedDate, Subject, TextBody FROM EmailMessage WHERE ParentId = :this.caseId];

        emails = new List<EmailItem>();

        for (EmailMessage result : results)
        {
            emails.add(new EmailItem(result));
        }
    }

    private void loadAttachments()
    {
        List<Attachment> results = [SELECT Id, Body, ContentType, CreatedBy.Name, Description, Name, LastModifiedDate FROM Attachment WHERE ParentId = :this.caseId];

        attachments = new List<AttachmentItem>();

        for (Attachment result : results)
        {
            attachments.add(new AttachmentItem(result));
        }
    }

    private void loadArticles()
    {
        CaseArticle[] caseArticles = [SELECT KnowledgeArticleId FROM CaseArticle WHERE CaseId = :this.caseId];

        List<Id> articleIds = new List<Id>();
        for (CaseArticle article : caseArticles) {
            articleIds.add(article.KnowledgeArticleId);
        }

        List<KnowledgeArticleVersion> results = [SELECT Id, KnowledgeArticleId, UrlName, Title, Summary, LastPublishedDate FROM KnowledgeArticleVersion WHERE PublishStatus= 'Online' AND Language = 'en_US' AND KnowledgeArticleId IN :articleIds];

        articles = new List<ArticleItem>();

        for (KnowledgeArticleVersion result : results)
        {
            articles.add(new ArticleItem(result));
        }
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

    global class AttachmentItem
    {
        public String id {get; set;}
        public String title {get; set;}
        public String uploader {get; set;}
        public String uploadDate {get; set;}

        public AttachmentItem(Attachment rec)
        {
            this.id = rec.Id;
            this.title = rec.Name;
            this.uploader = rec.CreatedBy.Name;
            this.uploadDate = rec.LastModifiedDate.format('EEE, d MMM yyyy h:mm aaa');
        }
    }

    global class ArticleItem
    {
        public String id {get; set;}
        public String title {get; set;}
        public String summary {get; set;}
        public String publishDate {get; set;}

        public ArticleItem(KnowledgeArticleVersion rec)
        {
            this.id = rec.Id;
            this.title = rec.Title;
            this.summary = rec.Summary;
            this.publishDate = rec.LastPublishedDate.format('EEE, d MMM yyyy h:mm aaa');
        }
    }

    global class EmailItem
    {
        public String id {get; set;}
        public String subject {get; set;}
        public String message {get; set;}
        public String sender {get; set;}
        public String sendDate {get; set;}

        public EmailItem(EmailMessage rec)
        {
            this.id = rec.Id;
            this.subject = rec.Subject;
            this.message = rec.TextBody;
            this.sender = rec.CreatedBy.Name;
            this.sendDate = rec.CreatedDate.format('EEE, d MMM yyyy h:mm aaa');
        }
    }
}
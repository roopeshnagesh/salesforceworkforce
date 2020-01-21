global class BluescapeSupport_MyCasesController extends BluescapeSupport_BaseController
{
    public List<CaseItem> caseList { get; set; }
    public String curView { get; set; }
    public List<SelectOption> caseViews { get; set; }
    public BluescapeSupport_PaginationData pageData { get; set; }

    private static Integer PAGE_SIZE = 20;
    private static Set<String> AVAILABLE_VIEWS = new Set<String> {'u', 'uo', 'a', 'ao'};
    private static Map<String,String> VIEW_LABELS = new Map<String,String> {
        'u' => 'My Cases',
        'uo' => 'My Open Cases',
        'a' => 'All Account Cases',
        'ao' => 'All Open Account Cases'
    };

    public BluescapeSupport_MyCasesController()
    {
        String curViewParam = ApexPages.currentPage().getParameters().get('v');
        String curPageParam = ApexPages.currentPage().getParameters().get('p');
        String sortFieldParam = ApexPages.currentPage().getParameters().get('sf');
        String sortDirParam = ApexPages.currentPage().getParameters().get('sd');

        BluescapeSupport_PaginationData pageData = new BluescapeSupport_PaginationData();
        pageData.pageSize = PAGE_SIZE;

        if (AVAILABLE_VIEWS.contains(curViewParam))
        {
            this.curView = curViewParam;

            if (this.curView.startsWith('a') && this.isSuperUser == false)
            {
                this.curView = 'u';
            }
        }
        else
        {
            this.curView = 'u';
        }

        if (sortFieldParam != null)
        {
            pageData.sortField = sortFieldParam;
        }
        else
        {
            pageData.sortField = 'CaseNumber';
        }

        if (sortDirParam != null)
        {
            pageData.sortDir = sortDirParam;
        }
        else
        {
            pageData.sortDir = 'asc';
        }

        try
        {
            pageData.pageNumber = Integer.valueOf(curPageParam);
        }
        catch (Exception e)
        {
            pageData.pageNumber = 1;
        }

        if (this.curView == 'a' && this.userAccountId != null)
        {
            loadAccountCases(this.userAccountId, pageData, false);
        }
        else if (this.curView == 'ao' && this.userAccountId != null)
        {
            loadAccountCases(this.userAccountId, pageData, true);
        }
        else if (this.curView == 'u' && this.userContactId != null)
        {
            loadUserCases(this.userContactId, pageData, false);
        }
        else if (this.curView == 'uo' && this.userContactId != null)
        {
            loadUserCases(this.userContactId, pageData, true);
        }
        else
        {
            this.caseList = new List<CaseItem>();
        }

        this.caseViews = new List<SelectOption>();

        for (String viewName : AVAILABLE_VIEWS)
        {
            this.caseViews.add(new SelectOption(viewName, VIEW_LABELS.get(viewName)));
        }
    }

    private void loadUserCases(String contactId, BluescapeSupport_PaginationData pageData, Boolean openCasesOnly)
    {
        String qryWhere = 'Contactid = \'' + contactId + '\'';

        loadCases(qryWhere, pageData, openCasesOnly);
    }

    private void loadAccountCases(String accountId, BluescapeSupport_PaginationData pageData, Boolean openCasesOnly)
    {
        String qryWhere = 'AccountId = \'' + accountId + '\'';

        loadCases(qryWhere, pageData, openCasesOnly);
    }

    private void loadCases(String qryWhere, BluescapeSupport_PaginationData pageData, Boolean openCasesOnly)
    {
        qryWhere = qryWhere + ' AND IsDeleted = false';

        if (openCasesOnly)
        {
            qryWhere = qryWhere + ' AND ClosedDate = null';
        }

        this.caseList = new List<CaseItem>();
        this.pageData = pageData;

        pageData.recordCount = Database.countQuery('SELECT COUNT() FROM Case WHERE ' + qryWhere);
        pageData.pageNumber = Integer.valueOf(Math.min(pageData.numPages, Math.max(1, pageData.pageNumber)));

        Integer qryOffset = Integer.valueOf((pageData.pageNumber - 1) * pageData.pageSize);
        String fields = 'Id, CaseNumber, CommunityId, ClosedDate, ContactId, ContactEmail, CreatedDate, Description, IsClosed, Origin, Priority, Reason, Status, Subject, Type';
        String orderBy = pageData.sortField + ' ' + pageData.sortDir;
        String query = 'SELECT ' + fields + ' FROM Case WHERE ' + qryWhere + ' ORDER BY  ' + orderBy + ' LIMIT ' + pageData.pageSize + ' OFFSET ' + qryOffset;
        List<Case> results = Database.query(query);

        for (Case result : results)
        {
            caseList.add(new CaseItem(result));
        }
    }

    global class CaseItem
    {
        public String id {get; set;}
        public String caseNo {get; set;}
        public String creationDate {get; set;}
        public String subject {get; set;}
        public String description {get; set;}
        public String status {get; set;}
        public String type {get; set;}

        public CaseItem(Case rec)
        {
            this.id = rec.Id;
            this.caseNo = rec.CaseNumber;
            this.creationDate = rec.CreatedDate.format('MMM d, yyyy');
            this.subject = rec.Subject;
            this.description = rec.Description;
            this.status = rec.Status;
            this.type = rec.Type;
        }
    }
}
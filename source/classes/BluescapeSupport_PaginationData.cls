global class BluescapeSupport_PaginationData
{
    public Integer pageNumber { get; set; }
    public Integer pageSize { get; set; }
    public Integer recordCount { get; set; }
    public String sortField { get; set; }
    public String sortDir { get; set; }

    public BluescapeSupport_PaginationData()
    {

    }

    public Integer recordStart {
      get {
        return ((pageNumber - 1) * pageSize) + 1;
      }
    }

    public Integer recordEnd {
      get {
        return Math.min(recordCount, Integer.valueOf(recordStart + pageSize - 1));
      }
    }

    public Integer numPages {
      get {
        return Integer.valueOf(Math.max(1, Math.ceil(recordCount / (Double)pageSize)));
      }
    }

    public List<PageItem> pages {
        get {
            List<PageItem> pages = new List<PageItem>();

            for (Integer i = 0; i < numPages; i++)
            {
                Integer pageNumber = i + 1;
                pages.add(new PageItem(pageNumber, pageNumber == this.pageNumber));
            }

            return pages;
        }
    }

    public PageItem prevPage {
        get {
            if (pageNumber > 1)
            {
                return new PageItem(pageNumber - 1, false);
            }

            return null;
        }
    }

    public PageItem nextPage {
        get {
            if (pageNumber < numPages)
            {
                return new PageItem(pageNumber + 1, false);
            }

            return null;
        }
    }

    public PageItem curPage {
        get {
            return new PageItem(pageNumber, true);
        }
    }

    global class PageItem
    {
        public Integer pageNumber { get; set; }
        public Boolean isCurrent { get; set; }

        public PageItem(Integer pageNumber, Boolean isCurrentPage)
        {
            this.pageNumber = pageNumber;
            this.isCurrent = isCurrentPage;
        }
    }
}
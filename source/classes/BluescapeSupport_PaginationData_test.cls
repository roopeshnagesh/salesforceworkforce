@isTest
public class BluescapeSupport_PaginationData_test
{
    static testMethod void testGetters()
    {
        test.StartTest();

        BluescapeSupport_PaginationData pageData = new BluescapeSupport_PaginationData();
        pageData.pageNumber = 2;
        pageData.pageSize = 10;
        pageData.recordCount = 19;

        System.assert (pageData.recordStart == 11, 'Have record start');
        System.assert (pageData.recordEnd == 19, 'Have record end');
        System.assert (pageData.numPages == 2, 'Have num pages');

        List<BluescapeSupport_PaginationData.PageItem> pages = pageData.pages;

        System.assert (pages.size() == 2, 'Have pages size');

        for (Integer i = 0; i < pages.size(); i++)
        {
            System.assert ( pages[i].pageNumber == i + 1, 'Have page number');
            System.assert ( pages[i].isCurrent == ((i+1) == pageData.pageNumber), 'Have current page');
        }

        BluescapeSupport_PaginationData.PageItem prevPage = pageData.prevPage;

        System.assert ( prevPage.pageNumber == 1, 'Have prev page number');

        BluescapeSupport_PaginationData.PageItem nextPage = pageData.nextPage;

        System.assert ( nextPage == null, 'Have no next page');

        BluescapeSupport_PaginationData.PageItem curPage = pageData.curPage;

        System.assert ( curPage.pageNumber == 2, 'Have cur page number');
        System.assert ( curPage.isCurrent == true, 'Have cur page current');

        test.StopTest();
    }
}
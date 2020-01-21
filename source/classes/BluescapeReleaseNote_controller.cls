global class BluescapeReleaseNote_controller
{
     

    public BluescapeReleaseNote_controller()
    {
        loadPageData();
    }

    public void loadPageData()
    {
        String noteId = ApexPages.currentPage().getParameters().get('noteId');
       
    }
}
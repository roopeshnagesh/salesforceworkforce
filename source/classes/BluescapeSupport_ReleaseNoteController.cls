global class BluescapeSupport_ReleaseNoteController extends BluescapeSupport_BaseController
{
    public ReleaseNoteItem releaseNote { get; set; }

    public BluescapeSupport_ReleaseNoteController()
    {
        String noteId = ApexPages.currentPage().getParameters().get('noteId');

        loadReleaseNote(noteId);
    }

    public void loadReleaseNote(String noteId)
    {
         
    }

    global class ReleaseNoteItem
    {
        public String title { get; set; }
        public String summary { get; set; }
        public String details { get; set; }
        
        public ReleaseNoteItem(String title, String summary ,String details){
            this.title = title;
            this.summary = summary;
            this.details = details;
        }

         
    }
}
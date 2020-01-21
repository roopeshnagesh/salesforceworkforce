public with sharing class BluescapeCommunityFeedRedirect
{
public Pagereference RedirectToCommunityFeedGroup()
   {
         PageReference objChatter = new PageReference('/apex/BluescapeChatterFeedSearchPage?isdtp=nv');
         objChatter.setRedirect(true);
         return objChatter ;
      
     
   }
}
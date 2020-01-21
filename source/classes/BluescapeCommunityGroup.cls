public class BluescapeCommunityGroup
{
public Pagereference RedirectToCommunityGroup()
   {
         PageReference objChatter = new PageReference('/apex/Bluescape_Chatter_Feed_OnGroup?isdtp=nv');
         objChatter.setRedirect(true);
         return objChatter ;
      
   
   }
}
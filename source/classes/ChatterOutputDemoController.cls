public with sharing class ChatterOutputDemoController {
    /*public  ConnectApi.FeedItemPage feedItemPage{get;set;}*/
    public String SearchString {get;set;}
    public String communityName {get;set;}
   /* public Object TextSegmentType{get{
        return ConnectApi.MessageSegmentType.Text;
    }}*/
   /* public Object MentionSegmentType{get{
        return ConnectApi.MessageSegmentType.Mention;
    }}*/
    public ChatterOutputDemoController() {
        //code to get chatter newsfeed
       communityName  = System.Label.Community_URL_Name;
    }
    
  
    
 /*   public void SearchFeedItems()
    {
       if(SearchString != null && SearchString != '')
       {
          feedItemPage = ConnectApi.ChatterFeeds.searchFeedItems('0DB230000004CD0GAM',SearchString );
          System.debug('*******feedItemPage *******'+feedItemPage);
       }
       else
       {
         feedItemPage  = null;
       }
        
    }*/
    
 /*   public void getFeedItem()
    {
       ConnectApi.FeedItemPage objFedItemPage =ConnectApi.ChatterFeeds.getFeedItemsFromFeed('0DB230000004CD0GAM',ConnectApi.FeedType.groups,'me');
        system.debug('*******objFedItemPage '+objFedItemPage );
        for(ConnectApi.FeedItem obj : objFedItemPage.items )
        {
           System.debug('****obj ****'+obj );
           System.debug('****feedItem.parent.id****'+obj.parent.id);
           System.debug('****feedItem.parent'+obj.photourl);
        
        
        }

    }*/
    //This is not used anywhere in the org
   /* public void getFeedLike()
    {
    string strId=userinfo.getOrganizationId();
  ConnectApi.ChatterLikePage chatterLike=ConnectApi.ChatterFeeds.getLikesForFeedElement(null,null,null,null);
   //ConnectApi.ChatterLike chatterLike = ConnectApi.ChatterFeeds.likeFeedElement(null, '0D523000005e20yCAA');
     // .. ConnectApi.FeedItemPage objFedItemPage =ConnectApi.ChatterFeeds.getFeedItemsFromFeed('0DB230000004CD0GAM',ConnectApi.FeedType.groups,'me');
       
     //   for(ConnectApi.FeedItem obj : objFedItemPage.items )
       // {
       //    System.debug('****obj ****'+obj );
        //   System.debug('****feedItem.parent.id****'+obj.parent.id);
        //   System.debug('****feedItem.parent'+obj.photourl);
        
        
        //}

    }*/
    
}
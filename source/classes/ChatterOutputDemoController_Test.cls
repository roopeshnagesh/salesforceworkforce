@isTest
private class ChatterOutputDemoController_Test{

static testMethod void testMethod1()
    {
          Test.startTest();
    ChatterOutputDemoController chatterObj = new ChatterOutputDemoController();
    chatterObj.SearchString = 'Test';
    chatterObj.communityName='Bluescape Community';
    /* FeedItem post = new FeedItem(); 
    post.ParentId = userinfo.getuserid(); 
    post.Body = 'test post';
     insert post; 
    ConnectApi.FeedItemPage testPage = new ConnectApi.FeedItemPage();
    List<ConnectApi.FeedItem> testItemList = new List<ConnectApi.FeedItem>();
    testItemList.add(new ConnectApi.FeedItem());
    testItemList.add(new ConnectApi.FeedItem());
   ------------------------------------*/
    //testPage.items = testItemList;   
   // post.NetworkScope = membership.networkID;   //set the network ID of the post
   
  /*UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
system.debug('portalRole is ' + portalRole);

Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
User portalAccountOwner1 = new User(
UserRoleId = portalRole.Id,
ProfileId = profile1.Id,
Username = System.now().millisecond() + 'test2@test.com',
Alias = 'batman',
Email='bruce.wayne@wayneenterprises.com',
EmailEncodingKey='UTF-8',
Firstname='Bruce',
Lastname='Wayne',
LanguageLocaleKey='en_US',
LocaleSidKey='en_US',
TimeZoneSidKey='America/Chicago'
);
Database.insert(portalAccountOwner1);

//User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];

System.runAs ( portalAccountOwner1 ) {
//Create account
Account portalAccount1 = new Account(
Name = 'TestAccount',
OwnerId = portalAccountOwner1.Id
);
Database.insert(portalAccount1);

//Create contact
Contact contact1 = new Contact(
FirstName = 'Test',
Lastname = 'McTesty',
AccountId = portalAccount1.Id,
Email = System.now().millisecond() + 'test@test.com'
);
Database.insert(contact1);


//get the network membership to get the correct network ID
//NetworkMember membership = [SELECT networkID, memberID FROM NetworkMember WHERE memberID = :portalAccount1.id];


    FeedItem post = new FeedItem(); 
    post.ParentId = userinfo.getuserid(); 
    post.Body = 'test post';   
   // post.NetworkScope = membership.networkID;   //set the network ID of the post
    insert post; 
    
     ConnectApi.FeedItemPage testPage = new ConnectApi.FeedItemPage();
       
       chatterObj.SearchString ='';
        // chatterObj.getFeedLike();
      // ConnectApi.ChatterFeeds.getLikesForFeedElement(null,null,null, null);
}
    */
    
   
      
        Test.stopTest();
     }
     static testMethod void testMethod2()
     {
        Bluescape_TriggerControl.avoidRecursiveUpdate = true;
       Bluescape_TriggerControl.avoidFeatureContentRecursiveUpdate = true;
       Bluescape_TriggerControl.avoidCommEventURLRecursiveUpdate = true; 
     }
 }
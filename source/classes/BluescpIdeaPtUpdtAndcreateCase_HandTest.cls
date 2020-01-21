@isTest
Public class BluescpIdeaPtUpdtAndcreateCase_HandTest
{
    @isTest(SeeAllData=true)
    static void testMethod1()
    {
        BluescapeIdeaPtUpdtAndcreateCase_Handler obj = new BluescapeIdeaPtUpdtAndcreateCase_Handler();

        Account acc1 = new Account();
        acc1.Name = 'newAcc1';
        insert acc1;

        List<Contact> conList = new List<Contact>();
        Contact con1 = new Contact();
        con1.AccountId = acc1.id;
        con1.LastName = 'portalTestUserv1';
        conList.add(con1);
        insert conList;

        Profile profile = [select Id, Name from Profile where Name='Customer Community User Custom' limit 1];

        User newUser1 = new User();
        newUser1.profileId = profile.id;
        newUser1.username = 'newUser11@yahoo.com';
        newUser1.email = 'pb1212@f.com';
        newUser1.emailencodingkey = 'UTF-8';
        newUser1.localesidkey = 'en_US';
        newUser1.languagelocalekey = 'en_US';
        newUser1.timezonesidkey = 'America/Los_Angeles';
        newUser1.alias = 'nuser';
        newUser1.lastname = 'lastname121';
        newUser1.contactId = conList[0].id;
        insert newUser1;

        system.runAS(newUser1)
        {
            List<Idea> ideas = new List<Idea>();
            List<Community> zones = [Select Id, Name From Community];
            String zoneId;

            if (zones.size() > 0) {
              zoneId = zones[0].Id;
            } else {
              zoneId = '09aE0000000GovNIAS';
            }

            Idea idea1 = new Idea();
            idea1.Title = 'Test Bluescape';
            idea1.body ='test description';
            idea1.CommunityId = zoneId;
            idea1.Status = 'Transfer to customer services';
            ideas.add(idea1);
            insert ideas;

            idea1.Title = 'Test Bluescape 1';

            update ideas;
            delete ideas;
        }

        obj.testdata();
    }
}
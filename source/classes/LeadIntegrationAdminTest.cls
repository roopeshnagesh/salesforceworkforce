@isTest
public class LeadIntegrationAdminTest {
    
	@isTest
    public static void testAdminCreationCallouts() {
        Bluescape_API_Token__c bluescapeAPIToken = new Bluescape_API_Token__c(
                Name = 'Bluescape_Api_Integration',
                Access_Token__c = 'accessToken',
                Client_ID__c = '123',
                Client_Secret__c = '123',
                Expires_At__c = 2000000000,
                Redirect_URI__c = 'https://localhost/callback',
                Refresh_Token__c = '123'
        );
        insert bluescapeAPIToken;
        
        Lead lead = new Lead(
                FirstName = 'Test',
                LastName = 'Lead',
                Email = 'test@gmail.com',
                Company = 'test',
                Free_Trial__c = false,
                Org_Id__c = '4141'
        );
        insert lead;
        
        Test.startTest();
        LeadIntegrationAdmin.configureOrgWithoutAdmin(new List<Id>{lead.Id});
        Test.stopTest();
    }
}
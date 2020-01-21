@isTest
public class BluescapeExtendingOrgExpirationTest {
    
    @TestSetup
    public static void setup() {
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
    }
    
    @isTest
    public static void testExtendingOrgExpiration() {
        Lead lead = new Lead(
            LastName = 'Test',
            Company = 'Test',
            Org_Id__c = '123',
            Extension_Duration__c = '7'
        );
        insert lead;
        
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationExtendingOrgExpMock());
        
        Test.startTest();
        BluescapeExtendingOrgExpiration.extendingOrgExpiration(new List<Id>{lead.Id});
        Test.stopTest();
        
        System.assertEquals('Success', [SELECT Trial_Extended__c FROM Lead WHERE Id = :lead.Id].Trial_Extended__c);
    }
    
    @isTest
    public static void testExtendingOrgExpirationFail() {
        Lead lead = new Lead(
            LastName = 'Test',
            Company = 'Test',
            Org_Id__c = '123',
            Extension_Duration__c = '7'
        );
        insert lead;
        
        UtilIntegration.setFailingMock = true;
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationExtendingOrgExpMock());
        
        Test.startTest();
        BluescapeExtendingOrgExpiration.extendingOrgExpiration(new List<Id>{lead.Id});
        Test.stopTest();
        
        System.assertEquals('Fail', [SELECT Trial_Extended__c FROM Lead WHERE Id = :lead.Id].Trial_Extended__c);
    }
    
    @isTest
    public static void testExtendingOrgExpirationForContactBluescapeOrgObject() {
        Contact contact = new Contact(
                LastName = 'Contact',
                Email = 'contact@email.com'
        );
        insert contact;
        
        Bluescape_Org__c bluescapeOrg = new Bluescape_Org__c(
            Bluescape_Org_ID__c = 123            
        );
        insert bluescapeOrg;
        
        ContactBluescapeOrg__c contactBluescapeOrg = new ContactBluescapeOrg__c(
            Contact__c = contact.Id,
            Bluescape_Org__c = bluescapeOrg.Id,
            Extension_Duration__c = '7'
        );
        insert contactBluescapeOrg;
        
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationExtendingOrgExpMock());
        
        Test.startTest();
        BluescapeExtendingOrgExpiration.extendingOrgExpiration(new List<Id>{contactBluescapeOrg.Id});
        Test.stopTest();
        
        System.assertEquals('Success', [SELECT Trial_Extended__c FROM ContactBluescapeOrg__c WHERE Id = :contactBluescapeOrg.Id].Trial_Extended__c);
    }
}
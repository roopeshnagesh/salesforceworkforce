@isTest
public class BluescapeIntegrationTest {
    @TestSetup
    public static void setup() {        
        Bluescape_API_Token__c bluescapeAPIToken = new Bluescape_API_Token__c(
                Name = 'Bluescape_Api_Integration',
                Access_Token__c = 'accessToken',
                Client_ID__c = '123',
                Client_Secret__c = '123',
                Expires_At__c = 2000000000,
                Redirect_URI__c = 'https://localhost/callback',
                Refresh_Token__c = '123',
                Instance__c = 'stg1',
            	Getting_Started_Workspace__c = 'asdfasdfasdf123',
            	Getting_Started_Workspace_Organization__c = '1234',
            	API_Version__c = 'v1'
        );
        insert bluescapeAPIToken;
    }
    
    @isTest
    public static void testOrgRequest() {
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationRequestOrgMock());
        
        Test.startTest();
        BluescapeIntegration.ResponseWrapper responseWrapper = BluescapeIntegration.makeOrgRequest('test.org@gmail.com', 5);
        Test.stopTest();
        
        System.assertEquals(201, responseWrapper.responseCode);
    }
    
    @isTest
    public static void testCreateUserRequest() {
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationCreateUserMock());
        
        Test.startTest();
        BluescapeIntegration.ResponseWrapper responseWrapper = BluescapeIntegration.createUserRequest(4512, 'test@gmail.com');
        Test.stopTest();
        
        System.assertEquals(200, responseWrapper.responseCode);
    }
    
    @isTest
    public static void testGetUserForMakingAdminRequest() {
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationGetUserMock());
        
        Test.startTest();
        BluescapeIntegration.ResponseWrapper responseWrapper = BluescapeIntegration.getUserForMakingAdminRequest(4512, 'test@gmail.com');
        Test.stopTest();
        
        System.assertEquals(200, responseWrapper.responseCode);
    }
    
    @isTest
    public static void testMakeUserAdminRequest() {
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationMakeUserAdminMock());
        
        Test.startTest();
        BluescapeIntegration.ResponseWrapper responseWrapper = BluescapeIntegration.makeUserAdminRequest(4512, 12839);
        Test.stopTest();
        
        System.assertEquals(200, responseWrapper.responseCode);
    }
    
    @isTest
    public static void testCopyWorkspaceRequest() {
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationCopyWorkspaceMock());
        
        Test.startTest();
        BluescapeIntegration.ResponseWrapper responseWrapper = BluescapeIntegration.copyWorkspaceRequest('workspaceName');
        Test.stopTest();
        
        System.assertEquals(200, responseWrapper.responseCode);
    }
    
    @isTest
    public static void testGetWorkspaceIdRequest() {
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationGetWorkspaceMock());
        
        Test.startTest();
        BluescapeIntegration.ResponseWrapper responseWrapper = BluescapeIntegration.getNewWorkspaceIdRequest('workspaceName');
        Test.stopTest();
        
        System.assertEquals(200, responseWrapper.responseCode);
    }
    
    @isTest
    public static void testMoveWorkspaceToOrgRequest() {
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationMoveWorkspaceMock());
        
        Test.startTest();
        BluescapeIntegration.ResponseWrapper responseWrapper = BluescapeIntegration.moveWorkspaceToOrgRequest(12935, 754152);
        Test.stopTest();
        
        System.assertEquals(200, responseWrapper.responseCode);
    }
    
    @isTest
    public static void testMakeWorkspacePublic() {
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationPublicWorkspaceMock());
        
        Test.startTest();
        BluescapeIntegration.ResponseWrapper responseWrapper = BluescapeIntegration.makeWorkspacePublic(754152);
        Test.stopTest();
        
        System.assertEquals(200, responseWrapper.responseCode);
    }
    
    @isTest
    public static void testExtendingOrgExpiration() {
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationExtendingOrgExpMock());
        
        Test.startTest();
        BluescapeIntegration.extendingOrgExpiration(10, 10);
        Test.stopTest();
    }
    
    @isTest
    public static void testRefreshAccessToken() {   
        Bluescape_API_Token__c bluescapeAPIToken = [
            	SELECT 
            		Refresh_Token__c, Expires_At__c, Access_Token__c, Client_ID__c, Client_Secret__c, Redirect_URI__c, Instance__c, Getting_Started_Workspace__c, Getting_Started_Workspace_Organization__c, API_Version__c
            	FROM 
            		Bluescape_API_Token__c LIMIT 1
        ];
        Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationRefreshTokenMock());
        
        Test.startTest();
        BluescapeIntegration.refreshAccessToken(bluescapeAPIToken);
        Test.stopTest();
    }
}
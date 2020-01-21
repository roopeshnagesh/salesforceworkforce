public class LeadIntegrationAdmin {

    @InvocableMethod (label = 'Create Admin on the Org')
    public static void configureOrgWithoutAdmin(List<Id> leadsIds) {
        
       makeAdminCreationCallouts(leadsIds[0]); 
    }
    
    @future (callout = true)
    public static void makeAdminCreationCallouts(Id leadId) {
        
        Lead lead = getLead(leadId);
        
        Integer orgId = Integer.valueOf(lead.Org_Id__c);
       
        Integer userId = null;

        String orgRootUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        String htmlRecordUrl = '<a href="' + orgRootUrl + leadId + '" target="_blank">' + orgRootUrl + leadId + '</a>';

        try {
            if (!Test.isRunningTest()) {
                if ((BluescapeIntegration.getUserForMakingAdminRequest(orgId, lead.Owner.Email)).userId != null) {
                    return;
                }
            }
            if (Test.isRunningTest()) {
                Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationCreateUserMock());
            }
            BluescapeIntegration.createUserRequest(orgId, lead.Owner.Email);

            if (Test.isRunningTest()) {
                Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationGetUserMock());
            }
            userId = BluescapeIntegration.getUserForMakingAdminRequest(orgId, lead.Owner.Email).userId;

            if (Test.isRunningTest()) {
                Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationMakeUserAdminMock());
            }
            BluescapeIntegration.makeUserAdminRequest(orgId, userId);

            UtilIntegration.updateBluescapeAPIInfo();

        } catch(BluescapeIntegration.ResponseException e) {
            UtilIntegration.updateBluescapeAPIInfo();

            String msgHtmlBody = '<p>Make user admin request failed.</p>';
            msgHtmlBody += '<p>' + e.getMessage() + '</p>' + '<p>' + htmlRecordUrl + '</p>';

            EmailManager.sendEmail(new List<String> {UtilIntegration.getErrorEmailAddress()}, 'Free Trial process failed', msgHtmlBody);
        }  
    }

    private static Lead getLead(Id leadId) {
        Lead lead = [
                SELECT
                    Id, Org_Id__c, Email, Owner.Email, Qty_of_Request__c, Org_Created__c
                FROM
                    Lead
                WHERE
                    Id = :leadId
        ];

        return lead;
    }
}
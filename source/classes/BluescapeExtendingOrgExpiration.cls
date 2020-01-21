public class BluescapeExtendingOrgExpiration {
    @InvocableMethod (label = 'Extending Org Expiration')
    public static void extendingOrgExpiration(List<Id> recordIds) {
        extendingOrgExpirationFuture(recordIds[0]);
    }
    
    @future (callout = true)
    public static void extendingOrgExpirationFuture(Id recordId) {
        String sObjectName = String.valueOf(recordId.getSObjectType());
        String queryStr;
        String orgRootUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        String htmlRecordUrl = '<a href="' + orgRootUrl + recordId + '" target="_blank">' + orgRootUrl + recordId + '</a>';

        if (sObjectName == 'ContactBluescapeOrg__c') {
           queryStr  = 'SELECT Bluescape_Org__r.Bluescape_Org_Id__c, Extension_Duration__c FROM ' + sObjectName + ' WHERE Id = :recordId';
        } else {
            queryStr = 'SELECT Org_Id__c, Extension_Duration__c FROM ' + sObjectName + ' WHERE Id = :recordId';
        }
        
        sObject sobj = Database.query(queryStr);

        Integer orgId = sObjectName == 'ContactBluescapeOrg__c' ? 
                                        Integer.valueOf(sobj.getSObject('Bluescape_Org__r').get('Bluescape_Org_Id__c')) : 
                                        Integer.valueOf(sobj.get('Org_Id__c'));
        Integer extensionDuration = Integer.valueOf(sobj.get('Extension_Duration__c'));
        
        try {
            BluescapeIntegration.extendingOrgExpiration(orgId, extensionDuration);
            saveExtendingResult(sObjectName, recordId, 'Success');
            
        } catch (BluescapeIntegration.ResponseException e) {
            saveExtendingResult(sObjectName, recordId, 'Fail');

            if (!Test.isRunningTest()){
                String msgHtmlBody = '<p>Org Duration Extension process failed, retry please.</p>';
                msgHtmlBody += '<p>' + e.getMessage() + '</p>' + '<p>' + htmlRecordUrl + '</p>';
                EmailManager.sendEmail(new List<String> {UtilIntegration.getErrorEmailAddress()}, 'Bluescape Demo Org Duration Extension Failed', msgHtmlBody);
            }
        }     
    }
    
    private static void saveExtendingResult(String sObjectName, Id recordId, String status) {
        String queryStr = 'SELECT Trial_Extended__c FROM ' + sObjectName + ' WHERE Id = :recordId';
        sObject sObj = Database.query(queryStr);
        sObj.put('Trial_Extended__c', status);
        
        update sObj;
    }
}
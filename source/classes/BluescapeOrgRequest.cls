public class BluescapeOrgRequest {
    
    @InvocableMethod (label = 'Bluescape Org Request')
    public static void configureBluescapeOrg(List<Id> recordIds) {
        configureOrg(recordIds[0]);
    }

    @future (callout = true)
    public static void configureOrg(Id recordId) {
        UtilIntegration.configureOrgProcess(recordId);
    }
}
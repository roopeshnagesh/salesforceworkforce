global class CommunityPermissionSetBatchUpdate implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext info)
    {
        PermissionSet permissionSet = [SELECT Id, LicenseId FROM PermissionSet WHERE Name = 'Support_User'];
        Id permissionSetId = permissionSet.Id;

        return Database.getQueryLocator('SELECT Id, ProfileId FROM User WHERE IsActive = true AND Id NOT IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :permissionSetId)');
    }

    global void execute(Database.BatchableContext info, List<sObject> scope)
    {
        PermissionSet permissionSet = [SELECT Id, LicenseId FROM PermissionSet WHERE Name = 'Support_User'];

        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();

        for(SObject obj : scope) {
            User user = (User) obj;

            PermissionSetAssignment assignment = new PermissionSetAssignment();
            assignment.AssigneeId = user.Id;
            assignment.PermissionSetId = permissionSet.Id;
            assignments.add(assignment);

            System.debug(assignment);
        }

        insert assignments;
    }

    global void finish(Database.BatchableContext info)
    {

    }
}
global class CommunityPermissionSetBatchRunner
{
    global void runJob()
    {
        CommunityPermissionSetBatchUpdate permissionBatchUpdate = new CommunityPermissionSetBatchUpdate();

        Database.executeBatch(permissionBatchUpdate, 50);
    }
}
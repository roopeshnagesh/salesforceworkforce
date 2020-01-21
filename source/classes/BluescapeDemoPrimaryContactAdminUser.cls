public class BluescapeDemoPrimaryContactAdminUser {

	@InvocableMethod (label = 'Bluescape Demo Create Primary Contact Admin User')
	public static void createAdminUser(List<Id> bluescapeDemoIds) {
		createUser(bluescapeDemoIds[0]);
	}

	@future (callout = true)
	public static void createUser(Id bluescapeDemoId) {
		Bluescape_Demo__c bluescapeDemo = [
				SELECT
					Org_Id__c, Owner.Email, Primary_Contact__r.Email, Created_Admin_User_For_Primary_Contact__c
				FROM
					Bluescape_Demo__c
				WHERE
					Id = :bluescapeDemoId
		];

		if (bluescapeDemo.Org_Id__c == null || bluescapeDemo.Primary_Contact__r.Email == null) return;

		Integer orgId = Integer.valueOf(bluescapeDemo.Org_Id__c);
		String email = bluescapeDemo.Primary_Contact__r.Email;

		Boolean createAdminUserSuccess = UtilIntegration.createAdminUser(orgId, email, false);

		if (createAdminUserSuccess) {
			bluescapeDemo.Created_Admin_User_For_Primary_Contact__c = 'Success';
		} else {
			bluescapeDemo.Created_Admin_User_For_Primary_Contact__c = 'Fail';
		}

		if (createAdminUserSuccess) {
			Contact primaryContact = [
					SELECT
						Org_Id__c
					FROM
						Contact
					WHERE
						Id = :bluescapeDemo.Primary_Contact__c
			];

			if (primaryContact.Org_Id__c == null) {
				primaryContact.Org_Id__c = bluescapeDemo.Org_Id__c;
			} else {
				primaryContact.Org_Id__c += ', ' + bluescapeDemo.Org_Id__c;
			}

			update primaryContact;
		}

		UtilIntegration.updateBluescapeAPIInfo();

		update bluescapeDemo;
	}
}
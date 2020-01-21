@isTest
public class BluescapeDemoPrimaryContactAdminUserTest {

	@isTest
	public static void testBluescapeDemoPrimaryContactAdminUser() {
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

		Account account = new Account(
				Name = 'Test Account',
				Type = 'Prospect',
				Pod__c = 'Central'
		);
		insert account;

		Contact contact = new Contact(
				LastName = 'Contact',
				Email = 'contact@email.com',
				AccountId = account.Id
		);
		insert contact;

		Opportunity opp = new Opportunity(
				Name = 'Test',
				AccountId = account.Id,
				StageName = '0-Pre-Opportunity',
				CloseDate = Date.today(),
				LeadSource = 'Direct traffic'
		);
		insert opp;

		Bluescape_Demo__c bluescapeDemo = new Bluescape_Demo__c(
				Primary_Contact__c = contact.Id,
				Opportunity__c = opp.Id,
				Demo_Duration__c = '7'
		);
		insert bluescapeDemo;

		Test.startTest();
		BluescapeDemoPrimaryContactAdminUser.createAdminUser(new List<Id>{bluescapeDemo.Id});
		Test.stopTest();

		Bluescape_Demo__c bluescapeDemoAfterCreateAdminUserInBS = [
				SELECT
					Created_Admin_User_For_Primary_Contact__c
				FROM
					Bluescape_Demo__c
				WHERE
					Id = :bluescapeDemo.Id LIMIT 1
		];
		System.assertEquals('Success', bluescapeDemoAfterCreateAdminUserInBS.Created_Admin_User_For_Primary_Contact__c);
	}
}
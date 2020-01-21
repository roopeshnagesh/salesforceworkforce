@isTest
public class UtilIntegrationTest {

	@TestSetup
	public static void setup() {
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
				LeadSource = 'Direct traffic',
				Type = 'New Business'
		);
		insert opp;

		Lead lead = new Lead(
				FirstName = 'Test',
				LastName = 'Lead',
				Email = 'test@gmail.com',
				Company = 'test',
				Free_Trial__c = false
		);
		insert lead;

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
	public static void testLeadIntegrationAllCalloutsSuccessMock() {
		Lead lead = [SELECT Id, Email, Owner.Email FROM Lead LIMIT 1];

		Test.startTest();
		BluescapeOrgRequest.configureBluescapeOrg(new List<Id>{lead.Id});
		Test.stopTest();

		Lead leadAfterInsert = [SELECT Org_Id__c FROM Lead WHERE Id = :lead.Id];
		System.assertNotEquals(null, leadAfterInsert.Org_Id__c);

		UtilIntegration.getErrorEmailAddress();
	}

	@isTest
	public static void testContactIntegrationAllCalloutsSuccessMock() {
		Account account = [SELECT Id FROM Account LIMIT 1];
		Contact contact = [SELECT Id FROM Contact LIMIT 1];

		Test.startTest();
		BluescapeOrgRequest.configureBluescapeOrg(new List<Id>{contact.Id});
		Test.stopTest();

		Bluescape_Org__c bluescapeOrg = [SELECT Name, Account__c FROM Bluescape_Org__c];
		ContactBluescapeOrg__c contactBluescapeOrg = [SELECT Bluescape_Org__c, Contact__c FROM ContactBluescapeOrg__c];

		System.assertEquals(account.Id, bluescapeOrg.Account__c);
		System.assertEquals(contact.Id, contactBluescapeOrg.Contact__c);
		System.assertEquals(bluescapeOrg.Id, contactBluescapeOrg.Bluescape_Org__c);
	}

	@isTest
	public static void testBluescapeDemoIntegrationAllCalloutsSuccessMock() {
		Contact contact = [SELECT Id FROM Contact LIMIT 1];
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

		Test.startTest();
		Bluescape_Demo__c bluescapeDemo = new Bluescape_Demo__c(
				Primary_Contact__c = contact.Id,
				Opportunity__c = opp.Id,
				Demo_Duration__c = '7'
		);
		insert bluescapeDemo;
		Test.stopTest();

		Bluescape_Demo__c bluescapeDemoAfterInsert = [
				SELECT
					Org_Id__c, Opportunity__r.Org_Id__c
				FROM
					Bluescape_Demo__c
				WHERE
					Id = :bluescapeDemo.Id
		];
		System.assertNotEquals(null, bluescapeDemoAfterInsert.Org_Id__c);
		System.assertNotEquals(null, bluescapeDemoAfterInsert.Opportunity__r.Org_Id__c);
	}

	@isTest
	public static void testSalesOrderIntegrationAllCalloutsSuccessMock() {
		Contact contact = [SELECT Id FROM Contact LIMIT 1];
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

		OpportunityContactRole oppContacRole = new OpportunityContactRole(
				OpportunityId = opp.Id,
				ContactId = contact.Id,
				IsPrimary = true
		);
		insert oppContacRole;

		Test.startTest();
		Sales_Order__c salesOrder = new Sales_Order__c(
				Name = 'test',
				Opportunity__c = opp.Id
		);
		insert salesOrder;
		Test.stopTest();

		Sales_Order__c salesOrderAfterInsert = [
				SELECT
					Org_Id__c, Primary_Contact__c, Bluescape_Org_Date__c
				FROM
					Sales_Order__c
				WHERE
					Id = :salesOrder.Id
		];

		System.assertNotEquals(null, salesOrderAfterInsert.Org_Id__c);
		System.assertEquals(contact.Id, salesOrderAfterInsert.Primary_Contact__c);
		System.assertEquals(Date.today(), salesOrderAfterInsert.Bluescape_Org_Date__c);
	}

	@isTest
	public static void testCreateOrgByLeadFailureMock() {
		Lead lead = [SELECT Id, Email, Owner.Email FROM Lead LIMIT 1];

		UtilIntegration.setFailingMock = true;
		UtilIntegration.sObjectType = 'Lead';
		UtilIntegration.lead = lead;
		UtilIntegration.recordId = lead.Id;

		Test.startTest();
		UtilIntegration.createOrg();
		Test.stopTest();
	}

	@isTest
	public static void testCreateOrgByContactFailureMock() {
		Contact contact = [SELECT Id, Email, Owner.Email FROM contact LIMIT 1];

		UtilIntegration.setFailingMock = true;
		UtilIntegration.sObjectType = 'Contact';
		UtilIntegration.contact = contact;
		UtilIntegration.recordId = contact.Id;

		Test.startTest();
		UtilIntegration.createOrg();
		Test.stopTest();
	}

	@isTest
	public static void testCreateOrgByBluescapeDemoFailureMock() {
		Contact contact = [SELECT Id FROM Contact LIMIT 1];
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
		Bluescape_Demo__c bluescapeDemo = new Bluescape_Demo__c(
				Primary_Contact__c = contact.Id,
				Opportunity__c = opp.Id,
				Demo_Duration__c = '7'
		);
		insert bluescapeDemo;

		Test.startTest();
		UtilIntegration.setFailingMock = true;
		UtilIntegration.sObjectType = 'Bluescape_Demo__c';
		UtilIntegration.bluescapeDemo = bluescapeDemo;
		UtilIntegration.recordId = bluescapeDemo.Id;

		UtilIntegration.createOrg();
		Test.stopTest();
	}

	@isTest
	public static void testCreateExternalUserFailureMock() {
		Lead lead = [SELECT Id, Email, Owner.Email FROM Lead LIMIT 1];

		UtilIntegration.setFailingMock = true;
		UtilIntegration.orgId = 123;
		UtilIntegration.sObjectType = 'Lead';
		UtilIntegration.lead = lead;
		UtilIntegration.recordId = lead.Id;
		UtilIntegration.qtyOfGetWSIdRequests = 0;

		Test.startTest();
		UtilIntegration.createExternalUser();
		Test.stopTest();
	}

	@isTest
	public static void testCopyWorkspaceFailureMock() {
		Lead lead = [SELECT Id, Email, Owner.Email FROM Lead LIMIT 1];

		UtilIntegration.setFailingMock = true;
		UtilIntegration.workspaceName = 'test';
		UtilIntegration.orgId = 123;
		UtilIntegration.sObjectType = 'Lead';
		UtilIntegration.lead = lead;
		UtilIntegration.recordId = lead.Id;
		UtilIntegration.qtyOfGetWSIdRequests = 0;

		Test.startTest();
		UtilIntegration.copyWorkspace();
		Test.stopTest();
	}

	@isTest
	public static void testGetCopiedWorkspaceIdFailureMock() {
		Lead lead = [SELECT Id, Email, Owner.Email FROM Lead LIMIT 1];

		UtilIntegration.setFailingMock = true;
		UtilIntegration.workspaceName = 'test';
		UtilIntegration.orgId = 123;
		UtilIntegration.sObjectType = 'Lead';
		UtilIntegration.lead = lead;
		UtilIntegration.recordId = lead.Id;
		UtilIntegration.qtyOfGetWSIdRequests = 0;

		Test.startTest();
		UtilIntegration.getCopiedWorkspaceId();
		Test.stopTest();
	}

	@isTest
	public static void testMoveWorkspaceToOrgFailureMock() {
		Lead lead = [SELECT Id, Email, Owner.Email FROM Lead LIMIT 1];

		UtilIntegration.setFailingMock = true;
		UtilIntegration.workspaceName = 'test';
		UtilIntegration.orgId = 123;
		UtilIntegration.workspaceId = 123;
		UtilIntegration.sObjectType = 'Lead';
		UtilIntegration.lead = lead;
		UtilIntegration.recordId = lead.Id;
		UtilIntegration.qtyOfGetWSIdRequests = 0;

		Test.startTest();
		UtilIntegration.moveWorkspaceToOrg();
		Test.stopTest();
	}

	@isTest
	public static void testMakeWorkspacePublicFailureMock() {
		Lead lead = [SELECT Id, Email, Owner.Email FROM Lead LIMIT 1];

		UtilIntegration.setFailingMock = true;
		UtilIntegration.workspaceName = 'test';
		UtilIntegration.orgId = 123;
		UtilIntegration.workspaceId = 123;
		UtilIntegration.sObjectType = 'Lead';
		UtilIntegration.lead = lead;
		UtilIntegration.recordId = lead.Id;
		UtilIntegration.qtyOfGetWSIdRequests = 0;

		Test.startTest();
		UtilIntegration.makeWorkspacePublic();
		Test.stopTest();
	}

	@isTest
	public static void testCreateExtraAdminUserInBluescape() {
		Lead lead = [SELECT Id FROM Lead LIMIT 1];

		Test.startTest();
		UtilIntegration.createExtraAdminUserInBluescape(1, lead.Id);
		Test.stopTest();

		Lead leadAfterCreateAdminUser = [SELECT Sales_Resource__c FROM Lead WHERE Id = :lead.Id];
		System.assertEquals(UserInfo.getUserId(), leadAfterCreateAdminUser.Sales_Resource__c);
	}

	@isTest
	public static void testCreateExtraAdminUserInBluescapeFailureMock() {
		UtilIntegration.setFailingMock = true;
		Boolean failed;
		Lead lead = [SELECT Id FROM Lead LIMIT 1];

		Test.startTest();
		try {
			UtilIntegration.createExtraAdminUserInBluescape(1, lead.Id);
		} catch (Exception e) {
			failed = true;
		}
		Test.stopTest();

		System.assert(failed);

		Lead leadAfterCreateAdminUser = [SELECT Sales_Resource__c FROM Lead WHERE Id = :lead.Id];
		System.assertEquals(null, leadAfterCreateAdminUser.Sales_Resource__c);
	}
}
public class UtilIntegration {

	public static Boolean setFailingMock = false;
	public static Integer orgId;
	public static Integer workspaceId;
	public static Integer qtyOfGetWSIdRequests = 0;
	public static Contact contact;
	public static Contact salesOrderOpportunityPrimaryContact;
	public static Lead lead;
	public static Bluescape_Demo__c bluescapeDemo;
	public static Sales_Order__c salesOrder;
	public static String workspaceName;
	public static Bluescape_API_Token__c bluescapeAPIInfo;
	public static String bluescapeExternalUserEmail;
	public static String bluescapeAdminUserEmail;
	public static Id recordId;
	public static String sObjectType;
	public static String htmlRecordUrl;
	public static String bluescapeDemoPrimaryContactEmail;
	public static String statusOfCreatingBluescapeDemoAdminUserForPrimContact;

	public static void configureOrgProcess(Id objectId) {
		recordId = objectId;
		sObjectType = String.valueOf(recordId.getSObjectType());
		String orgRootUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
		htmlRecordUrl = '<a href="' + orgRootUrl + recordId + '" target="_blank">' + orgRootUrl + recordId + '</a>';

		if (sObjectType == 'Contact') {
			contact = getContact();

			if (contact.Email == null) {
				System.debug('Contact must have populate Email field');
				return;
			}

			bluescapeExternalUserEmail = contact.Email;
			bluescapeAdminUserEmail = contact.Owner.Email;

		} else if (sObjectType == 'Lead') {
			lead = getLead();

			if (lead.Email == null) {
				System.debug('Lead must have populate Email field');
				return;
			}

			bluescapeExternalUserEmail = lead.Email;
			bluescapeAdminUserEmail = lead.Owner.Email;

		} else if (sObjectType == 'Bluescape_Demo__c') {
			bluescapeDemo = getBluescapeDemo();
			bluescapeDemoPrimaryContactEmail = bluescapeDemo.Primary_Contact__r.Email;

			bluescapeAdminUserEmail = bluescapeDemo.Owner.Email;

		} else if (sObjectType == 'Sales_Order__c') {
			salesOrder = getSalesOrder();

			List<OpportunityContactRole> oppPrimaryRole = [
					SELECT
						ContactId
					FROM
						OpportunityContactRole
					WHERE
						OpportunityId = :salesOrder.Opportunity__c AND IsPrimary = true LIMIT 1
			];

			if (oppPrimaryRole.isEmpty()) {
				System.debug('Opportunity does not has Primary Contact');
				return;
			}

			salesOrderOpportunityPrimaryContact = [
					SELECT
						Id, Email
					FROM
						Contact
					WHERE
						Id = :oppPrimaryRole[0].ContactId
			];

			if (salesOrderOpportunityPrimaryContact.Email == null) {
				System.debug('Primary Contact must have populate Email field');
				return;
			}

			bluescapeExternalUserEmail = salesOrderOpportunityPrimaryContact.Email;
			bluescapeAdminUserEmail = salesOrder.Owner.Email;
		}

		workspaceName = 'Getting Started with Your Free Trial [' + String.valueOf(Datetime.now()) + ']';

		orgId = createOrg();
		if (orgId == null) return;

		Boolean createAdminUserSuccess = createAdminUser(orgId, bluescapeAdminUserEmail, true);
		if (createAdminUserSuccess == false) return;

		if (bluescapeDemoPrimaryContactEmail != null) {
			Boolean createAdminUserForPrimContactSuccess = createAdminUser(orgId, bluescapeDemoPrimaryContactEmail, true);

			if (createAdminUserForPrimContactSuccess == false) {
				statusOfCreatingBluescapeDemoAdminUserForPrimContact = 'Fail';

				return;
			}
			statusOfCreatingBluescapeDemoAdminUserForPrimContact = 'Success';
		}

		if (bluescapeExternalUserEmail != null) {
			Boolean createExternalUserSuccess = createExternalUser();
			if (createExternalUserSuccess == false) return;
		}

		Boolean copyWorkspaceBooleanSuccess = copyWorkspace();
		if (copyWorkspaceBooleanSuccess == false) return;

		WorkspaceIdWrapper workspaceIdWrapper = getCopiedWorkspaceId();
		if (workspaceIdWrapper != null) {
			workspaceId = workspaceIdWrapper.workspaceId;
			qtyOfGetWSIdRequests = workspaceIdWrapper.qtyOfGetWSIdRequests;
		} else {
			return;
		}

		Boolean moveWorkspaceToOrgSuccess = moveWorkspaceToOrg();
		if (moveWorkspaceToOrgSuccess == false) return;

		Boolean makeWorkspacePublicSuccess = makeWorkspacePublic();
		if (makeWorkspacePublicSuccess == false) return;

		updateCurrentRecord('Yes - Success');
		updateBluescapeAPIInfo();
	}

	public static Integer createOrg() {
		try {
			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationRequestOrgMock());
			}

			Integer durationDays = 35;
			if (sObjectType == 'Bluescape_Demo__c' && bluescapeDemo.Demo_Duration__c != null) {
				durationDays = Integer.valueOf(bluescapeDemo.Demo_Duration__c);
			} else if (sObjectType == 'Sales_Order__c') {
				durationDays = 396;
			}

			String orgName;
			if (sObjectType == 'Bluescape_Demo__c') {
				orgName = 'Demo: ' + bluescapeDemo.Opportunity__r.Name;
			} else if (sObjectType == 'Sales_Order__c') {
				orgName = salesOrder.Account__r.Name;
			} else {
				orgName = 'Trial: ' + bluescapeExternalUserEmail;
			}

			return BluescapeIntegration.makeOrgRequest(orgName, durationDays).orgId;

		} catch (BluescapeIntegration.ResponseException e) {
			sendErrorEmail('Free Trial process failed', 'Create org process failed, retry please.', e.getMessage());

			updateBluescapeAPIInfo();

			String queryStr = 'SELECT Org_Created__c FROM ' + recordId.getSObjectType() + ' WHERE Id = :recordId';
			sObject sObj = Database.query(queryStr);
			sObj.put('Org_Created__c', 'No - Create New Org Failed');

			update sObj;

			return null;
		}
	}

	public static Boolean createAdminUser(Integer bluescapeOrgId, String email, Boolean updateRecord) {
		if (email == 'admin@bluescape.com' || (sObjectType != null && sObjectType == 'Lead' && lead.OwnerId.getSobjectType() != User.SObjectType)) {
			return true;
		}

		try {
			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationCreateUserMock());
			}
			BluescapeIntegration.createUserRequest(bluescapeOrgId, email);

			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationGetUserMock());
			}
			Integer userId = BluescapeIntegration.getUserForMakingAdminRequest(bluescapeOrgId, email).userId;

			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationMakeUserAdminMock());
			}
			BluescapeIntegration.makeUserAdminRequest(bluescapeOrgId, userId);

			return true;

		} catch (BluescapeIntegration.ResponseException e) {
			sendErrorEmail('Free Trial process failed', 'Create Admin user in new Org process failed.', e.getMessage());

			updateBluescapeAPIInfo();

			if (updateRecord) {
				updateCurrentRecord('No - Create Admin User Failed');
			}

			return false;
		}
	}

	public static Boolean createExternalUser() {
		try {
			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationCreateUserMock());
			}
			BluescapeIntegration.createUserRequest(orgId, bluescapeExternalUserEmail);

			return true;
		} catch (BluescapeIntegration.ResponseException e) {
			sendErrorEmail('Free Trial process failed', 'Create external user in new Org process failed, retry please.',
					e.getMessage());

			updateCurrentRecord('No - Create External User Failed');
			updateBluescapeAPIInfo();

			return false;
		}
	}

	public static Boolean copyWorkspace() {
		try {
			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationCopyWorkspaceMock());
			}
			BluescapeIntegration.copyWorkspaceRequest(workspaceName);

			return true;
		} catch (BluescapeIntegration.ResponseException e) {
			sendErrorEmail('Free Trial process failed', 'Copying Workspace process failed, retry please.', e.getMessage());

			updateCurrentRecord('No - Copying Workspace Failed');
			updateBluescapeAPIInfo();

			return false;
		}
	}

	public static WorkspaceIdWrapper getCopiedWorkspaceId() {
		try {
			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationGetWorkspaceMock());
			}

			//We need to wait some time after copying Workspace to get it Id, so we created a loop to set fake timeout (≈ 2 sec)
			for (Integer i = 1; i <= 20; i++) {
				try {
					//fake timeout (≈ 2 sec)
					Long startingTime = System.now().getTime();
					Integer delayInMilliseconds = 2000; // two seconds delay
					while (System.now().getTime() - startingTime < delayInMilliseconds) {
						// Do nothing until desired delay has passed
					}

					Integer workspaceId = BluescapeIntegration.getNewWorkspaceIdRequest(workspaceName).workspaceId;

					return new WorkspaceIdWrapper(workspaceId, i);
				} catch (ListException le) {
					System.debug('Copied workspace currently not available, please try later: ' + le.getMessage());
				}
			}

			return null;

		} catch (BluescapeIntegration.ResponseException e) {
			sendErrorEmail('Free Trial process failed', 'Get Workspace id process failed, retry please.', e.getMessage());

			updateCurrentRecord('No - Get Copied Workspace Id Failed');
			updateBluescapeAPIInfo();
			return null;
		}
	}

	public static Boolean moveWorkspaceToOrg() {
		try {
			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationMoveWorkspaceMock());
			}
			BluescapeIntegration.moveWorkspaceToOrgRequest(orgId, workspaceId);

			return true;
		} catch (BluescapeIntegration.ResponseException e) {
			sendErrorEmail('Free Trial process failed', 'Moving Workspace to Org process failed, retry please.', e.getMessage());

			updateCurrentRecord('No - Move Workspace To Org Failed');
			updateBluescapeAPIInfo();

			return false;
		}
	}

	public static Boolean makeWorkspacePublic() {
		try {
			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationPublicWorkspaceMock());
			}
			BluescapeIntegration.makeWorkspacePublic(workspaceId);

			return true;
		} catch (BluescapeIntegration.ResponseException e) {
			sendErrorEmail('Free Trial process failed', 'Get Workspace id process failed, retry please.', e.getMessage());

			updateCurrentRecord('No - Make Workspace Public Failed');
			updateBluescapeAPIInfo();

			return false;
		}
	}

	@AuraEnabled
	public static void createExtraAdminUserInBluescape(Integer orgId, Id recordId) {
		String currentUserEmail = UserInfo.getUserEmail();
		Id currentUserId = UserInfo.getUserId();

		try {
			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationCreateUserMock());
			}
			BluescapeIntegration.createUserRequest(orgId, currentUserEmail);

			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationGetUserMock());
			}
			Integer userId = BluescapeIntegration.getUserForMakingAdminRequest(orgId, currentUserEmail).userId;

			if (Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new BluescapeIntegrationMakeUserAdminMock());
			}
			BluescapeIntegration.makeUserAdminRequest(orgId, userId);

			updateBluescapeAPIInfo();

			String recordsObjectType = String.valueOf(recordId.getSObjectType());
			String queryStr = 'SELECT ' +
									'Sales_Resource__c  ' +
								' FROM ' +
									recordsObjectType +
								' WHERE ' +
									'Id = :recordId';

			sObject sObj = Database.query(queryStr);
			sObj.put('Sales_Resource__c', currentUserId);

			update sObj;

		} catch (BluescapeIntegration.ResponseException e) {
			updateBluescapeAPIInfo();

			throw new AuraHandledException(e.getMessage());
		}
	}

	public static void createBluescapeOrgRecord(Contact contact, Integer orgId) {
		Bluescape_Org__c bluescapeOrg = new Bluescape_Org__c(
				Name = contact.Account.Name,
				Account__c = contact.AccountId,
				Bluescape_Org_ID__c = orgId,
				Portal_Created_Date__c = date.today(),
				Plan__c = 'Enterprise'
		);
		insert bluescapeOrg;

		ContactBluescapeOrg__c ContactBluescapeOrg = new ContactBluescapeOrg__c(
				Bluescape_Org__c = bluescapeOrg.Id,
				Contact__c = contact.Id
		);
		insert ContactBluescapeOrg;
	}

	public static Contact getContact() {
		Contact c = [
				SELECT
					Id, Email, Owner.Email, AccountId, Account.Name, Org_Id__c, Qty_of_Request__c, Org_Created__c
				FROM
					Contact
				WHERE
					Id = :recordId
		];

		return c;
	}

	public static Lead getLead() {
		Lead lead = [
				SELECT
					Id, Org_Id__c, Email, Owner.Email, Qty_of_Request__c, Org_Created__c
				FROM
					Lead
				WHERE
					Id = :recordId
		];

		return lead;
	}

	public static Bluescape_Demo__c getBluescapeDemo() {
		Bluescape_Demo__c bluescapeDemo = [
				SELECT
					Org_Id__c, Owner.Email, Qty_of_Request__c, Org_Created__c, Demo_Duration__c,
					Primary_Contact__r.Email, Created_Admin_User_For_Primary_Contact__c, Opportunity__c,
					Opportunity__r.Name
				FROM
					Bluescape_Demo__c
				WHERE
					Id = :recordId
		];

		return bluescapeDemo;
	}

	public static Sales_Order__c getSalesOrder() {
		Sales_Order__c salesOrder = [
				SELECT
					Owner.Email, Opportunity__c, Account__r.Name
				FROM
					Sales_Order__c
				WHERE
					Id = :recordId
		];

		return salesOrder;
	}

	public static String getErrorEmailAddress() {
		Bluescape_API_Token__c bluescapeAPIInfo = [
				SELECT
					Error_Email__c
				FROM
					Bluescape_API_Token__c
				WHERE
					Name = 'Bluescape_Api_Integration' LIMIT 1
		];

		return bluescapeAPIInfo.Error_Email__c;
	}

	private static void updateCurrentRecord(String createStatus) {
		if (sObjectType == 'Contact') {
			createBluescapeOrgRecord(contact, orgId);
		}

		String queryStr = 'SELECT ' +
								'Org_Id__c, Org_Created__c, Qty_of_Request__c ' +
								(sObjectType == 'Bluescape_Demo__c' ? ', Created_Admin_User_For_Primary_Contact__c, Opportunity__c' : '') +
								(sObjectType == 'Sales_Order__c' ? ', Bluescape_Org_Date__c, Primary_Contact__c' : '') +
							' FROM ' +
								sObjectType +
							' WHERE ' +
								'Id = :recordId';

		sObject sObj = Database.query(queryStr);

		sObj.put('Org_Id__c', String.valueOf(orgId));
		sObj.put('Org_Created__c', createStatus);
		sObj.put('Qty_of_Request__c', qtyOfGetWSIdRequests);

		if (sObjectType == 'Sales_Order__c') {
			sObj.put('Bluescape_Org_Date__c', Date.today());
			sObj.put('Primary_Contact__c', salesOrderOpportunityPrimaryContact.Id);
		}

		if (sObjectType == 'Bluescape_Demo__c') {
			sObj.put('Created_Admin_User_For_Primary_Contact__c', statusOfCreatingBluescapeDemoAdminUserForPrimContact);

			if (statusOfCreatingBluescapeDemoAdminUserForPrimContact == 'Success') {
				Contact primaryContact = [
						SELECT
							Org_Id__c
						FROM
							Contact
						WHERE
							Id = :bluescapeDemo.Primary_Contact__c
				];

				if (primaryContact.Org_Id__c == null) {
					primaryContact.Org_Id__c = String.valueOf(orgId);
				} else {
					primaryContact.Org_Id__c += ', ' + String.valueOf(orgId);
				}

				update primaryContact;
			}
		}

		update sObj;

		if (sObjectType == 'Bluescape_Demo__c') {
			String opportunityId = String.valueOf(sObj.get('Opportunity__c'));
			Opportunity opportunity = [
					SELECT
						Org_Id__c
					FROM
						Opportunity
					WHERE
						Id = :opportunityId
			];
			opportunity.Org_Id__c = String.valueOf(orgId);

			update opportunity;
		}
	}

	public static void updateBluescapeAPIInfo() {
		if (bluescapeAPIInfo != null) {
			update bluescapeAPIInfo;
		}
	}

	public static void sendErrorEmail(String msgSubject, String msg, String errorMsg) {
		String msgHtmlBody = '<p>' + msg + '</p>';
		msgHtmlBody += '<p>' + errorMsg + '</p>' + '<p>' + htmlRecordUrl + '</p>';

		try {
			EmailManager.sendEmail(new List<String> {getErrorEmailAddress(), 'yaroslav.pazhukh@wiserspread.com'}, msgSubject, msgHtmlBody);
		} catch (Exception e) {
			System.debug(e);
		}
	}

	public class WorkspaceIdWrapper {
		Integer workspaceId;
		Integer qtyOfGetWSIdRequests;

		public WorkspaceIdWrapper(Integer workspaceId, Integer qtyOfGetWSIdRequests) {
			this.workspaceId = workspaceId;
			this.qtyOfGetWSIdRequests = qtyOfGetWSIdRequests;
		}
	}
}
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class TestPartnerPortalController {

    static testMethod void myUnitTest() {
		PartnerPortalController controller = new PartnerPortalController();
		PageReference pg = controller.portalSignIn();
		
		// Create Contact
		controller.addressLine = '';
		pg = controller.createPartnerContact();
		controller.partnerContact.FirstName = 'First Name';
		pg = controller.createPartnerContact();
		controller.partnerContact.LastName = 'Last Name';
		pg = controller.createPartnerContact();
		controller.partnerContact.Email = 'testEmail@mail123.com';
		pg = controller.createPartnerContact();
		controller.company = 'company';
		pg = controller.createPartnerContact();
		controller.partnerContact.Job_Role__c = 'Job_Role';
		pg = controller.createPartnerContact();
		controller.partnerContact.Title = 'Title';
		pg = controller.createPartnerContact();
		controller.partnerContact.Phone = 'Phone';
		pg = controller.createPartnerContact();
		controller.addressLine = 'addressLine';
		pg = controller.createPartnerContact();
		controller.partnerContact.MailingCity = 'MailingCity';
		pg = controller.createPartnerContact();
		controller.partnerContact.MailingPostalCode = '98765';
		pg = controller.createPartnerContact();
		controller.partnerAccount.BillingStateCode = 'CA';
		pg = controller.createPartnerContact();
		controller.partnerAccount.BillingCountryCode = 'US';
		pg = controller.createPartnerContact();

		controller.partnerContact.Is_Haworth__c = false;
		controller.partnerContact.Is_JBA__c = false;
		pg = controller.createPartnerContact();

		controller.partnerContact.Is_Haworth__c = true;
		controller.partnerContact.Is_JBA__c = true;
		pg = controller.createPartnerContact();

		controller.partnerContact.Is_Haworth__c = true;
		controller.partnerContact.Is_JBA__c = false;
		pg = controller.createPartnerContact();

		controller.addressLine = '';

		// Create Lead
		pg = controller.createNewLead();
		controller.lead.FirstName = 'First Name';
		pg = controller.createNewLead();
		controller.lead.LastName = 'Last Name';
		pg = controller.createNewLead();
		controller.lead.Title = 'Title';
		pg = controller.createNewLead();
		controller.lead.Company = 'Company';
		pg = controller.createNewLead();
		controller.lead.Department__c = 'Department';
		pg = controller.createNewLead();
		controller.lead.Email = 'testEmail@mail123.com';
		pg = controller.createNewLead();
		controller.lead.Phone = 'Phone';
		pg = controller.createNewLead();
		controller.addressLine = 'addressLine';
		pg = controller.createNewLead();
		controller.lead.City = 'City';
		pg = controller.createNewLead();
		controller.lead.StateCode = 'CA';
		pg = controller.createNewLead();
		controller.lead.PostalCode = '98765';
		pg = controller.createNewLead();
		controller.lead.Details__c = 'Details';
		pg = controller.createNewLead();

    }
}
/*
 * File Name    : PartnerPortalController.cls
 * Description  : Apex Class to manage Partner Portal activities.
 * 
 * Modification Log
================================================================================
 * Ver    Date              	Author                Modification
--------------------------------------------------------------------------------
 * 1.0    01/09/2014         	Bluescape
 * 
*/

public without sharing class PartnerPortalController {

	public String username {get;set;}
	public String password {get;set;}
	public Account partnerAccount {get;set;}
	public Contact partnerContact {get;set;}
	public String company {get;set;}
	public String addressLine {get;set;}
	public Lead lead {get;set;}
	public Contact currentUserContact {get;set;}
	
	public PartnerPortalController() {
        partnerAccount = new Account();
        partnerContact = new Contact();
		partnerContact.Is_Haworth__c = false;
		partnerContact.Is_JBA__c = false;
        lead = new Lead();
		lead.Is_Fortune_100__c = false;
		lead.Is_Global_Account__c = false;
		// lead.Details__c = 'Tell us a little about your project.';
		try {
			User currentUser = [select Id, ContactId from User where Id = :UserInfo.getUserId()];
			if (currentUser.ContactId != null) {
				currentUserContact = [select Id, FirstName, LastName, Account.Name, Email, Phone from Contact where Id = :currentUser.ContactId];
			} else {
				currentUserContact = new Contact();
			}
		} catch (Exception e) {
			
		}
	}

	public PageReference portalSignIn() {
		try {
			PageReference pg = Site.login(username, password, '/apex/PortalPartner');
			return pg;
		} catch (Exception e) {
			return null;
		}
		return null;
	}
	
	public PageReference createPartnerContact() {
		boolean success = checkContactFields();
		if (!success) {
		    return null;
		}
		List<Contact> partnerContacts = [select Id from Contact where Email = :partnerContact.Email];
		if (partnerContacts.size() > 0) {
			ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Partner already exist with provided email.'); 
			ApexPages.addMessage(errorMessage);
			return null;
		}

		partnerAccount.Name = company;
		partnerAccount.BillingStreet = addressLine;
		partnerAccount.BillingCity = partnerContact.MailingCity;
		partnerAccount.BillingPostalCode = partnerContact.MailingPostalCode;
		partnerAccount.Phone = partnerContact.Phone;
		insert partnerAccount;
		
        partnerContact.AccountId = partnerAccount.Id;
        partnerContact.MailingStreet = addressLine;
        partnerContact.MailingState = partnerAccount.BillingState;
        partnerContact.MailingCountry = partnerAccount.BillingCountry;
        insert partnerContact;

		PageReference pg = new Pagereference('/apex/PortalThankyou').setRedirect(true);
		pg.setRedirect(true);
		return pg;

	}

	private Boolean checkContactFields() {
        boolean success = true;
        String errorMessage = '';
        if (partnerContact.FirstName == null || ''.equals(partnerContact.FirstName.trim())) {
            errorMessage = errorMessage + '<li>First Name.</li>';
            success = false;
        }
        if (partnerContact.LastName == null || ''.equals(partnerContact.LastName.trim())) {
            errorMessage = errorMessage + '<li>Last Name.</li>';
            success = false;
        }
        if (partnerContact.Email == null || ''.equals(partnerContact.Email.trim())) {
            errorMessage = errorMessage + '<li>Email.</li>';
            success = false;
        }
        if (company == null || ''.equals(company.trim())) {
            errorMessage = errorMessage + '<li>Company.</li>';
            success = false;
        }
        if (partnerContact.Job_Role__c == null || ''.equals(partnerContact.Job_Role__c.trim())) {
            errorMessage = errorMessage + '<li>Job Role.</li>';
            success = false;
        }
        if (partnerContact.Title == null || ''.equals(partnerContact.Title.trim())) {
            errorMessage = errorMessage + '<li>Title.</li>';
            success = false;
        }
        if (partnerContact.Phone == null || ''.equals(partnerContact.Phone.trim())) {
            errorMessage = errorMessage + '<li>Phone.</li>';
            success = false;
        }
        if (addressLine == null || ''.equals(addressLine.trim())) {
            errorMessage = errorMessage + '<li>Address.</li>';
            success = false;
        }
        if (partnerContact.MailingCity == null || ''.equals(partnerContact.MailingCity.trim())) {
            errorMessage = errorMessage + '<li>City.</li>';
            success = false;
        }
        /*
        if (partnerAccount.BillingStateCode == null || ''.equals(partnerAccount.BillingStateCode.trim())) {
            errorMessage = errorMessage + '<li>State.</li>';
            success = false;
        }
        */
        if (partnerContact.MailingPostalCode == null || ''.equals(partnerContact.MailingPostalCode.trim())) {
            errorMessage = errorMessage + '<li>Zip.</li>';
            success = false;
        }
        if (partnerAccount.BillingCountryCode == null || ''.equals(partnerAccount.BillingCountryCode.trim())) {
            errorMessage = errorMessage + '<li>Country.</li>';
            success = false;
        }
        if (!partnerContact.Is_Haworth__c && !partnerContact.Is_JBA__c) {
            errorMessage = errorMessage + '<li>Please select one option from Haworth and Reseller.</li>';
            success = false;
        }
        if (partnerContact.Is_Haworth__c && partnerContact.Is_JBA__c) {
            errorMessage = errorMessage + '<li>Please select only one option from Haworth and Reseller.</li>';
            success = false;
        }
        
        if (!success) {
            errorMessage = 'Following fields are required for partner registration, <br/> <ul>' + errorMessage + '</ul>';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        }
        return success;
	}

	public PageReference createNewLead() {
		boolean success = checkLeadFields();
		if (!success) {
		    return null;
		}
		try {
			lead.Street = addressLine;
			lead.LeadSource = 'Partner';
			insert lead;
		} catch (Exception e) {
			System.debug(' >>>>>> Lead Exception : \n\n ' + e.getMessage());
		}
		
		PageReference pg = new Pagereference('/apex/LeadThankyou').setRedirect(true);
		pg.setRedirect(true);
		return pg;

	}

	private Boolean checkLeadFields() {
        boolean success = true;
        String errorMessage = '';
        if (lead.FirstName == null || ''.equals(lead.FirstName.trim())) {
            errorMessage = errorMessage + '<li>First Name.</li>';
            success = false;
        }
        if (lead.LastName == null || ''.equals(lead.LastName.trim())) {
            errorMessage = errorMessage + '<li>Last Name.</li>';
            success = false;
        }
        if (lead.Title == null || ''.equals(lead.Title.trim())) {
            errorMessage = errorMessage + '<li>Title.</li>';
            success = false;
        }
        if (lead.Company == null || ''.equals(lead.Company.trim())) {
            errorMessage = errorMessage + '<li>Company.</li>';
            success = false;
        }
        if (lead.Department__c == null || ''.equals(lead.Department__c.trim())) {
            errorMessage = errorMessage + '<li>Department.</li>';
            success = false;
        }
        if (lead.Email == null || ''.equals(lead.Email.trim())) {
            errorMessage = errorMessage + '<li>Email.</li>';
            success = false;
        }
        if (lead.Phone == null || ''.equals(lead.Phone.trim())) {
            errorMessage = errorMessage + '<li>Phone.</li>';
            success = false;
        }
        if (addressLine == null || ''.equals(addressLine.trim())) {
            errorMessage = errorMessage + '<li>Address.</li>';
            success = false;
        }
        if (lead.City == null || ''.equals(lead.City.trim())) {
            errorMessage = errorMessage + '<li>City.</li>';
            success = false;
        }
        if (lead.StateCode == null || ''.equals(lead.StateCode.trim())) {
            errorMessage = errorMessage + '<li>State.</li>';
            success = false;
        }
        if (lead.PostalCode == null || ''.equals(lead.PostalCode.trim())) {
            errorMessage = errorMessage + '<li>Zip.</li>';
            success = false;
        }
        if (lead.Details__c == null || ''.equals(lead.Details__c.trim())) {
            errorMessage = errorMessage + '<li>Details.</li>';
            success = false;
        }
        
        if (!success) {
            errorMessage = 'Following fields are required for Lead Registration, <br/> <ul>' + errorMessage + '</ul>';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        }
        return success;
		
	}
}
/*
 * File Name    : SalesOrderUtils.cls
 * Description  : Global Apex Class to manage Sales Order events.
 * 
 * Modification Log
================================================================================
 * Ver    Date              	Author                Modification
--------------------------------------------------------------------------------
 * 1.0    12/19/2014         	Bluescape
 * 
*/

global class SalesOrderUtils {

	webservice static String createServiceContract(Id salesOrderId) {
		try {
			
			List<ServiceContract> serviceContracts = [select Id from ServiceContract where Sales_Order__c = :salesOrderId];
			if (serviceContracts.size() > 0) {
				return 'Error: Service Contract already exist for this Sales Order, can not create new Service Contract';
			}
			
			// Using Standard Price Book as per discussion with Justus
			List<Pricebook2> pricebooks = [select Id, Name, IsActive, IsStandard, Description 
							from Pricebook2 where IsStandard = true and Name = 'Standard Price Book'];

			if (pricebooks.size() <= 0) {
				return 'Error: Standard Price Book not setup correctly, can not create new Service Contract';
			}
				
			Sales_Order__c salesOrder = [select Id, 
											Name, 
											Account__c, 
											Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState, Account__r.BillingPostalCode, Account__r.BillingCountry, 
											Account__r.ShippingStreet, Account__r.ShippingCity, Account__r.ShippingState, Account__r.ShippingPostalCode, Account__r.ShippingCountry, 
											Subtotal__c, 
											Service_Contract_Id__c, 
											Total__c 
										from Sales_Order__c 
										where Id = :salesOrderId];
			Account account = [select Id from Account where Id = :salesOrder.Account__c];
			ServiceContract serviceContract = new ServiceContract();
			serviceContract.Name = salesOrder.Name;
			serviceContract.Sales_Order__c = salesOrder.Id;
			serviceContract.Pricebook2Id = pricebooks[0].Id;
			serviceContract.AccountId = salesOrder.Account__c;
			serviceContract.Account = account;
/*			
			serviceContract.BillingStreet = salesOrder.Account__r.BillingStreet;
			serviceContract.BillingCity = salesOrder.Account__r.BillingCity;
			serviceContract.BillingState = salesOrder.Account__r.BillingState;
			serviceContract.BillingPostalCode = salesOrder.Account__r.BillingPostalCode;
			serviceContract.BillingCountry = salesOrder.Account__r.BillingCountry;
			serviceContract.ShippingStreet = salesOrder.Account__r.ShippingStreet;
			serviceContract.ShippingCity = salesOrder.Account__r.ShippingCity;
			serviceContract.ShippingState = salesOrder.Account__r.ShippingState;
			serviceContract.ShippingPostalCode = salesOrder.Account__r.ShippingPostalCode;
			serviceContract.ShippingCountry = salesOrder.Account__r.ShippingCountry;
*/			
			insert serviceContract;

			salesOrder.Service_Contract_Id__c = serviceContract.Id;
			update salesOrder;
			
			List<Sales_Order_Item__c> salesOrderItems = [select Item__c, 
											Description__c, 
											Quantity__c, 
											Price__c 
										from Sales_Order_Item__c 
										where Sales_Order__c = :salesOrderId];

			if (salesOrderItems.size() <= 0) {
				return serviceContract.Name;
			}
			String debugString = '\n\n\n ----------- Bluescape SalesOrderUtils.createServiceContract ------------ \n';
			Set<String> productIdSet = new Set<String>();
			Map<String, Id> productCode2PricebookEntryIdMap = new Map<String, Id>();
			Map<Id, Id> pricebookEntryId2ProductIdMap = new Map<Id, Id>();
			List<PricebookEntry> pricebookEntries = [select Id, Product2Id, ProductCode, UnitPrice, IsActive
															from PricebookEntry
															where Pricebook2Id = :pricebooks[0].Id
															order by ProductCode ];
			for (PricebookEntry pricebookEntry : pricebookEntries) {
				productCode2PricebookEntryIdMap.put(pricebookEntry.ProductCode, pricebookEntry.Id);
				pricebookEntryId2ProductIdMap.put(pricebookEntry.Id, pricebookEntry.Product2Id);
				productIdSet.add(pricebookEntry.Product2Id);
			}

			List<Entitlement_Template__c> entitlementTemplates = [select Id, Name, Entitlement_Type__c, 
																	Product__c, Use_Template_Quantity__c, Quantity__c, Period__c 
																from Entitlement_Template__c 
																where Product__c IN :productIdSet];
			debugString = debugString + '\tentitlementTemplates.size : ' + entitlementTemplates.Size() + '\n';
			debugString = debugString + '\tproductIdSet : ' + productIdSet + '\n';
			debugString = debugString + '\n-----------------------------------------------------------\n\n';
			System.debug(debugString);
			Map<Id, List<Entitlement_Template__c>> entitlementTemplateMap = new Map<Id, List<Entitlement_Template__c>>();
			for (Entitlement_Template__c entitlementTemplate : entitlementTemplates) {
				List<Entitlement_Template__c> entitlementTemplateList = entitlementTemplateMap.get(entitlementTemplate.Product__c);
				if (entitlementTemplateList == null) {
					entitlementTemplateList = new List<Entitlement_Template__c>();
				}
				entitlementTemplateList.add(entitlementTemplate);
				entitlementTemplateMap.put(entitlementTemplate.Product__c, entitlementTemplateList);
			}

			List<ContractLineItem> newContractLineItemList = new List<ContractLineItem>();
			for (Sales_Order_Item__c salesOrderItem : salesOrderItems) {
				Id pricebookEntryId = productCode2PricebookEntryIdMap.get(salesOrderItem.Item__c);
				if (pricebookEntryId == null) {
					// Sales Order line item has wrong product code, can not create contract line item
					continue;
				}
				ContractLineItem contractLineItem = new ContractLineItem();
				contractLineItem.ServiceContractId = serviceContract.Id;
				contractLineItem.PricebookEntryId = pricebookEntryId;
				contractLineItem.Description = salesOrderItem.Description__c;
				contractLineItem.Quantity = salesOrderItem.Quantity__c;
				contractLineItem.UnitPrice = salesOrderItem.Price__c;
				newContractLineItemList.add(contractLineItem);
			}
			if (newContractLineItemList.size() > 0) {
				insert newContractLineItemList;
			}
			
			List<Entitlement> entitlementList = new List<Entitlement>();
			for (ContractLineItem contractLineItem : newContractLineItemList) {
				Id productId = pricebookEntryId2ProductIdMap.get(contractLineItem.PricebookEntryId);
				List<Entitlement_Template__c> entitlementTemplateList = entitlementTemplateMap.get(productId);
				if (entitlementTemplateList != null && entitlementTemplateList.size() > 0) {
					for (Entitlement_Template__c entitlementTemplate : entitlementTemplateList) {
						if (entitlementTemplate.Use_Template_Quantity__c) {
							for (Integer q = 0; q < contractLineItem.Quantity; q++) {
								Entitlement entitlement = new Entitlement();
								entitlement.Name = entitlementTemplate.Name;
								entitlement.AccountId = serviceContract.Account.Id;
								// entitlement.AssetId = serviceContract.Account;
								entitlement.ContractLineItemId = contractLineItem.Id;
								entitlement.Type = entitlementTemplate.Entitlement_Type__c;
								entitlement.ServiceContractId = serviceContract.Id;
								entitlement.Quantity__c = entitlementTemplate.Quantity__c;
                                entitlement.Period__c = entitlementTemplate.Period__c;
								entitlementList.add(entitlement);
								
							}
						} else {
							Entitlement entitlement = new Entitlement();
							entitlement.Name = entitlementTemplate.Name;
							entitlement.AccountId = serviceContract.Account.Id;
							// entitlement.AssetId = serviceContract.Account;
							entitlement.ContractLineItemId = contractLineItem.Id;
							entitlement.Type = entitlementTemplate.Entitlement_Type__c;
							entitlement.ServiceContractId = serviceContract.Id;
							entitlement.Quantity__c = contractLineItem.Quantity;
                            entitlement.Period__c = entitlementTemplate.Period__c;
							entitlementList.add(entitlement);
						}
					}
				}
			}
			if (entitlementList.size() > 0) {
				insert entitlementList;
			}
			
			return serviceContract.Name;
		} catch (Exception e) {
			return e.getMessage();
		}
	}
}
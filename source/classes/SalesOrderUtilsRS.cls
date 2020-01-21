/*
 * File Name    : SalesOrderUtilsRS.cls
 * Description  : Global Apex Class to manage Sales Order events.
 * 
 * Modification Log
================================================================================
 * Ver    Date              	Author                Modification
--------------------------------------------------------------------------------
 * 1.0    7/24/2015         	Justus
 * 
*/

global class SalesOrderUtilsRS {

	webservice static String createServiceContract(Id salesOrderId) {
		try {
			
			List<ServiceContract> serviceContracts = [select Id from ServiceContract where Sales_Order_Header__c  = :salesOrderId];
			if (serviceContracts.size() > 0) {
				return 'Error: Service Contract already exist for this Sales Order, can not create new Service Contract';
			}
			
			// Using Standard Price Book all sellable product should be on this pricebook
			List<Pricebook2> pricebooks = [select Id, Name, IsActive, IsStandard, Description 
							from Pricebook2 where IsStandard = true and Name = 'Standard Price Book'];

			if (pricebooks.size() <= 0) {
				return 'Error: Standard Price Book not setup correctly, can not create new Service Contract';
			}
				
			rstk__sohdr__c  salesOrder = [select Id, 
											Name, 
											rstk__sohdr_account__c, 
											//Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState, Account__r.BillingPostalCode, Account__r.BillingCountry, 
											//Account__r.ShippingStreet, Account__r.ShippingCity, Account__r.ShippingState, Account__r.ShippingPostalCode, Account__r.ShippingCountry, 
											//Subtotal__c, 
											Service_Contract_Id__c, 
											rstk__sohdr_totamt__c  
										from rstk__sohdr__c  
										where Id = :salesOrderId];
			Account account = [select Id from Account where Id = :salesOrder.rstk__sohdr_account__c];
			ServiceContract serviceContract = new ServiceContract();
			serviceContract.Name = salesOrder.Name;
			serviceContract.Sales_Order_Header__c  = salesOrder.Id;
			serviceContract.Pricebook2Id = pricebooks[0].Id;
			serviceContract.AccountId = salesOrder.rstk__sohdr_account__c;
			serviceContract.Account = account;
			
			insert serviceContract;

			salesOrder.Service_Contract_Id__c = serviceContract.Id;
			update salesOrder;
			
			List<rstk__soline__c> salesOrderItems = [select rstk__soline_prod__c ,    
											rstk__soline_qtyorder__c , 
											rstk__soline_price__c  
										from rstk__soline__c  
										where rstk__soline_sohdr__c  = :salesOrderId];

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

            debugString = '\n\n\n ----------- Bluescape SalesOrderUtils.createServiceContract: SC Line Items ------------ \n';
			System.debug(debugString);
			List<ContractLineItem> newContractLineItemList = new List<ContractLineItem>();
			for (rstk__soline__c  salesOrderItem : salesOrderItems) {
                rstk__soprod__c rsProduct = [select Id,
                                             rstk__soprod_sf_product__c
                                             from rstk__soprod__c 
                                             where Id = :salesOrderItem.rstk__soline_prod__c];

                Product2 sfProduct = [select Id,
                                      		 ProductCode,
                                      		 Description 
                                             from Product2 
                                             where Id = :rsProduct.rstk__soprod_sf_product__c];

				Id pricebookEntryId = productCode2PricebookEntryIdMap.get(sfProduct.ProductCode); 
				if (pricebookEntryId == null) {
					// Sales Order line item is missing from the Pricebook
					continue;
				}

				ContractLineItem contractLineItem = new ContractLineItem();
				contractLineItem.ServiceContractId = serviceContract.Id;
				contractLineItem.PricebookEntryId = pricebookEntryId;
				contractLineItem.Description = sfProduct.Description;
				contractLineItem.Quantity = salesOrderItem.rstk__soline_qtyorder__c;
				contractLineItem.UnitPrice = salesOrderItem.rstk__soline_price__c;
				newContractLineItemList.add(contractLineItem);

			}
            System.debug(debugString);
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
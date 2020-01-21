/*
 * File Name    : SalesOrderTriggerHandler.cls
 * Description  : Apex Class to handle Sales Order trigger events.
 * 
 * Modification Log
================================================================================
 * Ver    Date              	Author                Modification
--------------------------------------------------------------------------------
 * 1.0    12/19/2014         	Bluescape
 * 
*/

public with sharing class SalesOrderTriggerHandler extends AbstractTriggerHandler {

	public SalesOrderTriggerHandler() {
	}
	
	public void bulkBefore() {
	}

	public void bulkAfter() {
		
		String debugString = '\n\n\n ----------- Bluescape SalesOrderTriggerHandler.bulkAfter ------------ \n';
		debugString = debugString + '\tTrigger.isUpdate : ' + Trigger.isUpdate + '\n';
		if (Trigger.isUpdate) {
			Map<Id, Sales_Order__c> salesOrderMap = new Map<Id, Sales_Order__c>();
			for (sObject so : Trigger.new) {
				Sales_Order__c salesOrder = (Sales_Order__c) so;
				debugString = debugString + '\tsalesOrder.Name : ' + salesOrder.Name + '\n';
				debugString = debugString + '\tsalesOrder.Status__c : ' + salesOrder.Status__c + '\n';
				debugString = debugString + '\tsalesOrder.Install_Date__c : ' + salesOrder.Install_Date__c + '\n';
				if ('Installed'.equals(salesOrder.Status__c) && salesOrder.Install_Date__c != null) {
					salesOrderMap.put(salesOrder.Id, salesOrder);
				}
			}
			
			List<ServiceContract> serviceContracts = [select Id, Name, Sales_Order__c, StartDate, EndDate from ServiceContract where Sales_Order__c IN :salesOrderMap.keySet()];
			debugString = debugString + '\n\n\tserviceContracts.Size : ' + serviceContracts.size() + '\n';
			Set<Id> serviceContractIdSet = new Set<Id>();
			Map<Id, ServiceContract> serviceContractMap = new Map<Id, ServiceContract>();
			for (ServiceContract serviceContract : serviceContracts) {
				Sales_Order__c salesOrder = salesOrderMap.get(serviceContract.Sales_Order__c);
				debugString = debugString + '\tserviceContract.Name : ' + serviceContract.Name + '\n';
				debugString = debugString + '\tserviceContract.StartDate : ' + serviceContract.StartDate + '\n';
				debugString = debugString + '\tserviceContract.EndDate : ' + serviceContract.EndDate + '\n';
				if (serviceContract.StartDate == null || (serviceContract.StartDate != null && serviceContract.StartDate != salesOrder.Install_Date__c)) {
					serviceContractIdSet.add(serviceContract.Id);
					serviceContractMap.put(serviceContract.Id, serviceContract);
					debugString = debugString + '\tsalesOrder.Name 2 : ' + salesOrder.Name + '\n';
					debugString = debugString + '\tsalesOrder.Status__c 2 : ' + salesOrder.Status__c + '\n';
					debugString = debugString + '\tsalesOrder.Install_Date__c 2 : ' + salesOrder.Install_Date__c + '\n';
					Date installDate = salesOrder.Install_Date__c;
					serviceContract.StartDate = installDate;
					serviceContract.EndDate = installDate.addMonths(12);
				}
			}
			update serviceContracts;
			
			List<Entitlement> entitlements = [select Id, ServiceContractId, StartDate, EndDate, Period__c from Entitlement where ServiceContractId IN :serviceContractIdSet];
			for (Entitlement entitlement : entitlements) {
				ServiceContract serviceContract = serviceContractMap.get(entitlement.ServiceContractId);
				if (serviceContract != null) {
					entitlement.StartDate = serviceContract.StartDate;
                    if (entitlement.Period__c != null){
                        Date endDate = serviceContract.StartDate;
                        Integer period = (Integer)entitlement.Period__c;
                        entitlement.EndDate = endDate.addMonths(period);
                    }else{
                        entitlement.EndDate = serviceContract.EndDate;
                    }
				}
			}
			update entitlements;
		}
		debugString = debugString + '\n-----------------------------------------------------------\n\n';
		// System.debug(debugString);
	}

	public void beforeInsert(SObject so) {
	}

	public void beforeUpdate(SObject oldSo, SObject so) {
	}

	public void beforeDelete(SObject so) {
	}

	public void afterInsert(SObject so) {
	}

	public void afterUpdate(SObject oldSo, SObject so) {
	}

	public void afterDelete(SObject so) {
	}

	public void andFinally() {
	}

}
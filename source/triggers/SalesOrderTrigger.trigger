/*
 * File Name    : Sales_Order__c.cls
 * Description  : Trigger on Sales_Order__c object that calls the Trigger Framework
 *				  Edit SalesOrderTriggerHandler class to handle trigger events.
 * 
 * Modification Log
================================================================================
 * Ver    Date        			Author                Modification
--------------------------------------------------------------------------------
 * 1.0    12/19/2014         	Bluescape
 * 
*/

trigger SalesOrderTrigger on Sales_Order__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	// Edit SalesOrderTriggerHandler class to handle trigger events.
	TriggerFactory.createHandler(Sales_Order__c.sObjectType);
}
/*
 * File Name: TriggerFactory.cls
 * Description: Implements best practices for trigger: http://developer.force.com/cookbook/recipe/trigger-pattern-for-tidy-streamlined-bulkified-triggers
 * 
 * Modification Log
================================================================================
 * Ver      Date            Author                  Modification
--------------------------------------------------------------------------------
 * 1.0      12/19/2014      Bluescape
*/

public with sharing class TriggerFactory {

    //Custom Settings for Enabling/Disabling History Tracking & Notifications 
    public static TriggerSettings__c triggerSettings;

    static {
        triggerSettings = TriggerSettings__c.getValues('Bluescape Trigger Settings');
    }

    /**
     * Public static method to create and execute a trigger handler
     *
     * Arguments: Schema.sObjectType soType - Object type to process (SObject.sObjectType)
     *
     * Throws a TriggerException if no handler has been coded.
     */
    public static void createHandler(Schema.sObjectType soType) {
        if (!Test.isRunningtest() && triggerSettings != null && triggerSettings.Disable_All_Triggers__c){
            return;
        }
        
        // Get a handler appropriate to the object being processed
        ITrigger handler = getHandler(soType);

        // Make sure we have a handler registered, new handlers must be registered in the getHandler method.
        if (handler == null) { 
            throw new TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }
        
        execute(handler);
    }

    /**
     * private static method to control the execution of the handler
     *
     * Arguments: ITrigger handler - A Trigger Handler to execute
     */ 
    public static void execute(ITrigger handler) {
        String debugString = '\n\n\n ----------- Bluescape SalesOrderTriggerHandler.bulkAfter ------------ \n';
        // debugString = debugString + '\ttriggerSettings.Execute_Sales_Order_Trigger__c : ' + triggerSettings.Execute_Sales_Order_Trigger__c + '\n';
        // debugString = debugString + '\thandler.triggerDisabled() : ' + handler.triggerDisabled() + '\n';
        if (handler.triggerDisabled()) {
            // System.debug(debugString);
            return;
        }
        
        debugString = debugString + '\tTrigger.isBefore : ' + Trigger.isBefore + '\n';
        // Before Trigger
        if (Trigger.isBefore) {
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore();
            
            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.isDelete) {
                for (SObject so : Trigger.old) {
                    handler.beforeDelete(so);
                }
            } else if (Trigger.isInsert) {
                // Iterate through the records to be inserted passing them to the handler.
                for (SObject so : Trigger.new) {
                    handler.beforeInsert(so);
                }
            } else if (Trigger.isUpdate) {
                // Iterate through the records to be updated passing them to the handler.
                for (SObject so : Trigger.old) {
                    handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        } else {
            debugString = debugString + '\tcalling bulkAfter\n';
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter();
            
            // Iterate through the records deleted passing them to the handler.
            if (Trigger.isDelete) {
                for (SObject so : Trigger.old) {
                    handler.afterDelete(so);
                }
            } else if (Trigger.isInsert) {
                // Iterate through the records inserted passing them to the handler.
                for (SObject so : Trigger.new) {
                    handler.afterInsert(so);
                }
            } else if (Trigger.isUpdate) {
                // Iterate through the records updated passing them to the handler.
                for (SObject so : Trigger.old) {
                    handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        debugString = debugString + '\n-----------------------------------------------------------\n\n';
        // System.debug(debugString);
        
        // Perform any post processing
        handler.andFinally();
    }

    /**
     * private static method to get the appropriate handler for the object type.
     * Modify this method to add any additional handlers.
     *
     * Arguments: Schema.sObjectType soType - Object type tolocate (SObject.sObjectType)
     *
     * Returns: ITrigger - A trigger handler if one exists or null.
     */
    private static ITrigger getHandler(Schema.sObjectType soType) {

        ITrigger triggerHandler = null;
        
        if (soType == Account.sObjectType) {
            // return new AccountTriggerHandler();
        } else if (soType == Contact.sObjectType) {
            // return new ContactTriggerHandler();
        } else if (soType == Sales_Order__c.sObjectType) {
            SalesOrderTriggerHandler soTriggerHandler = new SalesOrderTriggerHandler();
            if (!Test.isRunningtest()) {
                soTriggerHandler.executeTrigger = triggerSettings.Execute_Sales_Order_Trigger__c;
            } else {
                soTriggerHandler.executeTrigger = true;
            }
            triggerHandler = soTriggerHandler;
        }
        return triggerHandler;
    }

}
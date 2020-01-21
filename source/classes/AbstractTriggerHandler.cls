/*
 * File Name: AbstractTriggerHandler.cls
 * Description: Implements best practices for trigger: http://developer.force.com/cookbook/recipe/trigger-pattern-for-tidy-streamlined-bulkified-triggers
 * 
 * Modification Log
================================================================================
 * Ver		Date			Author					Modification
--------------------------------------------------------------------------------
 * 1.0		12/19/2014		Bluescape
*/

public abstract class AbstractTriggerHandler implements ITrigger {

	public Boolean executeTrigger;
	
	public AbstractTriggerHandler() {
		executeTrigger = true;
	}

	public Boolean triggerDisabled() {
		return !executeTrigger;
	}

	abstract void bulkBefore();
	abstract void bulkAfter();
	abstract void beforeInsert(SObject so);
	abstract void beforeUpdate(SObject oldSo, SObject so);
	abstract void beforeDelete(SObject so);
	abstract void afterInsert(SObject so);
	abstract void afterUpdate(SObject oldSo, SObject so);
	abstract void afterDelete(SObject so);
	abstract void andFinally();
}
trigger AccountTrigger on Account (before insert, before update) {

    //Copy IntacctID to Account Number on insert or update of a new Account record
	if((trigger.isInsert || trigger.isUpdate ) && trigger.isBefore)
	{
   		for( Account objacc : Trigger.New)
    	{
        	if(objacc.IntacctID__c != null)
          	{
             	objacc.AccountNumber = objacc.IntacctID__c ;
           	}
      	}
	}
}
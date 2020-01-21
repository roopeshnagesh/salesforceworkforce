trigger SetLookupFields on RS_Sales_Order_Extension__c (before insert, before update) { 
    for (RS_Sales_Order_Extension__c a : Trigger.new){
        rstk__sohdr__c soh = [select Id, rstk__sohdr_opportunity__c, rstk__sohdr_account__c from rstk__sohdr__c where Id = :a.Sales_Order_Header__c];
        if (soh.rstk__sohdr_opportunity__c != Null){
            a.Opportunity__c = soh.rstk__sohdr_opportunity__c; 
        }
        if (soh.rstk__sohdr_account__c != Null){
            a.Account__c = soh.rstk__sohdr_account__c; 
        }
    }
}
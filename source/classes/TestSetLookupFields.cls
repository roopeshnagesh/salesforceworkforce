@isTest(SeeAllData=true)
public class TestSetLookupFields {
    static testMethod void myUnitTest() {
        rstk__sohdr__c soh = [select Id, rstk__sohdr_opportunity__c, rstk__sohdr_account__c from rstk__sohdr__c where Id = : 'a5NE0000000fxo2'];
        RS_Sales_Order_Extension__c  soe = new RS_Sales_Order_Extension__c();
        soe.Sales_Order_Header__c = soh.Id;
        insert soe;
        
        RS_Sales_Order_Extension__c soe2 = [select Id, Opportunity__c, Account__c from RS_Sales_Order_Extension__c where Id = : soe.Id];
        System.assert(soh.rstk__sohdr_opportunity__c == soe2.Opportunity__c);
        System.assert(soh.rstk__sohdr_account__c == soe2.Account__c);
    }
}
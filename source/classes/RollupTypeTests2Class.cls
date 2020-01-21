@isTest
private class RollupTypeTests2Class {
    @isTest(SeeAllData=true) // required for using the standard pricebook, unfortunately
	public static void testRollupTypeOnInsert() {
        Account a = new Account(Name = 'Test Account');
        insert a;

        Opportunity o = new Opportunity(Name = 'Test Opp', StageName = 'Test Stage', CloseDate = Date.today(), AccountId = a.Id);
        insert o;

        Pricebook2 pb = [select Id from Pricebook2 where IsStandard = true limit 1];

        Product2 p = new Product2(Name = 'Test Product', Family = 'Test', isActive = true);
        insert p;
		Product2 p2 = new Product2(Name = 'Test Product', isActive = true);
        insert p2;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = p.Id, UnitPrice = 1, isActive = true);
        insert pbe;
		PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = p2.Id, UnitPrice = 1, isActive = true);
        insert pbe2;

        Quote q = new Quote(Name = 'Test Quote', OpportunityId = o.Id, PriceBook2Id = pb.Id);
        insert q;

        // single positive test
        QuoteLineItem qli = new QuoteLineItem(QuoteId = q.Id, PriceBookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100);
        insert qli;

        qli = [select Id, product_family_2__c, rollup_type__c from QuoteLineItem where QuoteId =: q.Id and PriceBookEntryId =: pbe.Id limit 1];
        System.Debug('Asserting Positive:' + qli.product_family_2__c + '=' + qli.rollup_type__c);
        System.assertEquals(qli.product_family_2__c, qli.rollup_type__c);
        
        // single null test
        qli = new QuoteLineItem(QuoteId = q.Id, PriceBookEntryId = pbe2.Id, Quantity = 1, UnitPrice = 100);
        insert qli;

        qli = [select Id, product_family_2__c, rollup_type__c from QuoteLineItem where QuoteId =: q.Id and PriceBookEntryId =: pbe2.Id limit 1];
        System.Debug('Asserting NULL:' + qli.product_family_2__c + '=' + qli.rollup_type__c);
        System.assertEquals(qli.product_family_2__c, qli.rollup_type__c);
        
        // test where rollup_type__c already has a value
        qli = new QuoteLineItem(QuoteId = q.Id, PriceBookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100, rollup_type__c = 'TBC');
        insert qli;

        qli = [select Id, product_family_2__c, rollup_type__c from QuoteLineItem where QuoteId =: q.Id and PriceBookEntryId =: pbe.Id limit 1];
        System.Debug('Asserting TBC:' + qli.product_family_2__c + '=' + qli.rollup_type__c);
        System.assertNotEquals('TBC', qli.rollup_type__c);
        System.assertEquals(qli.product_family_2__c, qli.rollup_type__c);
        
    }
    
@isTest(SeeAllData=true)
public static void testRollupTypeOnBulkInsert() {
        Account a = new Account(Name = 'Test Account');
        insert a;

        Opportunity o = new Opportunity(Name = 'Test Opp', StageName = 'Test Stage', CloseDate = Date.today(), AccountId = a.Id);
        insert o;

        Pricebook2 pb = [select Id from Pricebook2 where IsStandard = true limit 1];

        Product2 p = new Product2(Name = 'Test Product', Family = 'Test', isActive = true);
        insert p;
		Product2 p2 = new Product2(Name = 'Test Product', isActive = true);
        insert p2;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = p.Id, UnitPrice = 1, isActive = true);
        insert pbe;
		PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = p2.Id, UnitPrice = 1, isActive = true);
        insert pbe2;

        Quote q = new Quote(Name = 'Test Quote', OpportunityId = o.Id, PriceBook2Id = pb.Id);
        insert q;
       
        //BulkTest
        QuoteLineItem[] qliList = new QuoteLineItem[]{};
       	for(Integer x=0; x<200; x++){
            QuoteLineItem qli2 = new QuoteLineItem(QuoteId = q.Id, PriceBookEntryId = pbe.Id, Quantity = 1, UnitPrice = x+1);
            qliList.add(qli2);
      	}
        
        //Now insert data causing an contact trigger to fire.
        Test.startTest();
        insert qliList;
        Test.stopTest();
        
        qliList = [select id, rollup_type__c, product_family_2__c from QuoteLineItem where QuoteId=:q.Id];
        Integer j = qliList.size();
        for(Integer x=0; x<j ;x++){
            System.Debug('Asserting:' + qliList[x].product_family_2__c + '=' + qliList[x].rollup_type__c);
        	System.assertEquals(qliList[x].product_family_2__c, qliList[x].rollup_type__c);
        }
    }
}
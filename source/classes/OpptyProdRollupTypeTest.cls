@isTest
private class OpptyProdRollupTypeTest {
    @isTest(SeeAllData=true) // required for using the standard pricebook, unfortunately
  public static void testOpptyProdRollupTypeOnInsert() {
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

        // single positive test
        OpportunityLineItem OpptyProd = new OpportunityLineItem(OpportunityId = o.Id, PriceBookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100);
        insert OpptyProd;

        OpptyProd = [select Id, product_family__c, rollup_type__c from OpportunityLineItem where OpportunityId =: o.Id and PriceBookEntryId =: pbe.Id limit 1];
        System.Debug('Asserting Positive:' + OpptyProd.product_family__c + '=' + OpptyProd.rollup_type__c);
        System.assertEquals(OpptyProd.product_family__c, OpptyProd.rollup_type__c);
      
        // single null test
        OpptyProd = new OpportunityLineItem(OpportunityId = o.Id, PriceBookEntryId = pbe2.Id, Quantity = 1, UnitPrice = 100);
        insert OpptyProd;

        OpptyProd = [select Id, product_family__c, rollup_type__c from OpportunityLineItem where OpportunityId =: o.Id and PriceBookEntryId =: pbe2.Id limit 1];
        System.Debug('Asserting NULL:' + OpptyProd.product_family__c + '=' + OpptyProd.rollup_type__c);
        System.assertEquals(OpptyProd.product_family__c, OpptyProd.rollup_type__c);
        
        // test where rollup_type__c already has a value
        OpptyProd = new OpportunityLineItem(OpportunityId = o.Id, PriceBookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100, rollup_type__c = 'TBC');
        insert OpptyProd;

        OpptyProd = [select Id, product_family__c, rollup_type__c from OpportunityLineItem where OpportunityId =: o.Id and PriceBookEntryId =: pbe.Id limit 1];
        System.Debug('Asserting TBC:' + OpptyProd.product_family__c + '=' + OpptyProd.rollup_type__c);
        System.assertNotEquals('TBC', OpptyProd.rollup_type__c);
        System.assertEquals(OpptyProd.product_family__c, OpptyProd.rollup_type__c);
        
    }
    /*
@isTest(SeeAllData=true)
public static void testOpptyProdRollupTypeOnBulkInsert() {
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
       
        //BulkTest
        OpportunityLineItem[] OpptyProdList = new OpportunityLineItem[]{};
         for(Integer x=0; x<200; x++){
            OpportunityLineItem OpptyProd2 = new OpportunityLineItem(OpportunityId = o.Id, PriceBookEntryId = pbe2.Id, Quantity = 1, UnitPrice = x+1);
           // OpptyProd = new OpportunityLineItem(OpportunityId = o.Id, PriceBookEntryId = pbe2.Id, Quantity = 1, UnitPrice = 100);
            OpptyProdList.add(OpptyProd2);
        }
        
        //Now insert data causing an contact trigger to fire.
        Test.startTest();
        insert OpptyProdList;
        Test.stopTest();
        
        OpptyProdList = [select id, rollup_type__c, product_family__c from OpportunityLineItem where OpportunityId=:o.Id];
        Integer j = OpptyProdList.size();
        for(Integer x=0; x<j ;x++){
            System.Debug('Asserting:' + OpptyProdList[x].product_family__c + '=' + OpptyProdList[x].rollup_type__c);
          System.assertEquals(OpptyProdList[x].product_family__c, OpptyProdList[x].rollup_type__c);
        }
    }*/
}
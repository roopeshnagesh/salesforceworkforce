trigger OpptyProdSetRollupType on OpportunityLineItem (after insert) {
OpportunityLineItem[] OpptyProdList = new OpportunityLineItem[]{};
    for (OpportunityLineItem OpptyProd : Trigger.new){
        OpportunityLineItem OpptyProd2 = OpptyProd.clone();
        OpptyProd2.id = OpptyProd.id;
        OpptyProd2.rollup_type__c = OpptyProd2.Product_Family__c;
        OpptyProdList.add(OpptyProd2);
    }
    update OpptyProdList;
}
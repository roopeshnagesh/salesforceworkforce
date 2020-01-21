trigger SetRollupType on QuoteLineItem (after insert) {
    QuoteLineItem[] qliList = new QuoteLineItem[]{};
    for (QuoteLineItem qli : Trigger.new){
        QuoteLineItem qli2 = qli.clone();
        qli2.id = qli.id;
        qli2.rollup_type__c = qli2.product_family_2__c;
        qliList.add(qli2);
    }
    update qliList;
}
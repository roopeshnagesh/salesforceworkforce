trigger Bluescape_FeatureContentuRLUpdate on Bluescape_Feature_Content__c (after insert,after update) {
    if(Trigger.IsInsert || (Trigger.IsUpdate && Bluescape_TriggerControl.avoidFeatureContentRecursiveUpdate ==true))
    {
         Bluescape_TriggerControl.avoidFeatureContentRecursiveUpdate = false;
         List< Bluescape_Feature_Content__c > updatedLst = new List< Bluescape_Feature_Content__c >();
        for(Bluescape_Feature_Content__c item : Trigger.new){
            if(item.URL__c!=null && item.URL__c!='' && item.Video__c == true){
                String videoCode='';
                if(item.URL__c.contains('=')){
                    String[] parameterLst = item.URL__c.split('=');
                    videoCode=parameterLst[parameterLst.size()-1];
                }
                if(videoCode!=null && videoCode!=''){
                    Bluescape_Feature_Content__c updateItem = item.clone(true,true);
                    updateItem.URL__c = 'https://www.youtube.com/embed/'+videoCode;
                    updatedLst.add(updateItem);
                }
            }
        }
        if(updatedLst.size()>0){            
            update updatedLst;
        }
         
    }
}
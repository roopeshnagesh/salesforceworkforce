trigger BluescapeTvVideoUrlUpdate_Trigger on Bluescape_TV__c (after insert,after update) {
    if(Trigger.IsInsert || (Trigger.IsUpdate && Bluescape_TriggerControl.avoidRecursiveUpdate==true)){
        Bluescape_TriggerControl.avoidRecursiveUpdate = false;
        List<Bluescape_Tv__c> updatedLst = new List<Bluescape_Tv__c>();
        for(Bluescape_TV__c item : Trigger.new){
            if(item.URL__c!=null && item.URL__c!=''){
                if(item.URL__c.contains('youtube') || item.URL__c.contains('youtu.be')){
                    String videoCode='';
                    if(item.URL__c.containsIgnoreCase('=')){
                        String[] parameterLst = item.URL__c.split('=');
                        videoCode=parameterLst[parameterLst.size()-1];
                    }
                    if(videoCode!=null && videoCode!=''){
                        Bluescape_TV__c updateItem = item.clone(true,true);
                        updateItem.URL__c = 'https://www.youtube.com/embed/'+videoCode;
                        updatedLst.add(updateItem);
                    }
                } else {
                    // Vidyard and all other URLsw are taken as is
                    Bluescape_TV__c updateItem = item.clone(true,true);
                    updateItem.URL__c = item.URL__c;
                    updatedLst.add(updateItem);
                }
            }
        }
        if(updatedLst.size()>0){            
            update updatedLst;
        }
    }
}
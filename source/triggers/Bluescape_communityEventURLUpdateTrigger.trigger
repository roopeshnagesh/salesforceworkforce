trigger Bluescape_communityEventURLUpdateTrigger on Bluescape_Community_Event__c (after insert,after update) {
    if(Trigger.isInsert || (Trigger.isUpdate && Bluescape_TriggerControl.avoidCommEventURLRecursiveUpdate==true)){
        List<Bluescape_Community_Event__c> updateEventLST = new List<Bluescape_Community_Event__c>();
        Bluescape_TriggerControl.avoidCommEventURLRecursiveUpdate = false;
        for(Bluescape_Community_Event__c item : Trigger.New){
            if(item.URL__c!=null && item.URL__c!=''){
                String [] urlParts = new List<String>();
                System.debug('***URL***'+item.URL__c);
                if(item.URL__c.contains('//')){
                    urlParts = item.URL__c.split('//',2);
                }
                String secondurlPart = '';
                String firstUrlPart = '';
                if(urlParts.size()>1){
                    firstUrlPart = urlParts[0];
                    secondurlPart = urlParts[1];
                }
                else{
                    secondurlPart = item.URL__c; 
                }               
                
                System.debug('***secondurlPart1***'+secondurlPart);
                
                string[] strarrY = secondurlPart.split('\\.');
                
                if(secondurlPart!=null && secondurlPart!=''){
                    if(!(secondurlPart.startsWithIgnoreCase('www.')) && strarrY.size()<=2){
                        secondurlPart = 'www.'+secondurlPart; 
                    }
                }
                System.debug('***secondurlPart2***'+secondurlPart);

                if(secondurlPart.endsWith('/')){
                    secondurlPart = secondurlPart.removeEnd('/');
                }
               
                System.debug('***secondurlPart3***'+secondurlPart);
                
                Bluescape_Community_Event__c updateEvent = item.clone(true,true);
                if(firstUrlPart!='' && secondurlPart!=''){
                    updateEvent.URL__c = firstUrlPart+'//'+secondurlPart;                
                }
                else if(firstUrlPart=='' && secondurlPart!=''){
                    updateEvent.URL__c = secondurlPart;   
                }
                else if(firstUrlPart!='' && secondurlPart==''){
                    updateEvent.URL__c = firstUrlPart;   
                }
                
                System.debug('***updateEvent.URL__c***'+updateEvent.URL__c);
                updateEventLST.add(updateEvent);                
            }
        }
        if(updateEventLST.size()>0){
            update updateEventLST;
        }
    }
}
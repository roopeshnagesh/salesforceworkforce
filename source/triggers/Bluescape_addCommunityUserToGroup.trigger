trigger Bluescape_addCommunityUserToGroup on User (After insert,after update) {
 if(Trigger.IsInsert&&AvoidRecursiveTrigger.Run==true){
 
    Bluescape_CommUserToGroupTrig_Handler.AddToGroups(trigger.newMap.keySet());
    
    }else if(Trigger.isUpdate&&AvoidRecursiveTrigger.Run==true){
     Bluescape_CommUserToGroupTrig_Handler.UpdatePhotoURL(trigger.newMap.keySet());
    }
}
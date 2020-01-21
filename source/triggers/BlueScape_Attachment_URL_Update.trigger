trigger BlueScape_Attachment_URL_Update on Attachment (after insert,after update,after delete) 
{
    BlueScape_Attachment_URL_Update_Handler objHandler = new BlueScape_Attachment_URL_Update_Handler();
   if(Trigger.isInsert && Trigger.isAfter)
   {
       Set < Id > attachmentIdSet = new Set < Id > ();
       Set < Id > BlueScapeTVAttachmentIdSet = new Set < Id > ();
       String sObjName;
       for(Attachment Obj : Trigger.New)
       {
           if(Obj.ParentId  != null)
           {
               sObjName = Obj.ParentId.getSObjectType().getDescribe().getName();
               if(sObjName == 'Bluescape_Feature_Content__c')
               {
                 attachmentIdSet.add(Obj.Id);  
               }
               else if(sObjName == 'Bluescape_TV__c')
               {
                 BlueScapeTVAttachmentIdSet.add(Obj.Id);
               }
           }
       }
       if(attachmentIdSet.size() > 0 )
       {
          if(sObjName == 'Bluescape_Feature_Content__c')
          {
            objHandler.ProcessAfterInsertUpdateAttachmentURL(attachmentIdSet,sObjName);  
          }
       }
       if(BlueScapeTVAttachmentIdSet.size() > 0 )
       {
         if(sObjName == 'Bluescape_TV__c')
          {
            objHandler.ProcessAfterInsertUpdateAttachmentURL(BlueScapeTVAttachmentIdSet,sObjName);
          }   
       }
          
           
   }
       
   
   
   else if(Trigger.isDelete && Trigger.isAfter)
   {
       Set < Id >  ParentIdSet = new Set < Id >();
       Set < Id > attachmentIdSet = new Set < Id >();
       String sObjName;
       for(Attachment Obj : Trigger.Old)
       {
           if(Obj.ParentId  != null)
           {
                sObjName = Obj.ParentId.getSObjectType().getDescribe().getName();
               if(sObjName == 'Bluescape_Feature_Content__c' || sObjName == 'Bluescape_TV__c')
               {
                 ParentIdSet.add(Obj.ParentId);  
               }
           }
       }
       objHandler.ProcessAfterDeleteAttachmentURL(attachmentIdSet,ParentIdSet,sObjName);
   }
}
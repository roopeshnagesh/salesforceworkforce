public with sharing class BlueScape_Attachment_URL_Update_Handler
{
    public void ProcessAfterInsertUpdateAttachmentURL(Set < Id > attchmentIdSetVal,String objectName)
    {
        Set < Id > ParentIdSet = new Set < Id >();
        ProcessImageURL(attchmentIdSetVal , ParentIdSet,objectName);
    }
    public void ProcessAfterUpdateAttachmentURL(Set < Id > atachmentIdSetVal)
    {
        
    }
    public void ProcessAfterDeleteAttachmentURL(Set < Id > attachmentIdSetArgs,Set < Id >  ParentIdSetArgs,String objName)
    {
        ProcessImageURL(attachmentIdSetArgs,ParentIdSetArgs,objName);
    }
    
    public void ProcessImageURL(Set < Id > attchmentIdSet,Set< Id > ParentIdSet,String objName)
    {
        Map <String ,List<Attachment>> attachmentMap = new Map < String , List <Attachment>>();
        List < Attachment > attachmentList = new List < Attachment >();
        System.debug('*****attchmentIdSet****'+attchmentIdSet);
        System.debug('*****ParentIdSet****'+ParentIdSet);
        if(attchmentIdSet.size() > 0)
        attachmentList = [SELECT Id, Name,LastModifiedDate , ContentType, ParentId FROM Attachment where Id IN :attchmentIdSet];
        else if(ParentIdSet.size() > 0)
        {
            attachmentList = [SELECT Id, Name,LastModifiedDate , ContentType, ParentId FROM Attachment where ParentId IN :ParentIdSet];
        }           
         if ( attachmentList.size() > 0 )
         {
             for(Attachment item : attachmentList)
             {
                 if(!(attachmentMap.containsKey(item.ParentId)))
                 {
                     List < Attachment > attachmentSubList = new List < Attachment >();
                     attachmentSubList.add(item);
                     attachmentMap.put(item.ParentId,attachmentSubList);
                 }
                 else
                 {
                     List < Attachment > attachmentSubList = new List < Attachment >(); 
                     attachmentSubList = attachmentMap.get(item.ParentId);
                     attachmentSubList.add(item);
                     attachmentMap.put(item.ParentId,attachmentSubList);
                 }
             }
         }
         else if(attachmentList.size() == 0)
         {
             if(objName == 'Bluescape_Feature_Content__c')
             {
                 if(ParentIdSet.size() > 0)
                 {
                     List< Bluescape_Feature_Content__c > BlueScapeFeatureContentList = [SELECT Display_Sequence__c, Active__c, Video__c, Image__c, URL__c, Title__c, Name, Id FROM Bluescape_Feature_Content__c where Id IN : parentIdSet]; 
                     if(BlueScapeFeatureContentList.size()  > 0)
                     {
                         for(Bluescape_Feature_Content__c item : BlueScapeFeatureContentList)
                         {
                             item.Image__c = '';
                         }
                         update BlueScapeFeatureContentList; 
                     }
                    
                 } 
             }
             else if(objName == 'Bluescape_TV__c')
             {
                 if(ParentIdSet.size() > 0)
                 {
                     List< Bluescape_TV__c > BlueScapeTVList = [SELECT Id, Name, Category__c, Title__c, URL__c, Image__c, Description__c, Keywords__c, Home_Page__c, Display_Sequence__c, Active__c, Home_Page_Display_Sequence__c FROM Bluescape_TV__c where Id IN : parentIdSet]; 
                     if(BlueScapeTVList.size()  > 0)
                     {
                         for(Bluescape_TV__c item : BlueScapeTVList)
                         {
                             item.Image__c = '';
                         }
                         update BlueScapeTVList; 
                     }
                    
                 } 
             }
            
         }
         System.debug('******attachmentMap ****'+attachmentMap );
         
         if(attachmentMap != null)
         {
             Map < String , Attachment > parentAttachmentMap = new Map < String  , Attachment > ();
             Map < String , Bluescape_Feature_Content__c > BlueScapefeatureContnentMap = new  Map < String , Bluescape_Feature_Content__c > ();
             Map < String , Bluescape_TV__c > BlueScapeTVMap = new Map < String , Bluescape_TV__c >();
             Set < String > parentIdValSet = new Set < String >();
             List < Bluescape_Feature_Content__c > BlueScapeFeatureContentUpdateList = new List < Bluescape_Feature_Content__c >();
             for (String key : attachmentMap.keySet())
             {
                  List < Attachment > attachmentSubList = new List < Attachment >(); 
                  Attachment attachmentObj = new Attachment();
                  attachmentSubList = attachmentMap.get(key);
                  if(attachmentSubList.size() > 0 )
                  {
                     attachmentObj = attachmentSubList[0];
                     for (Attachment obj : attachmentSubList ) 
                     {
                        if(obj.LastModifiedDate  > attachmentObj.LastModifiedDate )
                        {
                            attachmentObj = obj;
                        }                           
                     }
                     parentIdValSet.add(attachmentObj.ParentId);
                     parentAttachmentMap.put(attachmentObj.ParentId , attachmentObj);
                  }
             }
             
             if(parentIdValSet.size() > 0)
             {
                 String customLabelValue = System.Label.Community_URL_Name;
                 if(objName == 'Bluescape_Feature_Content__c')
                 {
                     List< Bluescape_Feature_Content__c > BlueScapeFeatureContentList = [SELECT Display_Sequence__c, Active__c, Video__c, Image__c, URL__c, Title__c, Name, Id FROM Bluescape_Feature_Content__c where Id IN : parentIdValSet];
                     if(BlueScapeFeatureContentList.size()  > 0)
                     {
                         for ( Bluescape_Feature_Content__c obj : BlueScapeFeatureContentList )
                         {
                             BlueScapefeatureContnentMap.put(obj.Id,obj);
                         }
                     }
                     if(BlueScapefeatureContnentMap != null)
                     {
                         for ( String key : BlueScapefeatureContnentMap.keySet())
                         {
                            Bluescape_Feature_Content__c blueScapeFeatureContentObj =  BlueScapefeatureContnentMap.get(key);
                            if(parentAttachmentMap.containsKey(key))
                            {
                                Attachment attachmentObj = parentAttachmentMap.get(key);
                                blueScapeFeatureContentObj.Image__c = '/'+customLabelValue+'/servlet/servlet.FileDownload?file='+attachmentObj.Id;
                                BlueScapeFeatureContentUpdateList.add(blueScapeFeatureContentObj);
                            }
                         }
                         System.debug('****BlueScapeFeatureContentUpdateList***'+BlueScapeFeatureContentUpdateList);
                         if(BlueScapeFeatureContentUpdateList.size() > 0 )
                         {
                             update BlueScapeFeatureContentUpdateList;
                         }
                     } 
                 }
                 else if(objName == 'Bluescape_TV__c')
                 {
                    List<Bluescape_TV__c> blueScapeTVList = [SELECT Id, Name, Category__c, Title__c, URL__c, Image__c, Description__c, Keywords__c, Home_Page__c, Display_Sequence__c, Active__c, Home_Page_Display_Sequence__c FROM Bluescape_TV__c where ID IN :parentIdValSet];
                    List< Bluescape_TV__c > UpdateBlueScapeTVList = new List < Bluescape_TV__c > ();
                    if(blueScapeTVList.size() > 0)
                    {
                        for(Bluescape_TV__c item : blueScapeTVList)
                        {
                            BlueScapeTVMap.put(item.Id,item);
                        }
                        if(BlueScapeTVMap != null)
                        {
                            for(String key :BlueScapeTVMap.keySet())
                            {
                                Bluescape_TV__c blueScapeTvObj = BlueScapeTVMap.get(key);
                                if(parentAttachmentMap.containsKey(key))
                                {
                                    Attachment attachmentObj = parentAttachmentMap.get(key);
                                    
                                    blueScapeTvObj.Image__c = '/'+customLabelValue+'/servlet/servlet.FileDownload?file='+attachmentObj.Id;
                                    UpdateBlueScapeTVList.add(blueScapeTvObj);
                                }
                            }
                            System.debug('****UpdateBlueScapeTVList*****'+UpdateBlueScapeTVList);
                            if(UpdateBlueScapeTVList.size() > 0)
                            {
                                update UpdateBlueScapeTVList;
                            }
                        }
                    }
                 }
                
             }
         }
    }
    
    public void ProcessImpageURLForBlueScapeTV(Set < Id > BlueScapeAttachmentTVIdSet)
    {
        
    }
}
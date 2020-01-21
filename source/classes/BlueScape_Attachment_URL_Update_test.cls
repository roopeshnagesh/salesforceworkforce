@isTest
Public class BlueScape_Attachment_URL_Update_test
{
    static testMethod void testMethod1()
    {
        Bluescape_Feature_Content__c objBlue= new Bluescape_Feature_Content__c();
        objBlue.Active__c=true;
        objBlue.Video__c=false;
        objBlue.Title__c='test';
        insert objBlue;
        
        Bluescape_TV__c objBlueTV= new Bluescape_TV__c();
        objBlueTV.Active__c=true;
        objBlueTV.Home_Page__c=false;
        objBlueTV.Title__c='test';
        objBlueTV.URL__c='https://www.youtube.com/watch?v=Z4iQxCTyC-c';
        insert objBlueTV;
        
        Attachment attach=new Attachment();     
        attach.Name='Bluescape_Feature_Content__c';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objBlue.id;
        insert attach;
        
        attach.Name='Unit Test Attachment1';
        update attach;
        
        Attachment attach1=new Attachment();    
        attach1.Name='Bluescape_TV__c';
        Blob bodyBlob1=Blob.valueOf('Unit Test1 Attachment Body');
        attach1.body=bodyBlob1;
        attach1.parentId=objBlueTV.id;
        insert attach1;
        
        delete attach1;
    //  List<Attachment> attachments=[select id, name from Attachment where parent.id=:cse.id];
    }
}
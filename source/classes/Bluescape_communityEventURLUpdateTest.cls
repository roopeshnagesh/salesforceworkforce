@isTest
public class Bluescape_communityEventURLUpdateTest
{
    static testMethod void testMethod1()
    {
        Bluescape_Community_Event__c objEvent=new Bluescape_Community_Event__c();
        objEvent.URL__c= 'https://www.google.com';
        objEvent.Name='test Event';
        insert objEvent;
    }
    static testMethod void testMethod2()
    {
        Bluescape_Community_Event__c objEvent=new Bluescape_Community_Event__c();
        objEvent.URL__c= 'www.google.com';
        objEvent.Name='test Event2';
        insert objEvent;
    }
}
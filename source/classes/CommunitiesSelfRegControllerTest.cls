/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest public with sharing class CommunitiesSelfRegControllerTest {

    @IsTest
    public static void testCommunitiesSelfRegController() 
    {
        Account acc = new Account(Name = 'test');
        insert acc;

        KeyValueSetting__c setting = KeyValueSetting__c.getInstance('Community AccountId');
        
        if(setting == null)
        {
            setting = new KeyValueSetting__c(Name = 'Community AccountId', value__c = acc.id);
            insert setting;
        }
        
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
    }    
}
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class TestServiceContract {

    static testMethod void myUnitTest() {
        Account account = createAccount();
        System.assert(account != null);
        Contact contact = createContact(account);
        System.assert(contact != null);
        Product2 product = createProduct();
        System.assert(product != null);
        Entitlement_Template__c entitlementTemplate = createEntitlementTemplate(product);
        System.assert(entitlementTemplate != null);
        PricebookEntry priceBookEntry = createPricebookEntry(product);
        System.assert(priceBookEntry != null);
        Sales_Order__c salesOrder = createSalesOrder(account);
        System.assert(salesOrder != null);
        Sales_Order_Item__c salesOrderLine = createSalesOrderLine(salesOrder, product.ProductCode, 5, priceBookEntry.UnitPrice);
        System.assert(salesOrderLine != null);

        String scNumber = SalesOrderUtils.createServiceContract(salesOrder.Id);
        System.debug(' >>>>>>> SC Number : ' + scNumber);
        System.assert(scNumber != null);
        
        ServiceContract serviceContract = [select Id from ServiceContract where Sales_Order__c = :salesOrder.Id];
        System.assert(serviceContract != null);
        
        salesOrder.Install_Date__c = Date.today();
        salesOrder.Status__c = 'Installed';
        update salesOrder;
    }
    
    public static Account createAccount() {
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        return account;
    }

    public static Contact createContact(Account account) {
        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Contact';
        contact.AccountId = account.Id;
        insert contact;
        return contact;
    }

    public static Product2 createProduct() {
        Product2 product = new Product2();
        product.Name = 'Test Product';
        product.ProductCode = 'SR_TEST_PRODUCT';
        product.Family = 'IsActive';
        product.IsActive = true;
        insert product;
        return product;
    }

    public static PricebookEntry createPricebookEntry(Product2 product2) {
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = product2.Id;
        priceBookEntry.UnitPrice = 5000;
        priceBookEntry.IsActive = true;
        insert priceBookEntry;
        return priceBookEntry;
    }

    public static Entitlement_Template__c createEntitlementTemplate(Product2 product2) {
        Entitlement_Template__c entitlementTemplate = new Entitlement_Template__c();
        entitlementTemplate.Name = 'Warranty';
        entitlementTemplate.Entitlement_Type__c = 'Warranty';
        entitlementTemplate.Product__c = product2.Id;
        insert entitlementTemplate;
        return entitlementTemplate;
    }

    public static Sales_Order__c createSalesOrder(Account account) {
        Sales_Order__c salesOrder = new Sales_Order__c();
        salesOrder.Name = 'Test Sales Order';
        salesOrder.Account__c = account.Id;
        salesOrder.Status__c = 'Open';
        insert salesOrder;
        return salesOrder;
    }

    public static Sales_Order_Item__c createSalesOrderLine(Sales_Order__c salesOrder, String itemCode, Integer quantity, Decimal price) {
        Sales_Order_Item__c salesOrderLine = new Sales_Order_Item__c();
        salesOrderLine.Name = 'Test Sales Order Line';
        salesOrderLine.Sales_Order__c = salesOrder.Id;
        salesOrderLine.Item__c = itemCode;
        salesOrderLine.Quantity__c = quantity;
        salesOrderLine.Price__c = price;
        insert salesOrderLine;
        return salesOrderLine;
    }

}
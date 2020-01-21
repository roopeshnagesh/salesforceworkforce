@isTest
public class BluescapeAdminModels_test
{
    static testMethod void testDataRow()
    {
        test.StartTest();

        List<String> row = new List<String>();
        row.add('Field 1');
        row.add('Field 2');

        BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);

        System.assert (dataRow.get(0) == 'Field 1', 'Have field 1');
        System.assert (dataRow.get(1) == 'Field 2', 'Have field 2');
        System.assert (dataRow.get(2) == '', 'Have empty field');

        test.StopTest();
    }

    static testMethod void testContentItem()
    {
        test.StartTest();

        BluescapeAdminModels.ContentItem contentItem = new BluescapeAdminModels.ContentItem();

        System.assert (contentItem.active == false, 'Have active');
        System.assert (contentItem.record == null, 'Have record');
        System.assert (contentItem.changed == true, 'Have changed');

        test.StopTest();
    }

    // VideoContentItem

    static testMethod void testVideoContentItemLoad1()
    {
        test.StartTest();

        List<String> row = new List<String>();
        for (Integer i = 0; i < 13; i++)
        {
            row.add('Field ' + i);
        }
        BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);

        BluescapeAdminModels.VideoContentItem contentItem = new BluescapeAdminModels.VideoContentItem();
        contentItem.load(dataRow);

        System.assert (contentItem.title == 'Field 0', 'Have title');
        System.assert (contentItem.displaySequence == 100, 'Have fallback displaySequence');
        System.assert (contentItem.rating == 3, 'Have fallback rating');
        System.assert (contentItem.action == 'Field 3', 'Have action');
        System.assert (contentItem.audience == 'Field 4', 'Have audience');
        System.assert (contentItem.siteCategory == 'Field 5', 'Have siteCategory');
        System.assert (contentItem.subCategory == 'Field 6', 'Have subCategory');
        System.assert (contentItem.url == 'Field 12', 'Have url');
        System.assert (contentItem.active == false, 'Have active');

        test.StopTest();
    }

    static testMethod void testVideoContentItemLoad2()
    {
        test.StartTest();

        List<String> row = new List<String>();
        row.add('Title');
        row.add('1');
        row.add('2');
        row.add('keep');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);

        BluescapeAdminModels.VideoContentItem contentItem = new BluescapeAdminModels.VideoContentItem();
        contentItem.load(dataRow);

        System.assert (contentItem.title == 'Title', 'Have title');
        System.assert (contentItem.displaySequence == 1, 'Have displaySequence');
        System.assert (contentItem.rating == 2, 'Have rating');
        System.assert (contentItem.action == 'keep', 'Have action');
        System.assert (contentItem.active == true, 'Have active');

        test.StopTest();
    }

    static testMethod void testVideoContentItemLookupTrue()
    {
        Bluescape_TV__c video1 = new Bluescape_TV__c();
        video1.Title__c = 'Video Title';
        video1.Active__c = true;
        insert video1;

        test.StartTest();

        List<String> row = new List<String>();
        row.add('Video Title');
        row.add('1');
        row.add('2');
        row.add('keep');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);

        BluescapeAdminModels.VideoContentItem contentItem = new BluescapeAdminModels.VideoContentItem();
        contentItem.load(dataRow);
        contentItem.lookup();

        System.assert (contentItem.record != null, 'Have record');
        System.assert (((Bluescape_TV__c)contentItem.record).Title__c == 'Video Title', 'Have the record');

        test.StopTest();
    }

    static testMethod void testVideoContentItemSave()
    {
        Bluescape_TV__c video1 = new Bluescape_TV__c();
        video1.Title__c = 'Video Title';
        video1.Active__c = true;
        video1.Display_Sequence__c = 10;
        insert video1;

        test.StartTest();

        List<String> row = new List<String>();
        row.add('Video Title');
        row.add('1');
        row.add('2');
        row.add('remove');
        row.add('User');
        row.add('Introduction to Bluescape');
        row.add('How-To');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);

        BluescapeAdminModels.VideoContentItem contentItem = new BluescapeAdminModels.VideoContentItem();
        contentItem.load(dataRow);
        contentItem.lookup();
        contentItem.save();
        contentItem.lookup();

        System.assert (contentItem.record != null, 'Have record');
        System.assert (((Bluescape_TV__c)contentItem.record).Active__c == false, 'Have active');
        System.assert (((Bluescape_TV__c)contentItem.record).Audience__c == 'User', 'Have audience');
        System.assert (((Bluescape_TV__c)contentItem.record).SiteCategory__c == 'Introduction to Bluescape', 'Have siteCategory');
        System.assert (((Bluescape_TV__c)contentItem.record).Category__c == 'How-To', 'Have category');
        System.assert (((Bluescape_TV__c)contentItem.record).Display_Sequence__c == 1, 'Have displaySequence');

        test.StopTest();
    }

    // ArticleContentItem

    static testMethod void testArticleContentItemLoad1()
    {
        test.StartTest();

        List<String> row = new List<String>();
        for (Integer i = 0; i < 13; i++)
        {
            row.add('Field ' + i);
        }
        BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);

        BluescapeAdminModels.ArticleContentItem contentItem = new BluescapeAdminModels.ArticleContentItem();
        contentItem.load(dataRow);

        System.assert (contentItem.title == 'Field 0', 'Have title');
        System.assert (contentItem.rating == 3, 'Have fallback rating');
        System.assert (contentItem.format == 'Field 2', 'Have format');
        System.assert (contentItem.displaySequence == 100, 'Have fallback displaySequence');
        System.assert (contentItem.siteCategory == 'Field 4', 'Have siteCategory');
        System.assert (contentItem.subCategory == 'Field 5', 'Have subCategory');
        System.assert (contentItem.productCategory == 'Field 6', 'Have productCategory');
        System.assert (contentItem.audience == 'Field 7', 'Have audience');
        System.assert (contentItem.remove == false, 'Have remove');
        System.assert (contentItem.comments == 'Field 9', 'Have comments');
        System.assert (contentItem.publishDate == 'Field 10', 'Have publishDate');
        System.assert (contentItem.url == 'Field 11', 'Have url');
        System.assert (contentItem.link == 'Field 12', 'Have link');
        System.assert (contentItem.active == false, 'Have active');

        test.StopTest();
    }

    static testMethod void testArticleContentItemLoad2()
    {
        test.StartTest();

        List<String> row = new List<String>();
        row.add('Title');
        row.add('2');
        row.add('value');
        row.add('1');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('y');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('value');
        BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);

        BluescapeAdminModels.ArticleContentItem contentItem = new BluescapeAdminModels.ArticleContentItem();
        contentItem.load(dataRow);

        System.assert (contentItem.title == 'Title', 'Have title');
        System.assert (contentItem.rating == 2, 'Have rating');
        System.assert (contentItem.displaySequence == 1, 'Have displaySequence');
        System.assert (contentItem.remove == true, 'Have remove');
        System.assert (contentItem.active == false, 'Have active');

        test.StopTest();
    }

    static testMethod void testArticleContentItemLookupTrue()
    {
       
    }

    static testMethod void testArticleContentItemSave()
    {
        
    }

    // TemplateContentItem

    static testMethod void testTemplateContentItemLoad1()
    {
        test.StartTest();

        List<String> row = new List<String>();
        for (Integer i = 0; i < 13; i++)
        {
            row.add('Field ' + i);
        }
        BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);

        BluescapeAdminModels.TemplateContentItem contentItem = new BluescapeAdminModels.TemplateContentItem();
        contentItem.load(dataRow);

        System.assert (contentItem.title == 'Field 0', 'Have title');
        System.assert (contentItem.rating == 3, 'Have fallback rating');
        System.assert (contentItem.url == 'Field 2', 'Have url');
        System.assert (contentItem.link == 'Field 3', 'Have link');
        System.assert (contentItem.format == 'Field 4', 'Have format');
        System.assert (contentItem.assetType == 'Field 5', 'Have assetType');
        System.assert (contentItem.publishDate == 'Field 6', 'Have publishDate');
        System.assert (contentItem.remove == false, 'Have remove');
        System.assert (contentItem.active == false, 'Have active');

        test.StopTest();
    }

    static testMethod void testTemplateContentItemLoad2()
    {
        test.StartTest();

        List<String> row = new List<String>();
        row.add('Title');
        row.add('2');
        row.add('value');
        row.add('value');
        row.add('value');
        row.add('Calendars');
        row.add('value');
        row.add('y');
        BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);

        BluescapeAdminModels.TemplateContentItem contentItem = new BluescapeAdminModels.TemplateContentItem();
        contentItem.load(dataRow);

        System.assert (contentItem.title == 'Title', 'Have title');
        System.assert (contentItem.rating == 2, 'Have rating');
        System.assert (contentItem.remove == true, 'Have remove');
        System.assert (contentItem.active == false, 'Have active');

        test.StopTest();
    }

    static testMethod void testTemplateContentItemLookupTrue()
    {
        
    }

    static testMethod void testTemplateContentItemSave()
    {
       
    }
}
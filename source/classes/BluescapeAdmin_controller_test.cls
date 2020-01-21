@isTest
public class BluescapeAdmin_controller_test
{
    static testMethod void testReadFile()
    {
        String testContent = 'Title,Display Sequence,Rating\nVideo 1,1,1\nVideo 2,2,2\nVideo 3,3,3';
        Blob testFile = Blob.valueof(testContent);

        BluescapeAdmin_controller ctrl = new BluescapeAdmin_controller();
        ctrl.mode = 'videos';
        ctrl.contentFile = testFile;
        ctrl.ReadFile();

        test.StartTest();

        System.assert (ctrl.videoContentItems.size() == 3, 'Have video content');

        test.StopTest();
    }

    static testMethod void testLoadContentVideos()
    {
        List<List<String> > data = new List<List<String> >();

        List<String> row1 = new List<String>();
        row1.add('Video 1');
        data.add(row1);

        List<String> row2 = new List<String>();
        row2.add('Video 2');
        data.add(row2);

        test.StartTest();

        BluescapeAdmin_controller ctrl = new BluescapeAdmin_controller();
        ctrl.mode = 'videos';
        ctrl.loadContent(data);

        System.assert (ctrl.articleContentItems.size() == 0, 'Have no article content');
        System.assert (ctrl.templateContentItems.size() == 0, 'Have no template content');
        System.assert (ctrl.videoContentItems.size() == 2, 'Have video content');
        System.assert (ctrl.videoContentItems[0].title == 'Video 1', 'Have video content 1');
        System.assert (ctrl.videoContentItems[1].title == 'Video 2', 'Have video content 2');

        test.StopTest();
    }

    static testMethod void testLoadContentArticles()
    {
        List<List<String> > data = new List<List<String> >();

        List<String> row1 = new List<String>();
        row1.add('Article 1');
        data.add(row1);

        List<String> row2 = new List<String>();
        row2.add('Article 2');
        data.add(row2);

        test.StartTest();

        BluescapeAdmin_controller ctrl = new BluescapeAdmin_controller();
        ctrl.mode = 'articles';
        ctrl.loadContent(data);

        System.assert (ctrl.videoContentItems.size() == 0, 'Have no video content');
        System.assert (ctrl.templateContentItems.size() == 0, 'Have no template content');
        System.assert (ctrl.articleContentItems.size() == 2, 'Have article content');
        System.assert (ctrl.articleContentItems[0].title == 'Article 1', 'Have article content 1');
        System.assert (ctrl.articleContentItems[1].title == 'Article 2', 'Have article content 2');

        test.StopTest();
    }

    static testMethod void testLoadContentTemplates()
    {
        List<List<String> > data = new List<List<String> >();

        List<String> row1 = new List<String>();
        row1.add('Template 1');
        data.add(row1);

        List<String> row2 = new List<String>();
        row2.add('Template 2');
        data.add(row2);

        test.StartTest();

        BluescapeAdmin_controller ctrl = new BluescapeAdmin_controller();
        ctrl.mode = 'templates';
        ctrl.loadContent(data);

        System.assert (ctrl.articleContentItems.size() == 0, 'Have no article content');
        System.assert (ctrl.videoContentItems.size() == 0, 'Have no video content');
        System.assert (ctrl.templateContentItems.size() == 2, 'Have template content');
        System.assert (ctrl.templateContentItems[0].title == 'Template 1', 'Have template content 1');
        System.assert (ctrl.templateContentItems[1].title == 'Template 2', 'Have template content 2');

        test.StopTest();
    }

    static testMethod void testPerformUpdateVideos()
    {
        Bluescape_TV__c video1 = new Bluescape_TV__c();
        video1.Title__c = 'Video 1';
        video1.Active__c = true;
        insert video1;

        List<List<String> > data = new List<List<String> >();

        List<String> row = new List<String>();
        row.add(video1.Title__c);
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
        data.add(row);

        test.StartTest();

        BluescapeAdmin_controller ctrl = new BluescapeAdmin_controller();
        ctrl.mode = 'videos';
        ctrl.loadContent(data);
        ctrl.PerformUpdate();

        Bluescape_TV__c video2 = [SELECT Id, Title__c, Active__c FROM Bluescape_TV__c WHERE Title__c = :video1.Title__c];

        System.assert (ctrl.videoContentItems[0].changed == false, 'Have changed');
        System.assert (((BluescapeAdminModels.VideoContentItem)ctrl.videoContentItems[0]).active == false, 'Have active item');
        System.assert (video2.Active__c == false, 'Have active record');

        test.StopTest();
    }

    static testMethod void testPerformUpdateArticles()
    {
        
    }

    static testMethod void testPerformUpdateTemplates()
    {
         

    }
}
@isTest
public class BluescapeParser_test
{
     static testmethod void testUploadFile()
     {
         String testData = 'Title,Created Date,"Modified Date",Link,Rating,Action,Notes,More Notes,New Category,Sub Category,Display Sequence,Audience,URL\nAttach,6/27/2017,6/27/2017,Attach,1,Keep,,"Instead of How to, can we rename Advanced Features?",Getting Started,Workspace,0,User,//play.vidyard.com/Xqot5EyGSBzNz79EQAznpY.html?v=3.1.1';
         List<List<String>> data = BluescapeParser.parseCSV(testData, true);

         System.assert(data.size() == 1, 'Have data');
         System.assert(data[0][0] == 'Attach', 'Have field 1');
         System.assert(data[0][7] == 'Instead of How to, can we rename Advanced Features?', 'Have field 2');
     }
}
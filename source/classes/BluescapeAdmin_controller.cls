global class BluescapeAdmin_controller
{
    public Blob contentFile { get; set; }
    public String mode { get; set; }

    public string fileContent {get; set;}
    public List<List<String> > data {get; set;}

    public List<BluescapeAdminModels.VideoContentItem> videoContentItems {get; set;}
    public List<BluescapeAdminModels.ArticleContentItem> articleContentItems {get; set;}
    public List<BluescapeAdminModels.TemplateContentItem> templateContentItems {get; set;}

    public Pagereference ReadFile()
    {
        try
        {
            fileContent = blobToString(contentFile, 'UTF-8');
            data = BluescapeParser.parseCSV(fileContent, true);
        }
        catch(Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file' + e.getMessage());
            ApexPages.addMessage(errormsg);
        }

        try
        {
            loadContent(data);
        }
        catch(Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured processing the CSV file' + e.getMessage());
            ApexPages.addMessage(errormsg);
        }

        return null;
    }

    public static String blobToString(Blob input, String inCharset)
    {
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }

    public void loadContent(List<List<String> > data)
    {
        videoContentItems = new List<BluescapeAdminModels.VideoContentItem>();
        articleContentItems = new List<BluescapeAdminModels.ArticleContentItem>();
        templateContentItems = new List<BluescapeAdminModels.TemplateContentItem>();

        for (List<String> row : data)
        {
            BluescapeAdminModels.DataRow dataRow = new BluescapeAdminModels.DataRow(row);
            BluescapeAdminModels.ContentItem contentItem;

            if (mode == 'videos')
            {
                contentItem = new BluescapeAdminModels.VideoContentItem();
            }
            else if (mode == 'articles')
            {
                contentItem = new BluescapeAdminModels.ArticleContentItem();
            }
            else if (mode == 'templates')
            {
                contentItem = new BluescapeAdminModels.TemplateContentItem();
            }

            try
            {
                contentItem.load(dataRow);
            }
            catch (Exception e)
            {
                System.debug('An error has occurred loading the row:' + e.getMessage());
            }

            try
            {
                contentItem.lookup();
            }
            catch (Exception e)
            {
                System.debug('An error has occurred looking up the record:' + e.getMessage());
            }

            if (mode == 'videos')
            {
                videoContentItems.add((BluescapeAdminModels.VideoContentItem)contentItem);
            }
            else if (mode == 'articles')
            {
                articleContentItems.add((BluescapeAdminModels.ArticleContentItem)contentItem);
            }
            else if (mode == 'templates')
            {
                templateContentItems.add((BluescapeAdminModels.TemplateContentItem)contentItem);
            }
        }
    }

    public Pagereference PerformUpdate()
    {
        try
        {
            saveContent();
        }
        catch(Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured performing the update: ' + e.getMessage());
            ApexPages.addMessage(errormsg);
        }

        return null;
    }

    private void saveContent()
    {
        List<BluescapeAdminModels.ContentItem> contentItems;

        if (mode == 'videos')
        {
            contentItems = videoContentItems;
        }
        else if (mode == 'articles')
        {
            contentItems = articleContentItems;
        }
        else if (mode == 'templates')
        {
            contentItems = templateContentItems;
        }

        Integer index = 0;

        for (BluescapeAdminModels.ContentItem contentItem : contentItems)
        {
            if (contentItem.record != null && contentItem.changed == true)
            {
                try
                {
                    contentItem.save();
                    contentItem.changed = false;
                }
                catch (Exception e)
                {
                    System.debug('An error has occurred saving the row:' + e.getMessage());
                    System.debug(contentItem);
                }

                if (++index >= 20)
                {
                    break;
                }
            }
            else
            {
                contentItem.changed = false;
            }
        }
    }
}
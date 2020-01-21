global class BluescapeAdminModels
{
    public class DataRow
    {
        private List<String> row;

        public DataRow(List<String> row)
        {
            this.row = row;
        }

        public String get(Integer index)
        {
            if (row.size() > index)
            {
                return row[index];
            }
            else
            {
                return '';
            }
        }
    }

    public virtual class ContentItem
    {
        public Boolean active { get; set; }
        public SObject record { get; set; }
        public Boolean changed { get; set; }

        public ContentItem()
        {
            active = false;
            record = null;
            changed = true;
        }

        public virtual void load(DataRow row)
        {

        }

        public virtual void lookup()
        {

        }

        public virtual void save()
        {

        }
    }

    global class VideoContentItem extends ContentItem
    {
        public String title { get; set; }
        public Integer displaySequence { get; set; }
        public Integer rating { get; set; }
        public String action { get; set; }
        public String audience { get; set; }
        public String siteCategory { get; set; }
        public String subCategory { get; set; }
        public String url { get; set; }

        public VideoContentItem()
        {
            super();
        }

        public override void load(DataRow row)
        {
            this.title = row.get(0);

            try
            {
                this.displaySequence = Integer.valueOf(row.get(1));
            }
            catch (Exception e)
            {
                this.displaySequence = 100;
            }

            try
            {
                this.rating = Integer.valueOf(row.get(2));
            }
            catch (Exception e)
            {
                this.rating = 3;
            }

            this.action = row.get(3);
            this.audience = row.get(4);
            this.siteCategory = row.get(5);
            this.subCategory = row.get(6);
            this.url = row.get(12);
            this.active = (this.action.toLowerCase() != 'remove') && (this.rating < 3);
        }

        public override void lookup()
        {
            try
            {
                record = [SELECT Id, Active__c, Audience__c, Category__c, Display_Sequence__c, Keywords__c, SiteCategory__c, Title__c, URL__c FROM Bluescape_TV__c WHERE Title__c = :this.title LIMIT 1];
            }
            catch (Exception e)
            {
                record = null;
            }
        }

        public override void save()
        {
            Bluescape_TV__c rec = (Bluescape_TV__c) record;
            rec.Active__c = this.active;
            rec.Display_Sequence__c = this.displaySequence;

            try
            {
                rec.SiteCategory__c = this.siteCategory;
            }
            catch (Exception e)
            {
                System.debug('Invalid site category: ' + this.siteCategory + ', ' + this.title);
                rec.SiteCategory__c = null;
            }

            try
            {
                rec.Category__c = this.subCategory;
            }
            catch (Exception e)
            {
                System.debug('Invalid category: ' + this.subCategory + ', ' + this.title);
                rec.Category__c = null;
            }

            try
            {
                rec.Audience__c = this.audience;
            }
            catch (Exception e)
            {
                System.debug('Invalid audience: ' + this.audience + ', ' + this.title);
                rec.Audience__c = null;
            }

            try
            {
                update rec;
            }
            catch (Exception e)
            {
                System.debug('An error has occured updating the record (' + rec.Title__c + '): ' + e.getMessage());
            }
        }
    }

    global class ArticleContentItem extends ContentItem
    {
        public String title { get; set; }
        public Integer rating { get; set; }
        public String format { get; set; }
        public Integer displaySequence { get; set; }
        public String siteCategory { get; set; }
        public String subCategory { get; set; }
        public String productCategory { get; set; }
        public String audience { get; set; }
        public Boolean remove { get; set; }
        public String comments { get; set; }
        public String publishDate { get; set; }
        public String url { get; set; }
        public String link { get; set; }

        public ArticleContentItem()
        {
            super();
        }

        public override void load(DataRow row)
        {
            this.title = row.get(0);

            try
            {
                this.rating = Integer.valueOf(row.get(1));
            }
            catch (Exception e)
            {
                this.rating = 3;
            }

            this.format = row.get(2);

            try
            {
                this.displaySequence = Integer.valueOf(row.get(3));
            }
            catch (Exception e)
            {
                this.displaySequence = 100;
            }

            this.siteCategory = row.get(4);
            this.subCategory = row.get(5);
            this.productCategory = row.get(6);
            this.audience = row.get(7);
            this.remove = (row.get(8).toLowerCase() == 'y');
            this.comments = row.get(9);
            this.publishDate = row.get(10);
            this.url = row.get(11);
            this.link = row.get(12);
            this.active = (this.remove == false) && (this.rating < 3);
        }

        public override void lookup()
        {
             
        }

        public override void save()
        {
           
        }
    }

    global class TemplateContentItem extends ContentItem
    {
        public String title { get; set; }
        public Integer rating { get; set; }
        public String url { get; set; }
        public String link { get; set; }
        public String format { get; set; }
        public String assetType { get; set; }
        public String publishDate { get; set; }
        public Boolean remove { get; set; }

        public TemplateContentItem()
        {
            super();
        }

        public override void load(DataRow row)
        {
            this.title = row.get(0);

            try
            {
                this.rating = Integer.valueOf(row.get(1));
            }
            catch (Exception e)
            {
                this.rating = 3;
            }

            this.url = row.get(2);
            this.link = row.get(3);
            this.format = row.get(4);
            this.assetType = row.get(5);
            this.publishDate = row.get(6);
            this.remove = (row.get(7).toLowerCase() == 'y');
            this.active = (this.remove == false) && (this.rating < 3);
        }

        public override void lookup()
        {
            
        }

        public override void save()
        { 
        }
    }
}
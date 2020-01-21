global virtual class BluescapeSupport_BaseController
{
    public String userId { get; set; }
    public String userName { get; set; }
    public String userAccountId { get; set; }
    public String userContactId { get; set; }
    public String userProfile { get; set; }
    public Boolean isSuperUser { get; set; }
    public Boolean isPartner { get; set; }

    public BluescapeSupport_BaseController()
    {
        loadUser();
    }

    private void loadUser()
    {
        if (UserInfo.getUserType() != 'Guest')
        {
            this.userId = UserInfo.getUserId();
            this.userName = UserInfo.getName();

            User userData = [SELECT FirstName, LastName, Email, Contact.Id, Contact.AccountId, Profile.Name FROM User WHERE Id = :this.userId];
            List<PermissionSetAssignment> partnerSet = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :this.userId AND PermissionSet.Name = 'Partner'];

            if (userData.Contact != null)
            {
                this.userContactId = userData.Contact.Id;
                this.userAccountId = userData.Contact.AccountId;
            }
            else
            {
                List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Email = :userData.Email];

                if (contacts.size() > 0)
                {
                    this.userContactId = contacts[0].Id;
                    this.userAccountId = contacts[0].AccountId;
                }
            }


            this.userProfile = userData.Profile.Name;
            this.isSuperUser = (this.userProfile == 'Customer Community SU Custom') && (this.userAccountId != null);
            this.isPartner = (partnerSet.size() > 0);
        }
        else
        {
            this.isSuperUser = false;
            this.isPartner = false;
        }
    }
}
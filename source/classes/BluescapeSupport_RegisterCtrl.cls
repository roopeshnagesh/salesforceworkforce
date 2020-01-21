global without sharing class BluescapeSupport_RegisterCtrl
{
    public String username {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }

    global class RegistrationResponse
    {
        public Boolean success {get; set;}
        public String redirectUrl {get; set;}
        public String errorMessage {get; set;}

        public RegistrationResponse(Boolean success)
        {
            this.success = success;
        }
    }

    public BluescapeSupport_RegisterCtrl()
    {

    }

    private boolean isValidPassword(String password, String confirmPassword)
    {
        return password != null && password.length() >= 8 && password.isAlphanumeric() && password == confirmPassword;
    }

    public PageReference registerUser() {

        if (!isValidPassword(password, confirmPassword))
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }

        User u = new User();
        u.FirstName = firstName;
        u.LastName = lastName;
        u.Username = email;
        username = email;
        u.Email = email;
        u.CommunityNickname = username;

        Account account = [SELECT Id FROM Account WHERE Name = 'Bluescape Community Account'];
        String accountId = account.Id;

        String userId = Site.createPortalUser(u, accountId, password);

        if (userId != null || Test.isRunningTest())
        {
            assignUserToSupportPermissionSet(userId);
          
            
            if (password != null && password.length() > 1)
            {
                return Site.login(username, password, null);
            }
            else
            {
                PageReference page = System.Page.SiteRegisterConfirm;
                page.setRedirect(true);
                return page;
            }
        }

        return null;
    }

    @future
    private static void assignUserToSupportPermissionSet(String userId)
    {
      PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'Support_User'];

      PermissionSetAssignment assignment = new PermissionSetAssignment();
	  if (!Test.isRunningTest()){
          assignment.AssigneeId = userId;
      	  assignment.PermissionSetId = permissionSet.Id;
   	      insert assignment;
      }
    }
}
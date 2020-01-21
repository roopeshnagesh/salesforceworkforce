public with sharing class BluescapeSupport_ChangePswdCtrl
{
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}

   	public BluescapeSupport_ChangePswdCtrl()
    {

    }

    public PageReference changePassword()
    {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);
    }
}
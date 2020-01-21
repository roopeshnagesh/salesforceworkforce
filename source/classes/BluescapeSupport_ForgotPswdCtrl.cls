public with sharing class BluescapeSupport_ForgotPswdCtrl
{
    public String username {get; set;}

    public BluescapeSupport_ForgotPswdCtrl()
    {

    }

    public PageReference forgotPassword()
    {
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.BluescapeSupport_ForgotPasswordConfirm;
        pr.setRedirect(true);

        if (success)
        {
            return pr;
        }

        return null;
    }
}
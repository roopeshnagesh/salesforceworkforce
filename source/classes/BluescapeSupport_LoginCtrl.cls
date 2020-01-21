global with sharing class BluescapeSupport_LoginCtrl
{
    global String username {get; set;}
    global String password {get; set;}
    
    global BluescapeSupport_LoginCtrl ()
    {

    }

    global PageReference login()
    {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }
    
    global PageReference forwardToAuthPage() {
    	String startUrl = System.currentPageReference().getParameters().get('startURL');
    	String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
    }
}
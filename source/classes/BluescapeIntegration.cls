/*  Class that contains information related to Bluescape Integration */

public class BluescapeIntegration {
    public static Bluescape_API_Token__c newApiToken;

    @AuraEnabled
    public static ResponseWrapper makeOrgRequest(String orgName, Integer durationDays) {
        String expDate = Datetime.now().addDays(durationDays).format('yyyy-MM-dd');
        String expirationDateStr = expDate + 'T00:00:00.000Z';
        String endpoint = '/organizations';
        
        Map<String, Object> body = new Map<String, Object> { 
            'name' => orgName,
            'plan_id' => 1,
            'email' => 'bluescape.admin@bluescape.com',
            'expiration' => expirationDateStr
        };
        
        HttpResponse response = makeCalloutToBluescape(endpoint, body, 'POST');
        String org = JSON.serialize((((Map<String, Object>)JSON.deserializeUntyped(response.getBody())).get('organization')));
        Integer orgId = Integer.valueOf(((Map<String, Object>)JSON.deserializeUntyped(org)).get('id'));
        
        return new ResponseWrapper(response.getStatusCode(), orgId, null, null);
    }
    
    public static void extendingOrgExpiration(Integer orgId, Integer durationDays) {
        String expDate = Datetime.now().addDays(durationDays).format('yyyy-MM-dd');
        String expirationDateStr = expDate + 'T00:00:00.000Z';
        String endpoint = '/organizations/' + orgId;
        Map<String, Object> body = new Map<String, Object> { 
            'expiration' => expirationDateStr
        };
        
        HttpResponse response = makeCalloutToBluescape(endpoint, body, 'PUT');
    }
    
    @AuraEnabled
    public static ResponseWrapper createUserRequest(Integer orgId, String email) {
        String endpoint = '/organizations/' + orgId + '/users';

        Map<String, Object> body = new Map<String, Object> { 
            'email' => email
        };
        
        HttpResponse response = makeCalloutToBluescape(endpoint, body, 'POST');

        return new ResponseWrapper(response.getStatusCode(), null, null, null);
    }
    
    @AuraEnabled
    public static ResponseWrapper makeUserAdminRequest(Integer orgId, Integer userId) {
        String endpoint =  '/organizations/' + orgId + '/users/' + userId;
        Map<String, Object> body = new Map<String, Object> { 
            'organization_role_id' => 8
        };
        
        HttpResponse response = makeCalloutToBluescape(endpoint, body, 'PUT');

        return new ResponseWrapper(response.getStatusCode(), null, null, null);
    }
    
    @AuraEnabled
    public static ResponseWrapper getUserForMakingAdminRequest(Integer orgId, String email) {
        if (Test.isRunningTest()) {
            email = 'email@gmail.com';
        }

        String encodedEmail = EncodingUtil.urlEncode(email, 'UTF-8');
        String endpoint = '/organizations/' + orgId + '/users?query=' + encodedEmail;

        HttpResponse response = makeCalloutToBluescape(endpoint, null, 'GET');
        
        Map<String, Object> answer = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        List<Object> users = (List<Object>)answer.get('organization_users');
        Integer userId = null;
        if (users.size() != 0) {
            Map<String, Object> firstUser = (Map<String, Object>)users.get(0);
            userId = Integer.valueOf(firstUser.get('id'));
        } 
        
        return new ResponseWrapper(response.getStatusCode(), orgId, userId, null);
    }
    
    @AuraEnabled
    public static ResponseWrapper copyWorkspaceRequest(String workspaceName) {

        Bluescape_API_Token__c apiToken = [
                SELECT 
                	Getting_Started_Workspace__c 
                FROM 
                	Bluescape_API_Token__c
                WHERE 
                	Name = 'Bluescape_Api_Integration' LIMIT 1
        ];        

        String endpoint = '/workspaces/' + apiToken.Getting_Started_Workspace__c + '/copy';
        Map<String, Object> body = new Map<String, Object> { 
            'new_workspace_name' => workspaceName,
            'new_workspace_description' => 'Getting Started with Your Free Trial',
            'public' => 'true'
        };
        
        HttpResponse response = makeCalloutToBluescape(endpoint, body, 'PUT');

        return new ResponseWrapper(response.getStatusCode(), null, null, null);
    }
    
    @AuraEnabled
    public static ResponseWrapper getNewWorkspaceIdRequest(String workspaceName) {
        String encodedQuery = EncodingUtil.urlEncode(workspaceName, 'UTF-8');

        Bluescape_API_Token__c apiToken = [
                SELECT 
                	Getting_Started_Workspace_Organization__c 
                FROM 
                	Bluescape_API_Token__c
                WHERE 
                	Name = 'Bluescape_Api_Integration' LIMIT 1
        ];     
        
        String endpoint = '/organizations/' + apiToken.Getting_Started_Workspace_Organization__c + '/workspaces?query=' + encodedQuery;

        HttpResponse response = makeCalloutToBluescape(endpoint, null, 'GET');
        Map<String, Object> answer = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        List<Object> workspaces = (List<Object>)answer.get('workspaces');
        Map<String, Object> firstWorkspace = (Map<String, Object>)workspaces.get(0);
        Integer workspaceId = Integer.valueOf(firstWorkspace.get('id'));

        return new ResponseWrapper(response.getStatusCode(), null, null, workspaceId);
    }
    
    @AuraEnabled
    public static ResponseWrapper moveWorkspaceToOrgRequest(Integer orgId, Integer workspaceId) {
        String endpoint = '/workspaces/' + workspaceId + '/change_organization';
        Map<String, Object> body = new Map<String, Object> { 
            'organization_id' => orgId
        };
        
        HttpResponse response = makeCalloutToBluescape(endpoint, body, 'POST');

        return new ResponseWrapper(response.getStatusCode(), null, null, null);
    }
    
    @AuraEnabled
    public static ResponseWrapper makeWorkspacePublic(Integer workspaceId) {
        String endpoint = '/workspaces/' + workspaceId;
        Map<String, Object> body = new Map<String, Object> { 
            'public' => true
        };
        
        HttpResponse response = makeCalloutToBluescape(endpoint, body, 'PUT');

        return new ResponseWrapper(response.getStatusCode(), null, null, null);
    }
    
    public static HttpResponse makeCalloutToBluescape(String endpoint, Map<String, Object> body, String method) {
        if (newApiToken != null) {
            return requestBluescape(newApiToken, endpoint, body, method);
        }
        
        Bluescape_API_Token__c apiToken = [
                SELECT 
                	Access_Token__c, Client_ID__c, Client_Secret__c, Expires_At__c, Redirect_URI__c, Refresh_Token__c, Token_Type__c, Instance__c, API_Version__c
                FROM 
                	Bluescape_API_Token__c
                WHERE 
                	Name = 'Bluescape_Api_Integration' LIMIT 1
        ];
        
        DateTime now = DateTime.now();
        Long nowSecs = now.getTime() / 1000;
        
        if (apiToken.Expires_At__c < nowSecs) {
            newApiToken = refreshAccessToken(apiToken);
            
            //update apiToken after all callouts
            UtilIntegration.bluescapeAPIInfo = newApiToken;
            
            HttpResponse response = requestBluescape(newApiToken, endpoint, body, method);

            return response;
        } 
            
        return requestBluescape(apiToken, endpoint, body, method);
    }
    
    public static HttpResponse requestBluescape(Bluescape_API_Token__c apiToken, String endpoint, Map<String, Object> body, String method) {
        String authToken = apiToken.Token_Type__c + ' ' + apiToken.Access_Token__c;

        String instance = 'https://api.' + apiToken.Instance__c + '.bluescape.com/' + apiToken.API_Version__c;
		
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(instance + endpoint);
        request.setHeader('Authorization', authToken);
        request.setHeader('Content-Type', 'application/json');
        
        if (body != null) {
            request.setBody(JSON.serialize(body));
        }
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 201 && response.getStatusCode() != 200) {
            System.debug('Request Error! Status code = ' + response.getStatusCode() + '. Response body = ' + response.getBody());
            throw new ResponseException('Request Error! Status code = ' + response.getStatusCode() + '. Response body = ' + response.getBody());
        }
        
        return response;
    }
    
    public static Bluescape_API_Token__c refreshAccessToken(Bluescape_API_Token__c apiToken) {
        Map<String, Object> body = new Map<String, Object>();
        
        body.put('grant_type', 'refresh_token');
        body.put('refresh_token', apiToken.Refresh_Token__c);
        body.put('client_id', apiToken.Client_ID__c);
        body.put('client_secret', apiToken.Client_Secret__c);
        body.put('redirect_uri', apiToken.Redirect_URI__c);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.' + apiToken.Instance__c + '.bluescape.com/oauth/token');
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setBody(JSON.serialize(body));
        System.debug('*** refreshing Endpoint ' + request.getEndpoint());
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 201 && response.getStatusCode() != 200) {
            System.debug('Refresh Error! Status code = ' + response.getStatusCode() + '. Response body = ' + response.getBody());
            throw new ResponseException('Refresh Error! Status code = ' + response.getStatusCode() + '. Response body = ' + response.getBody());
        }
        
        String resp = response.getBody();
        Map<String,Object> data = (Map<String,Object>) JSON.deserializeUntyped(resp);
        
        apiToken.Access_Token__c = (String) data.get('access_token');
        apiToken.Refresh_Token__c = (String) data.get('refresh_token');
        apiToken.Expires_At__c = (Long) data.get('expires_at');

        System.debug('*** refreshed Access_Token__c ' + apiToken.Access_Token__c);
        System.debug('*** refreshed Refresh_Token__c ' + apiToken.Refresh_Token__c);
        System.debug('*** refreshed Expires_At__c ' + apiToken.Expires_At__c);

        return apiToken;
    }
    
    public class ResponseWrapper {
        @AuraEnabled public Integer responseCode {get; set;}
        @AuraEnabled public Integer orgId {get; set;}
        @AuraEnabled public Integer userId {get; set;}
        @AuraEnabled public Integer workspaceId {get; set;}
        
        ResponseWrapper (Integer responseCode, Integer orgId, Integer userId, Integer workspaceId) {
            this.responseCode = responseCode;
            this.orgId = orgId;
            this.userId = userId;
            this.workspaceId = workspaceId;
        }
    }

    public class ResponseException extends Exception {}

}
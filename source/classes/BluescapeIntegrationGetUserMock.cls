public class BluescapeIntegrationGetUserMock implements HttpCalloutMock {
    
    public static HttpResponse respond(HttpRequest request) {
        
        System.assertEquals('application/json', request.getHeader('Content-Type'));
        System.assertNotEquals(null, request.getHeader('Authorization'));
        System.assertEquals(true, request.getEndpoint().contains('query'));

        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{ "total": 1, "limit": 25, "offset": 0, "size": 1, "paging": { "prev": null, "self": "/api/organizations/4512/users?order_by=&order_direction=ASC&limit=25&offset=0&query=test%40gmail.com", "next": null }, "organization_users": [ { "id": 12839, "email": "test@gmail.com", "first_name": null, "last_name": null, "title": null, "industry": null, "phone_number": null, "locked_at": null, "avatar_url": null, "created_at": "2016-06-17T17:40:31.000Z", "updated_at": "2019-02-15T15:03:20.000Z", "invited_state": "INVITED_USER", "organization_role": { "id": 9, "name": "User", "description": "Users can create workspaces and manipulate them, view public workspace list and users in their organizations", "type": "user", "display_order": 3, "is_custom": 0, "can_view_public_workspace": true, "can_list_organization_roles": true, "can_list_workspace_roles": true, "can_list_organization_users": true, "can_create_workspace": true, "can_add_guest": true}}]}');
        
        return response;
    }
}
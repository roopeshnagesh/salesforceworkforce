public class BluescapeIntegrationGetWorkspaceMock implements HttpCalloutMock {
    
    public static HttpResponse respond(HttpRequest request) {
        
        System.assertEquals('application/json', request.getHeader('Content-Type'));
        System.assertNotEquals(null, request.getHeader('Authorization'));
        System.assertEquals(true, request.getEndpoint().contains('query'));

        HttpResponse response = new HttpResponse();
        response.setStatusCode(UtilIntegration.setFailingMock ? 400 : 200);
        response.setBody('{ "total": 1, "limit": 25, "offset": 0, "size": 1, "paging": { "prev": null, "self": "/api/organizations/4/workspaces?order_by=&order_direction=ASC&limit=25&offset=0&query=Getting%20Started%20with%20Your%20Free%20Trial", "next": null }, "workspaces": [ { "id": 754152, "uid": "WeXFYNN5uJTuk9zAc42Q", "name": "Getting Started with Your Free Trial", "description": "Getting Started with Your Free Trial", "organization_id": 4, "public": false, "default_role_id": null, "published_at": null, "published_url": null, "publish_state": "not_published", "publish_state_at": null, "created_at": "2019-02-21T10:56:46.000Z", "updated_at": "2019-02-21T10:56:46.000Z", "organization": { "id": 4, "name": "Bluescape", "account_id": 3, "saml_provider_id": null, "is_guest_invite_requires_approval": false, "org_can_have_guests": true, "locked_at": null, "default_public_workspace_role_id": 2, "default_organization_user_role_id": 9, "is_custom_role_enabled": false, "created_at": "2012-11-19T17:22:56.000Z", "updated_at": "2019-02-07T21:37:23.000Z", "deleted_at": null } } ] }}');        
        return response;
    }
}
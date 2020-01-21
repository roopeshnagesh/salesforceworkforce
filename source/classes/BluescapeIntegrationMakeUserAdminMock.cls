public with sharing class BluescapeIntegrationMakeUserAdminMock implements HttpCalloutMock {
    
    public static HttpResponse respond(HttpRequest request) {
        
        System.assertEquals('application/json', request.getHeader('Content-Type'));
        System.assertNotEquals(null, request.getHeader('Authorization'));
        System.assertEquals(true, request.getBody().contains('organization_role_id'));

        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{}');
        return response;
    }
}
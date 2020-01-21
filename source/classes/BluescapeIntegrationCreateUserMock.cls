public class BluescapeIntegrationCreateUserMock implements HttpCalloutMock {
    
    public static HttpResponse respond(HttpRequest request) {
        
        System.assertEquals('application/json', request.getHeader('Content-Type'));
        System.assertNotEquals(null, request.getHeader('Authorization'));
        System.assertEquals(true, request.getBody().contains('email'));

        HttpResponse response = new HttpResponse();
        response.setStatusCode(UtilIntegration.setFailingMock ? 400 : 200);
        response.setBody('{}');
        
        return response;
    }
}
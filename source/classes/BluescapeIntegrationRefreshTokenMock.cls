public class BluescapeIntegrationRefreshTokenMock implements HttpCalloutMock{
    
    public static HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{"access_token":"123", "refresh_token":"123", "expires_at":123}');
        
        return response;
    }
}
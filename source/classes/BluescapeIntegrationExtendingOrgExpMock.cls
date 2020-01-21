public class BluescapeIntegrationExtendingOrgExpMock implements HttpCalloutMock {
	public static HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(UtilIntegration.setFailingMock ? 400 : 200);
        response.setBody('{}');
        
        return response;
    }
}
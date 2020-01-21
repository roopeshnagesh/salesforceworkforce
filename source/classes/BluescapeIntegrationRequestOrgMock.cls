public class BluescapeIntegrationRequestOrgMock implements HttpCalloutMock {
    
    public static HttpResponse respond(HttpRequest request) {
        
        System.assertEquals('application/json', request.getHeader('Content-Type'));
        System.assertNotEquals(null, request.getHeader('Authorization'));

        HttpResponse response = new HttpResponse();
        response.setStatusCode(UtilIntegration.setFailingMock ? 400 : 201);
        response.setBody('{' + 
            '"organization": {' + 
                '"default_public_workspace_role_id": 3,' +
                '"id": 4391,' +
                '"name": "Trial: trial.users.email@address.com",' +
                '"account_id": 3759,' +
                '"is_guest_invite_requires_approval": false,' + 
                '"default_organization_user_role_id": 9,' +
                '"locked_at": null,' +
                '"saml_provider_id": null,' +
                '"org_can_have_guests": true,' +
                '"metadata": [' +
                    '{' +
                        '"key": "has_onedrive",' +
                        '"value": "1"' +
                    '},' +
                    '{' +
                        '"key": "has_google_drive",' +
                        '"value": "1"' +
                    '},' +
                    '{' +
                        '"key": "has_box",' +
                        '"value": "1"' +
                    '},' +
                    '{' +
                       '"key": "has_dropbox",' +
                        '"value": "1"' +
                    '},' +
                    '{' +
                        '"key": "has_google_image",' +
                        '"value": "1"' +
                    '},' +
                    '{' +
                        '"key": "has_you_tube",' +
                        '"value": "1"' +
                    '},' +
                    '{' +
                        '"key": "has_file_upload",' +
                        '"value": "1"' +
                    '},' +
                    '{' +
                        '"key": "has_web_browser",' +
                        '"value": "1"' +
                    '},' +
                    '{' +
                        '"key": "display_image_filename",' +
                        '"value": "1"' +
                    '},' +
                    '{' +
                       '"key": "send_cert",' +
                        '"value": "0"' +
                    '},' +
                    '{' +
                        '"key": "can_upload_video_files",' +
                        '"value": "0"' +
                    '},' +
                    '{' +
                        '"key": "video_file_upload_max_size",' +
                        '"value": "157286400"' +
                    '},' +
                    '{' +
                        '"key": "disable_meet",' +
                        '"value": "0"' +
                    '}' +
                '],' +
                '"is_custom_role_enabled": false,' +
                '"updated_at": "2019-02-12T12:04:10.000Z",' +
                '"created_at": "2019-02-12T12:04:10.000Z",' +
                '"owner": {' +
                    '"id": 4201,' +
                    '"email": "bluescape.admin@bluescape.com",' +
                    '"first_name": "Bluescape",' +
                    '"last_name": "Admin"' +
                '},' +
                '"expiration": "2019-05-25T01:07:08.000Z",' +
                '"plan": {' +
                    '"id": 1,' +
                    '"name": "enterprise"' +
                '}' +
            '}' +
        '}');


        
        return response;
    }
}
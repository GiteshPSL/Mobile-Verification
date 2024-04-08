@isTest
global class MobileNumberVerificationControllerTest {
    
     public static testMethod void t1(){
        Account account = new Account();
        
        account.Name = 'test corp';
        account.phone= '01123123';
        account.billingcity='London';
        account.billingpostalcode='SW1635HJ';
        account.billingcountry='United Kingdom';
        account.billingstreet='address 1';
        
        insert account;
        
        
        //Insert contact for Account
        Contact c = new Contact();
        c.AccountId = account.ID;
        c.FirstName = 'test';
        c.LastName = 'test';
        c.email = 'test@test.com';
        c.birthdate = Date.newInstance(1992, 04, 12);
        c.Phone='8888308458';
        insert c;
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        MobileNumberVerificationController.mobileNumberVerificationAPICall(c.id);
        System.Test.stopTest();
    }
    global class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            system.debug('in MockHttpResponseGenerator');
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setBody('{ "status": "success", "phone": "+49-15123577723", "phone_valid": true, "phone_type": "mobile", "phone_region": "Germany", "country": "Germany", "country_code": "DE", "country_prefix": "49", "international_number": "+49 1512 3577723", "local_number": "01512 3577723", "e164": "+4915123577723", "carrier": "T-Mobile" }');
            res.setStatusCode(200);
            return res;
        }
    }
}
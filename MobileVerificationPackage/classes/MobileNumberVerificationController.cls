public class MobileNumberVerificationController {
    @AuraEnabled
    public static string mobileNumberVerificationAPICall(string recordID){
        system.debug(recordID);
        Contact contactDetails=[select id,phone from Contact where id=:recordID];
        string apiKey=system.label.Mobile_Verification_API_Key;
        HTTP http = new HTTP();
        HTTPRequest httpReq = new HTTPRequest();
        HTTPResponse httpResponse;
        httpReq.setEndPoint('https://api.veriphone.io/v2/verify?phone='+contactDetails.phone+'&key='+apiKey);
        httpReq.setMethod('GET');
        try
        {
            httpResponse = http.send(httpReq);
            system.debug('httpRes' + httpResponse );
            system.debug('Body' + httpResponse.getBody());
            ResposneWrapper wrap = (ResposneWrapper) System.JSON.deserialize(httpResponse.getBody(), ResposneWrapper.class);
            if(httpResponse.getStatusCode()==200){
                if(wrap.phone_valid==true){
                    Contact updateContact = new Contact();
                    updateContact.id=contactDetails.id;
                    updateContact.Mobile_Number_verified__c=true;
                    update updateContact;
                    return 'Mobile Number Verified';
                }
                else{
                    return 'Mobile Number Not Verified';
                }
            }
            else{
                return 'Some Error Occurred';
            }
            
            
        }
        catch(Exception ex)
        {
            system.debug(ex.getStackTraceString()+' '+ex.getMessage());
            return ex.getMessage();
        }
        
        
        
    }
    public class ResposneWrapper{
        public String status;
        public String phone;
        public Boolean phone_valid;
        public String phone_type;
        public String phone_region;
        public String country;
        public String country_code;
        public String country_prefix;
        public String international_number;
        public String local_number;
        public String e164;
        public String carrier;
    }
}
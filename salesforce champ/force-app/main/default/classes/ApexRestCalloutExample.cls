public class ApexRestCalloutExample {
    
    //GET
    Public static void restCallOutGETExample(){
        
        http httpObj = new http();
        httpRequest req = new httpRequest();
        
        req.setEndpoint('https://reqres.in/api/users');
        req.setHeader('content-Type','application/json');
        req.setMethod('GET');
        
        httpResponse res = new httpResponse();
        res = httpObj.send(req);
        
        system.debug('@@getBodyGet'+res.getBody());
        system.debug('@@resBody'+res);
    }
    
    //POST
    Public static void restCalloutPostExample(){
        
        http httpObj = new http();
        httpRequest req = new httpRequest();
        
        req.setEndPoint('https://reqres.in/api/users');
        req.setHeader('content-Type','application/json');
        req.setMethod('POST');
        req.setBody('{"first_name": "Praveen", "last_name": "Shedabale","avatar": "NewTon"}');
        
        httpResponse res =  new httpResponse();
        res = httpObj.send(req);
        
        system.debug('@@resBodyPost'+res.getBody());
        
    }
        
}
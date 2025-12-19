public class ApexRestCalloutDemo {
    
    public static void getUserFromExternalSystem(){
        //ApexRestCalloutDemo.getUserFromExternalSystem();
        
        /*
        http httpObject = new http();
        httpRequest req = new httpRequest();
        
        req.setEndPoint('https://reqres.in/api/users');
        req.setHeader('Content-Type','application/json');
        req.setMethod('GET');
        
        HttpResponse res = new HttpResponse();
        res = httpObject.send(req);
        
        system.debug('@@Responsebody'+res.getBody());
        
        
        
        http httpObject = new http();
        httpRequest req = new httpRequest();
        
        req.setEndPoint('https://reqres.in/api/users');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-api-key', 'reqres-free-v1');
        //req.setHeader('x-api-key': 'reqres-free-v1');     
        req.setMethod('POST');
        req.setBody('{ "name": "cccJohn cccDoe", "job": "Software Engineer"}');
        
        HttpResponse res = new HttpResponse();
        res = httpObject.send(req);
        system.debug('@@Responsebody'+res.getBody());

		*/
        
       	http httpObject = new http();
        httpRequest req = new httpRequest();
        
        req.setEndPoint('https://reqres.in/api/users/1');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-api-key', 'reqres-free-v1');
        //req.setHeader('x-api-key': 'reqres-free-v1');     
        req.setMethod('GET');
        //req.setBody('{ "name": "cccJohn cccDoe", "job": "Software Engineer"}');
        
        HttpResponse res = new HttpResponse();
        res = httpObject.send(req);
        system.debug('@@Responsebody'+res.getBody());
    }
}
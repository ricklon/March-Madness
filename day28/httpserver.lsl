key requestURL;
string gURI;
integer CHANNEL = 43;
integer LINK_TARGET = -1;
integer gPosterPrim = 1;

default
{
 
    state_entry() {
        requestURL = llRequestURL();     // Request that an URL be assigned to me.
        llOwnerSay((string) llGetLinkNumber());
        llOwnerSay((string) llGetNumberOfPrims());
        llMessageLinked(gPosterPrim,0,gURI,gURI);
    }
 
    on_rez(integer param)
    {   // Triggered when the object is rezzed, like after the object has been sold from a vendor
        llResetScript();//By resetting the script on rez forces the listen to re-register.
    }
    touch_start(integer number)
    {
        
        llOwnerSay("My URI: " + gURI);
        llSay(0,"linknum: " + (string)llGetLinkNumber());
        llSay(0, gURI);
        llMessageLinked(gPosterPrim,0,gURI,gURI);
            
    }
    
    link_message(integer sender_num, integer num, string msg, key id) {
        llOwnerSay(msg);
        llMessageLinked(gPosterPrim,0,gURI,gURI);
        
    }
    
    changed (integer change) {
        if (change && CHANGED_REGION ) {
            requestURL = llRequestURL();     // Request that an URL be assigned to me.
        }
        else {
            llOwnerSay("No need to update URL.");   
        }    
    }
    
    
     http_request(key id, string method, string body) {
 
        if ((method == URL_REQUEST_GRANTED) && (id == requestURL) ){
            // An URL has been assigned to me.
            llOwnerSay("LSL server obj: " + (string)llGetKey());
            llOwnerSay("URI: " + body);
            llSay(CHANNEL, body);
            gURI = body;
            requestURL = NULL_KEY;
        }

 
        else if ((method == URL_REQUEST_DENIED) && (id == requestURL)) {
            // I could not obtain a URL
            llOwnerSay("There was a problem, and an URL was not assigned: " + body);
            requestURL = NULL_KEY;
        }
 
        else if (method == "POST") {

            list headers = [ "x-script-url", 
                                "x-path-info", 
                                "x-query-string", 
                                "x-remote-ip", 
                                "user-agent", 
                                "x-secondlife-shard",           
                                "x-secondlife-object-name",     
                                "x-secondlife-object-key",      
                                "x-secondlife-region",          
                                "x-secondlife-local-position",  
                                "x-secondlife-local-rotation",  
                                "x-secondlife-local-velocity",  
                                "x-secondlife-owner-name",      
                                "x-secondlife-owner-key"    
                                ];
                integer pos = ~llGetListLength(headers);
                while( ++pos )
                    {
                        string header = llList2String(headers, pos);
                        llOwnerSay(header + ": " + llGetHTTPHeader(id, header));
                    }            
            
            // Anincoming message was received.
            string time =  llGetTimestamp();
            llOwnerSay("lslhttpserver (" + time + ") Received information from the outside: " + body);
            
            llHTTPResponse(id,200,"Thank you for calling. All of our operators are busy.");
        }
        
    
 
 
        else {
            // An incoming message has come in using a method that has not been anticipated.
            llHTTPResponse(id,405,"Unsupported Method");
        }
    }
 
}

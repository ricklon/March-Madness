key requestid; // just to check if we're getting the result we've asked for; all scripts in the same object get the same replies
string uri;
integer listen_handle;
string gURI;
key gServerPrimKey;
integer gPrimServer = 2;

default
{
    state_entry()
    {   
     
        llMessageLinked(gPrimServer,0,"Send gPrimURI","Send gPrimURI");
    }

    on_rez(integer param)
    {   // Triggered when the object is rezzed, like after the object has been sold from a vendor
        llResetScript();//By resetting the script on rez forces the listen to re-register.
    }
  
      link_message(integer sender_num, integer num, string msg, key id) {
        llOwnerSay(msg);
        gURI = msg;
      
    }
    
    touch_start(integer number)
    {
       
         llOwnerSay("My URI: " + gURI);
        llSay(0,"linknum: " + (string)llGetLinkNumber());
        llSay(0, gURI);
        llMessageLinked(gPrimServer,0,"Send gPrimURI","Send gPrimURI");
        
    
        requestid = llHTTPRequest(gURI, 
            [HTTP_METHOD, "POST",
             HTTP_MIMETYPE, "application/x-www-form-urlencoded"],
            "time=" +  llGetTimestamp()  +"&parameter2=world");
    
        
            
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        string time =  llGetTimestamp();
        
        
        if (request_id == requestid)
             llOwnerSay( "http resp(" + time + ") key: " + (string)request_id);
             llOwnerSay( "http resp(" + time + ") status: " + (string)status);
             llOwnerSay( "http resp(" + time + ") metadata: " + (string)metadata);
             llOwnerSay( "http resp(" + time + ") body: " + body);
             llWhisper(10, " Whisper to test box");


    }
}

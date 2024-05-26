import Toybox.System;
import Toybox.Communications.*;
import Toybox.Lang;

class JsonRequest {
    public var url as String;
    public var params as Object;

    public function initialize(_url as String, _params as Object) {
        self.url = _url;
        self.params = _params;
    }

    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            System.println("Data received.");
            System.println(data);
        } else {
            System.println("Error: " + responseCode);
            System.println(data);
        }
    }
    
    function makeRequest() as Void {
        var responseCallback = method(:onReceive);

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
            // set response type
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :timeout => 5000 
        };
        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }
}
import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;

class JsonRequest {
    public var url as String;
    public var params as Object;
    hidden var callback as Lang.Method;

    public function initialize(_url as String, _params as Object, _callback as Lang.Method) {
        self.url = _url;
        self.params = _params;
        self.callback = _callback;
    }
    
    // Start whole process
    public function makeRequest() as Void {
        Communications.checkWifiConnection(method(:handleConnection));
    }

    // Handle the wifi connection
    function handleConnection(result as {:wifiAvailable as Boolean, :errorCode as Communications.WifiConnectionStatus }) as Void {
        if (result[:wifiAvailable]) {
            System.println("Wifi is available");
            sendRequest();
        } else {
            System.println("Wifi is not available");
            callback.invoke()
        }
    }

    // Send the request
    function sendRequest() as Void {
        var options = {                                             
            :method => Communications.HTTP_REQUEST_METHOD_GET,     
            :headers => {                                           
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :timeout => 5000 
        };
        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }

    // Receive the data and return them
    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            System.println("Data received.");
            callback.invoke({wifi => true, data => data}); // Return data using callback
        } else {
            System.println("Error: " + responseCode);
        }
    }
}
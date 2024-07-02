import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Math; 
import Toybox.Application;

class SolaxCloudView extends WatchUi.View {
    private var _yieldToday;
    private var _feedIn;
    private var _panel;
    private var _soc;
    private var _updateTime;
    private var _error;
    private var _load;
    private var _batteryPower;

    private var _feedInIcon;
    private var _yieldTodayIcon;
    private var _panelicon;
    private var _socIcon;
    private var _loadIcon;
    private var _batteryPowerIcon;
    private var _refreshIcon;

    private var request;
    function initialize() {
        View.initialize();
    }
    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        _yieldToday = findDrawableById("yield_today");
        _feedIn = findDrawableById("feed_in");
        _panel = findDrawableById("panel");
        _soc = findDrawableById("soc");
        _updateTime = findDrawableById("update_time");
        _error = findDrawableById("error");
        _load = findDrawableById("load");
        _batteryPower = findDrawableById("batterypower");

        _yieldTodayIcon = findDrawableById("yield");
        _panelicon = findDrawableById("panelicon");
        _socIcon = findDrawableById("battery");
        _feedInIcon = findDrawableById("feedin");
        _loadIcon = findDrawableById("loadicon");
        _batteryPowerIcon = findDrawableById("battery_charge");
        _refreshIcon = findDrawableById("refresh");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        var tokenId = Properties.getValue("tokenId");
            var inverterSerial = Properties.getValue("InverterSerial"); 
            if (tokenId.equals("")) {
                showError("Token ID is empty!");
                return;
            } else if (inverterSerial.equals("")) {
                showError("Inverter Serial is empty!");
                return;
            }
            showError("Loading...");
            request = new JsonRequest("https://eu.solaxcloud.com/proxyApp/proxy/api/getRealtimeInfo.do", {"tokenId" => tokenId, "sn" => inverterSerial}, method(:receiveData));
            request.makeRequest();
    }

    function receiveData(data) {
        if (data.get(:wifi) == false) {
            showError("Wifi is not available");
        } else if (data.get(:data).get("code") == 103) {
            showError("Invalid Token ID");
        } else if (data.get(:data).get("code") == 0 && data.get(:data).get("success") == false) {
            showError("Invalid Inverter Serial");
        } else if  (data.get(:data).get("result") == null) {
            request.makeRequest();
        } else {
        var result = data.get(:data).get("result");
        _error.setText("");
        // COUNT THE PANEL POWER
       var panelPower = ((result.get("powerdc1") != null ? result.get("powerdc1").toNumber() : 0) +
                        (result.get("powerdc2") != null ? result.get("powerdc2").toNumber() : 0) +
                        (result.get("powerdc3") != null ? result.get("powerdc3").toNumber() : 0) +
                        (result.get("powerdc4") != null ? result.get("powerdc4").toNumber() : 0)).toDouble() / 1000;

        // ICONS
        _yieldTodayIcon.setBitmap(Rez.Drawables.yield);
        _feedInIcon.setBitmap(Rez.Drawables.feedin);
        _panelicon.setBitmap(Rez.Drawables.panelicon);
        _socIcon.setBitmap(Rez.Drawables.battery);
        _loadIcon.setBitmap(Rez.Drawables.loadicon);
        _batteryPowerIcon.setBitmap(Rez.Drawables.battery_charge);
        _refreshIcon.setBitmap(Rez.Drawables.refresh);
        // TEXT DATA
        _yieldToday.setText(result.get("yieldtoday").format("%.2f") + " kWh");
        _feedIn.setText(result.get("feedinpower").toNumber() + " W");
        _panel.setText(
            panelPower.format("%.2f") + " (" 
            + (result.get("powerdc1") != null ? (result.get("powerdc1").toDouble() / 1000).format("%.2f") : "")
            + (result.get("powerdc2") != null ? ", " + (result.get("powerdc2").toDouble() / 1000).format("%.2f") : "")
            + (result.get("powerdc3") != null ? ", " + (result.get("powerdc3").toDouble() / 1000).format("%.2f") : "") + ")");
        _soc.setText(result.get("soc").toNumber() + " %");
        _load.setText((result.get("acpower").toNumber() - result.get("feedinpower").toNumber()) + " W");
        _batteryPower.setText(result.get("batPower").toNumber() + " W");
        _updateTime.setText(result.get("uploadTime").substring(10, 19));
        }
        WatchUi.requestUpdate();
    }

    function showError(message) {
        _yieldTodayIcon.setBitmap(Rez.Drawables.blank);
        _feedInIcon.setBitmap(Rez.Drawables.blank);
        _panelicon.setBitmap(Rez.Drawables.blank);
        _socIcon.setBitmap(Rez.Drawables.blank);
        _loadIcon.setBitmap(Rez.Drawables.blank);
        _batteryPowerIcon.setBitmap(Rez.Drawables.blank);
        _refreshIcon.setBitmap(Rez.Drawables.blank);
        _error.setText(message);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

    }
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
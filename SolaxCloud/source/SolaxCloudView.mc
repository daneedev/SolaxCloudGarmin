import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Math; 
import Toybox.Application;

class SolaxCloudView extends WatchUi.View {
    private var _acPower;
    private var _yieldToday;
    private var _feedIn;
    private var _pv1;
    private var _pv2;
    private var _pv3;
    private var _pv4;
    private var _soc;
    private var _batteryPower;
    private var _updateTime;
    private var _error;

    private var _acPowerIcon;
    private var _feedInIcon;
    private var _yieldTodayIcon;
    private var _pv1icon;
    private var _pv2icon;
    private var _pv3icon;
    private var _pv4icon;
    private var _socIcon;
    private var _batteryPowerIcon;

    private var request;
    function initialize() {
        View.initialize();
    }
    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        _acPower = findDrawableById("ac_power");
        _yieldToday = findDrawableById("yield_today");
        _feedIn = findDrawableById("feed_in");
        _pv1 = findDrawableById("pv1");
        _pv2 = findDrawableById("pv2");
        _pv3 = findDrawableById("pv3");
        _pv4 = findDrawableById("pv4");
        _soc = findDrawableById("soc");
        _batteryPower = findDrawableById("bat_power");
        _updateTime = findDrawableById("update_time");
        _error = findDrawableById("error");

        _acPowerIcon = findDrawableById("acpower");
        _yieldTodayIcon = findDrawableById("yield");
        _pv1icon = findDrawableById("panel1");
        _pv2icon = findDrawableById("panel2");
        _pv3icon = findDrawableById("panel3");
        _pv4icon = findDrawableById("panel4");
        _socIcon = findDrawableById("battery");
        _batteryPowerIcon = findDrawableById("battery_charge");
        _feedInIcon = findDrawableById("feedin");

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
            var tokenId = Properties.getValue("tokenId");
            var inverterSerial = Properties.getValue("InverterSerial");
            request = new JsonRequest("https://eu.solaxcloud.com/proxyApp/proxy/api/getRealtimeInfo.do", {"tokenId" => tokenId, "sn" => inverterSerial}, method(:receiveData));
            request.makeRequest();
    }

    function receiveData(data) {
        var result = data.get(:data).get("result");
        if (data.get(:data).get("code") == 101) {
            showError("Token ID field is empty!");
        } else if (data.get(:data).get("code") == 103) {
            showError("Invalid Token ID");
        } else if (data.get(:data).get("code") == 0 && data.get(:data).get("success") == false) {
            showError("Invalid Inverter Serial");
        } else if  (result == null) {
            request.makeRequest();
        } else {
        _acPower.setText(result.get("acpower").toNumber() + " W");
        _yieldToday.setText(result.get("yieldtoday").format("%.2f") + " kWh");
        _feedIn.setText(result.get("feedinpower").toNumber() + " W");
        _pv1.setText("1: " + (result.get("powerdc1") != null ? result.get("powerdc1").toNumber() + " W" : "N/A W"));
        _pv2.setText("2: " + (result.get("powerdc2") != null ? result.get("powerdc2").toNumber() + " W" : "N/A W"));
        _pv3.setText("3: " + (result.get("powerdc3") != null ? result.get("powerdc3").toNumber() + " W" : "N/A W"));
        _pv4.setText("4: " + (result.get("powerdc4") != null ? result.get("powerdc4").toNumber() + " W" : "N/A W"));
        _soc.setText(result.get("soc").toNumber() + " %");
        _batteryPower.setText(result.get("batPower").toNumber() + " W");
        _updateTime.setText(result.get("uploadTime"));
        }
        WatchUi.requestUpdate();
    }

    function showError(message) {
        _acPowerIcon.setBitmap(Rez.Drawables.blank);
        _yieldTodayIcon.setBitmap(Rez.Drawables.blank);
        _feedInIcon.setBitmap(Rez.Drawables.blank);
        _pv1icon.setBitmap(Rez.Drawables.blank);
        _pv2icon.setBitmap(Rez.Drawables.blank);
        _pv3icon.setBitmap(Rez.Drawables.blank);
        _pv4icon.setBitmap(Rez.Drawables.blank);
        _socIcon.setBitmap(Rez.Drawables.blank);
        _batteryPowerIcon.setBitmap(Rez.Drawables.blank);

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
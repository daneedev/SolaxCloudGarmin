import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Math; 
import Toybox.Application;
import Toybox.Lang;

class SolaxCloudView2 extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    private var _panelMax;
    private var _homeMax;
    private var _batteryMax;
    private var _feedinMax;

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.SecondLayout(dc));

        _panelMax = findDrawableById("panelmax_text");
        _homeMax = findDrawableById("homemax_text");
        _batteryMax = findDrawableById("batterymax_text");
        _feedinMax = findDrawableById("feedinmax_text");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _panelMax.setText(Storage.getValue("maxPanelPower").format("%.2f") + " kW");
        _homeMax.setText(Storage.getValue("maxHomePower").format("%.2f") + " kW");
        _batteryMax.setText(Storage.getValue("maxBatteryPower").format("%.2f") + " kW");
        _feedinMax.setText(Storage.getValue("maxFeedinPower").format("%.2f") + " kW");
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
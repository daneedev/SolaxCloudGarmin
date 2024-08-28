import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;


class SolaxCloudApp extends Application.AppBase {
    private var firstFetch = false;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    public function getFirstFetch() as Boolean {
        return firstFetch;
    }

    public function setFirstFetch(value as Boolean) as Void {
        firstFetch = value;
    }
    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new SolaxCloudView(), new SolaxCloudDelegate() ];
    }

}

function getApp() as SolaxCloudApp {
    return Application.getApp() as SolaxCloudApp;
}
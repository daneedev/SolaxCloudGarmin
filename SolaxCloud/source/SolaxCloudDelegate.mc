import Toybox.Lang;
import Toybox.WatchUi;

class SolaxCloudDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new SolaxCloudMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}
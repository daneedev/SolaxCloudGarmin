import Toybox.Lang;
import Toybox.WatchUi;

class SolaxCloudDelegate extends WatchUi.BehaviorDelegate {

    private var _currentView as Lang.String;

    function initialize() {
        BehaviorDelegate.initialize();
        _currentView = "main";
    }

    function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Lang.Boolean {
        if (swipeEvent.getDirection() == WatchUi.SWIPE_UP && _currentView.equals("main")) {
            System.println("Screen has been swiped up!");
            WatchUi.pushView(new SolaxCloudView2(), self, WatchUi.SLIDE_UP);
            _currentView = "second";
        } else if (swipeEvent.getDirection() == WatchUi.SWIPE_DOWN && _currentView.equals("second")) {
            System.println("Screen has been swiped down!");
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            _currentView = "main";
        }
         return true;
    }
}
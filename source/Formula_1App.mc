using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class Formula_1App extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new Formula_1View() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        Ui.requestUpdate();
    }

}
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;

class ShyView extends WatchUi.WatchFace {

    private var _timeFont as FontResource?;
    private var _dateFont;

    function initialize() {
        WatchFace.initialize();

        // Load resources
        _timeFont = WatchUi.loadResource($.Rez.Fonts.id_font_fjalla) as FontResource;
        _dateFont = Graphics.FONT_MEDIUM;
    }

    function onSettingsChanged() {
        // No settings
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));

        // Dimensions
        //width = dc.getWidth();
        //height = dc.getHeight()
    }

    // Update the view
    public function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Draw the UI
        drawHoursMinutes(dc);
        drawDate(dc);
    }

    private function drawHoursMinutes(dc) {
        var clockTime = System.getClockTime();
        var hours = clockTime.hour.format("%02d");
        var minutes = clockTime.min.format("%02d");

        var screenHeight = dc.getHeight();
        var screenWidth = dc.getWidth();

        var x = screenWidth / 2;
        var y = screenHeight / 2;

        // Draw hours
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x - 2,
            y,
            _timeFont,
            hours,
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // Draw minutes
        dc.drawText(
            x + 2,
            y,
            _timeFont,
            minutes,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawDate(dc) {
        var now = Time.now();
        var date = Gregorian.info(now, Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$, $2$ $3$", [date.day_of_week, date.month, date.day]);

        var screenWidth = dc.getWidth();

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            screenWidth / 2,
            50,
            _dateFont,
            dateString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}

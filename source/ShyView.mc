import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;

class ShyView extends WatchUi.WatchFace {

    private var _timeFont as FontResource?;
    private var _dateFont as FontResource?;
    private var _height;
    private var _width;
    private var _centerX;
    private var _centerY;
    private var _dateAlreadyCalculated;
    private var _stringHours;
    private var _stringMinutes;
    private var _stringDateTop;
    private var _stringDateBottom;

    function initialize() {
        WatchFace.initialize();
        _dateAlreadyCalculated = false;

        // Load resources
        _timeFont = WatchUi.loadResource($.Rez.Fonts.id_font_fjalla_large) as FontResource;
        _dateFont = WatchUi.loadResource($.Rez.Fonts.id_font_fjalla_small) as FontResource;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));

        // Dimensions
        _width = dc.getWidth();
        _height = dc.getHeight();
        _centerX = _width / 2;
        _centerY = _height / 2;
    }

    // Update the view
    public function onUpdate(dc as Dc) as Void {
        // Same color for all
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);

        //dc.clear();

        // Draw the UI
        var clockTime = System.getClockTime();
        calculateTime(clockTime);
        drawHoursMinutes(dc);
        calculateDate(clockTime);
        drawDate(dc);     
    }

    private function drawHoursMinutes(dc) {
        // Draw hours
        dc.drawText(
            _centerX - 4,
            _centerY - 12,
            _timeFont,
            _stringHours,
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // Draw minutes
        dc.drawText(
            _centerX + 4,
            _centerY - 12,
            _timeFont,
            _stringMinutes,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );        
    }

    private function drawDate(dc) {
        // Top part of the date
        dc.drawText(
            _centerX,
            24,
            _dateFont,
            _stringDateTop,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // Bottom part
        dc.drawText(
            _centerX,
            _height - 32,
            _dateFont,
            _stringDateBottom,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        
    }

    private function calculateTime(clockTime) {
        var hours = clockTime.hour;
        var minutes = clockTime.min;
        if (clockTime.min < 11) {
            minutes = clockTime.min.format("%02d");
        }
        _stringHours = hours;
        _stringMinutes = minutes;
    }

    private function calculateDate(clockTime) {
        if (!_dateAlreadyCalculated || clockTime.min == 1) {
            var now = Time.now();
            var date = Gregorian.info(now, Time.FORMAT_MEDIUM);
            _stringDateTop = Lang.format("$1$", [date.day_of_week]);
            _stringDateTop = _stringDateTop.toUpper();
            _stringDateBottom = Lang.format("$1$ $2$", [date.day, date.month]);
            _stringDateBottom = _stringDateBottom.toUpper();

            _dateAlreadyCalculated = true;
        }
    }
}
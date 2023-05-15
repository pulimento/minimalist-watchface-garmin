import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;

class ShyView extends WatchUi.WatchFace {

    private var _timeFont as FontResource?;
    private var _secondaryFont as FontResource?;
    private var _height;
    private var _width;
    private var _centerX;
    private var _centerY;
    private var _dateAlreadyCalculated;
    private var _stringHours;
    private var _stringMinutes;
    private var _stringDateTop;
    //private var _stringDateBottom;
    private var _stringSteps;
    private var _colorAlreadySet;
    //private var _bm14;

    function initialize() {
        WatchFace.initialize();
        _dateAlreadyCalculated = false;
        _colorAlreadySet = false;

        // Load resources
        _timeFont = WatchUi.loadResource($.Rez.Fonts.id_font_fjalla_large) as FontResource;
        _secondaryFont = WatchUi.loadResource($.Rez.Fonts.id_font_fjalla_small) as FontResource;
        //_bm14 = WatchUi.loadResource(Rez.Drawables.bm14);
    }

    function onLayout(dc) {
        //setLayout(Rez.Layouts.WatchFace(dc));

        // Dimensions
        _width = dc.getWidth();
        _height = dc.getHeight();
        _centerX = _width / 2;
        _centerY = _height / 2;
    }

    // Update the view
    public function onUpdate(dc as Dc) as Void {
        _colorAlreadySet = false;

        // Same color for all
        if (!_colorAlreadySet) {
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
            _colorAlreadySet = true;
        }

        //dc.clear();

        // Draw the UI
        var clockTime = System.getClockTime();
        calculateTime(clockTime);
        calculateDate(clockTime);
        calculateSteps();

        drawHoursMinutes(dc);
        drawSecondaryText(dc);   
    }

    function onStart(state) {
        _colorAlreadySet = false;
    }

    private function drawHoursMinutes(dc) {
        /*
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
        */

        // Draw hours and minutes
        var stringHoursAndMinutes = _stringHours + ":" + _stringMinutes;
        dc.drawText(
            _centerX,
            _centerY - 12,
            _timeFont,
            stringHoursAndMinutes,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        
/*
        dc.drawBitmap(
            _centerX - 105,
            _centerY - 50,
            _bm14);

        dc.drawBitmap(
            _centerX + 5,
            _centerY - 50,
            _bm14);
            */
    }

    private function drawSecondaryText(dc) {

        // Top part: Date
        dc.drawText(
            _centerX,
            32,
            _secondaryFont,
            _stringDateTop,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // Bottom part: Steps
        dc.drawText(
            _centerX,
            _height - 36,
            _secondaryFont,
            _stringSteps,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );        
    }

    private function calculateTime(clockTime) {
        var hours = clockTime.hour;
        if (clockTime.hour < 11) {
            hours = clockTime.hour.format("%02d");
        }
        var minutes = clockTime.min;
        if (clockTime.min < 11) {
            minutes = clockTime.min.format("%02d");
        }
        _stringHours = hours;
        _stringMinutes = minutes;
    }

    private function calculateDate(clockTime) {
        if (!_dateAlreadyCalculated || clockTime.hour == 0 || clockTime.min == 0) {
            var now = Time.now();
            var date = Gregorian.info(now, Time.FORMAT_MEDIUM);
            _stringDateTop = Lang.format("$1$ $2$", [date.day, date.day_of_week]);
            //_stringDateTop = date.day_of_week;
            _stringDateTop = _stringDateTop.toUpper();
            ////_stringDateBottom = Lang.format("$1$ $2$", [date.day, date.month]);
            //_stringDateBottom = date.day + " " + date.month;
            //_stringDateBottom = _stringDateBottom.toUpper();

            _dateAlreadyCalculated = true;
        }
    }

    private function calculateSteps() {
		var info = ActivityMonitor.getInfo();
		var steps = info.steps;
		_stringSteps = steps;
    }
}
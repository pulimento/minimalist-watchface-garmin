import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time.Gregorian;

class ShyView extends WatchUi.WatchFace {

    private var _timeFont as FontResource?;
    private var _secondaryFont as FontResource?;
    private var _height;
    private var _width;
    private var _centerX as Number?;
    private var _centerY as Number?;
    private var _dateAlreadyCalculated as Boolean;
    private var _stringHours as String?;
    private var _stringMinutes as String?;
    private var _stringDateTop as String?;
    //private var _stringDateBottom;
    private var _stringSteps as Number?;
    private var _colorAlreadySet as Boolean;
    private var _lastCalculatedHours, _lastCalculatedMinutes as Number?;

    private var _bh1, _bh2, _bh3, _bh4, _bh5, _bh6, _bh7, _bh8, _bh9, _bh0 as BitmapResource;
    private var _bm1, _bm2, _bm3, _bm4, _bm5, _bm6, _bm7, _bm8, _bm9, _bm0 as BitmapResource;
    private var _bhTenths, _bhUnits, _bmTenths, _bmUnits as BitmapResource?;

    function initialize() {
        WatchFace.initialize();
        _dateAlreadyCalculated = false;
        _colorAlreadySet = false;

        // Load resources
        _timeFont = WatchUi.loadResource($.Rez.Fonts.id_font_noto_small) as FontResource;
        _secondaryFont = WatchUi.loadResource($.Rez.Fonts.id_font_noto_small) as FontResource;
        _bh1 = WatchUi.loadResource(Rez.Drawables.bh1) as BitmapResource;
        _bh2 = WatchUi.loadResource(Rez.Drawables.bh2) as BitmapResource;
        _bh3 = WatchUi.loadResource(Rez.Drawables.bh3) as BitmapResource;
        _bh4 = WatchUi.loadResource(Rez.Drawables.bh4) as BitmapResource;
        _bh5 = WatchUi.loadResource(Rez.Drawables.bh5) as BitmapResource;
        _bh6 = WatchUi.loadResource(Rez.Drawables.bh6) as BitmapResource;
        _bh7 = WatchUi.loadResource(Rez.Drawables.bh7) as BitmapResource;
        _bh8 = WatchUi.loadResource(Rez.Drawables.bh8) as BitmapResource;
        _bh9 = WatchUi.loadResource(Rez.Drawables.bh9) as BitmapResource;
        _bh0 = WatchUi.loadResource(Rez.Drawables.bh0) as BitmapResource;
        _bm1 = WatchUi.loadResource(Rez.Drawables.bm1) as BitmapResource;
        _bm2 = WatchUi.loadResource(Rez.Drawables.bm2) as BitmapResource;
        _bm3 = WatchUi.loadResource(Rez.Drawables.bm3) as BitmapResource;
        _bm4 = WatchUi.loadResource(Rez.Drawables.bm4) as BitmapResource;
        _bm5 = WatchUi.loadResource(Rez.Drawables.bm5) as BitmapResource;
        _bm6 = WatchUi.loadResource(Rez.Drawables.bm6) as BitmapResource;
        _bm7 = WatchUi.loadResource(Rez.Drawables.bm7) as BitmapResource;
        _bm8 = WatchUi.loadResource(Rez.Drawables.bm8) as BitmapResource;
        _bm9 = WatchUi.loadResource(Rez.Drawables.bm9) as BitmapResource;
        _bm0 = WatchUi.loadResource(Rez.Drawables.bm0) as BitmapResource;
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
        //dc.clear();
        _colorAlreadySet = false;

        // Same color for all
        if (!_colorAlreadySet) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            _colorAlreadySet = true;
        }

        // Draw the UI
        var clockTime = System.getClockTime();

        //calculateTime(clockTime);
        calculateTimeWithBitmaps(clockTime);
        calculateDate(clockTime);
        calculateSteps();

        //drawHoursMinutes(dc);
        drawHoursMinutesAsBitmaps(dc);
        drawSecondaryText(dc);   
    }

    function onStart(state) {
        _colorAlreadySet = false;
    }

    private function drawHoursMinutes(dc) {
        // Draw hours and minutes
        var stringHoursAndMinutes = _stringHours + ":" + _stringMinutes;
        dc.drawText(
            _centerX,
            _centerY - 12,
            _timeFont,
            stringHoursAndMinutes,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawHoursMinutesAsBitmaps(dc) {
        var charWidth = 60;
        var charHeight = 90;
        var xPaddingBetweenHoursAndMinutes = 4;
        var xPaddingBetweenDigits = 2;
        var yPosition = _centerY - (charHeight / 2);
        // Tenth of hours
        dc.drawBitmap(
            _centerX - (charWidth * 2) - xPaddingBetweenHoursAndMinutes - xPaddingBetweenDigits,
            yPosition,
            _bhTenths);
        // Units of hours
        dc.drawBitmap(
            _centerX - charWidth - xPaddingBetweenHoursAndMinutes,
            yPosition,
            _bhUnits);
        // Tenth of minutes
        dc.drawBitmap(
            _centerX + xPaddingBetweenHoursAndMinutes,
            yPosition,
            _bmTenths);
        // Units of minutes
        dc.drawBitmap(
            _centerX + charWidth + xPaddingBetweenHoursAndMinutes + xPaddingBetweenDigits,
            yPosition,
            _bmUnits);
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
            _stringDateTop = Lang.format("$1$ $2$", [date.day_of_week, date.day]);
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
		_stringSteps = info.steps;
    }

    private function calculateTimeWithBitmaps(clockTime) {
        if (clockTime.hour != _lastCalculatedHours) {
            calculateHoursWithBitmaps(clockTime);
        }
        if (clockTime.min != _lastCalculatedMinutes) {
            calculateMinutesWithBitmaps(clockTime);
        }
    }

    private function calculateHoursWithBitmaps(clockTime) {
        var hours = clockTime.hour;
        // Cache it
        _lastCalculatedHours = hours;
        if (clockTime.hour < 10) {
            _bhTenths = _bh0;
            _bhUnits = bitmapForUnits(hours, true);
            return;
        } else if (clockTime.hour < 20) {
            _bhTenths = _bh1;
            _bhUnits = bitmapForUnits(hours - 10, true);
            return;
        } else {
            _bhTenths = _bh2;
            _bhUnits = bitmapForUnits(hours - 20, true);
            return;
        }
    }

    private function calculateMinutesWithBitmaps(clockTime) {
        var minutes = clockTime.min;
        // Cache it
        _lastCalculatedMinutes = minutes;
        if (clockTime.min < 10) {
            _bmTenths = _bm0;
            _bmUnits = bitmapForUnits(minutes, false);
            return;
        } else if (clockTime.min < 20) {
            _bmTenths = _bm1;
            _bmUnits = bitmapForUnits(minutes - 10, false);
            return;
        } else if (clockTime.min < 30) {
            _bmTenths = _bm2;
            _bmUnits = bitmapForUnits(minutes - 20, false);
            return;
        } else if (clockTime.min < 40) {
            _bmTenths = _bm3;
            _bmUnits = bitmapForUnits(minutes - 30, false);
            return;
        } else if (clockTime.min < 50) {
            _bmTenths = _bm4;
            _bmUnits = bitmapForUnits(minutes - 40, false);
            return;
        } else if (clockTime.min < 60) {
            _bmTenths = _bm5;
            _bmUnits = bitmapForUnits(minutes - 50, false);
            return;
        }
    }

    private function bitmapForUnits(number, isHours) {
        if (number == 0) {
            if (isHours) {
                return _bh0;
            } else {
                return _bm0;
            }
        }
        if (number == 1) {
            if (isHours) {
                return _bh1;
            } else {
                return _bm1;
            }
        }
        if (number == 2) {
            if (isHours) {
                return _bh2;
            } else {
                return _bm2;
            }
        }
        if (number == 3) {
            if (isHours) {
                return _bh3;
            } else {
                return _bm3;
            }
        }
        if (number == 4) {
            if (isHours) {
                return _bh4;
            } else {
                return _bm4;
            }
        }
        if (number == 5) {
            if (isHours) {
                return _bh5;
            } else {
                return _bm5;
            }
        }
        if (number == 6) {
            if (isHours) {
                return _bh6;
            } else {
                return _bm6;
            }
        }
        if (number == 7) {
            if (isHours) {
                return _bh7;
            } else {
                return _bm7;
            }
        }
        if (number == 8) {
            if (isHours) {
                return _bh8;
            } else {
                return _bm8;
            }
        }
        if (number == 9) {
            if (isHours) {
                return _bh9;
            } else {
                return _bm9;
            }
        }
        // DEFAULT
        return _bh9;
    }
}
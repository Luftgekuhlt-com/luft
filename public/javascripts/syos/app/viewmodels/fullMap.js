function FullMap(appData) {
    var self = this;
    self.seats = ko.observableArray([]);
    self.sections = appData.sections;
    self.selectedScreenId = appData.selectedScreenId;
    self.zoom = ko.observable(1);
    self.seatSize = ko.observable(10);
    self.mapInfo = ko.observable();
    self.currentZone = ko.observable();

    self.mapStyle = ko.computed(function() {
        return self.mapInfo() != undefined ? {
            width: (((self.mapInfo().cols + 4) * self.seatSize())) + 'px',
            height: (((self.mapInfo().rows + 3) * self.seatSize())) + 'px',
            margin: '20px auto'
        } : {
            width: '100%',
            height: '600px',
            left: 0,
            top: 0,
            margin: '20px auto'
        };
    });

    self.seatOver = function(seat) {
        self.currentZone(seat.ZoneId);
    };
    self.seatOut = function(seat) {
        self.currentZone(null);
    };

    self.GetData = function(refresh) {
        self.seats.removeAll();
        var info = {cols: 0, rows: 0};
        info.minX = 1000;
        info.minY = 1000;
        info.maxX = 0;
        info.maxY = 0;
        info.containerHeight = $('.full-seat-map-wrap').height() || 480;
        info.containerWidth = $('.full-seat-map-wrap').width() || 850;
        
        seatProvider.GetSeatMap(refresh || false).done(function (data) {
            ko.utils.arrayForEach(data, function (screen) {
                info.xOffset = 0;
                info.yOffset = 0;
                info.minX = 0;
                info.minY = 0;
                info.maxX = 0;
                info.maxY = 0;
                jQuery.each(screen.Seats, function (i, s) {
                    info.minX = Math.min(info.minX, s.X);
                    info.minY = Math.min(info.minY, s.Y);
                    info.maxX = Math.max(info.maxX, s.X);
                    info.maxY = Math.max(info.maxY, s.Y);
                });
                info.xOffset = info.minX - 2;
                info.yOffset = info.minY;
            });
            ko.utils.arrayForEach(data, function (screen) {
                info.cols = Math.max(screen.Columns, info.cols);
                info.rows += (screen.Rows + 2);
                jQuery.each(screen.Seats, function (i, s) {
                    s.SeatSize = self.seatSize();
                    s.X = s.X - info.xOffset;
                    s.Y = s.Y - info.yOffset;
                    self.seats.push(new MapSpot(s));
                });
            });
            console.log('fullMap:info', info);
            self.mapInfo(info);
        });
    };

    self.selectedScreenId.subscribe(function() {
        self.GetData(true);
    });
    self.GetData(true);
    
    self.hasSeats = ko.computed(function () {
        return self.seats() && self.seats().length > 0;
    });
    
    self.rows = ko.computed(function() {
        var rowCollection = { };
        $.each(self.seats(), function(ind, seat) {
            if (rowCollection[seat.Row] == undefined) {
                rowCollection[seat.Row] = {
                    Y: seat.Y,
                    minX: seat.X,
                    maxX: seat.X,
                    seats: [seat]
                };
            } else {
                var rc = rowCollection[seat.Row];
                rc.seats.push(seat);
                rc.maxX = Math.max(rc.maxX, seat.X);
                rc.minX = Math.min(rc.minX, seat.X);
            }
        });
        var mapRows = [];
        for (r in rowCollection) {
            var row = rowCollection[r];
            row.name = r;
            var ss = Math.floor(Math.max(10, (self.seatSize() - 5)));
            row.leftStyle = {
                left: ((row.minX - 2) * self.seatSize()) + 'px',
                top: (row.Y * self.seatSize()) + 'px',
                width: (ss * 2) + 'px',
                height: ss + 'px',
                fontSize: Math.min(ss, 12) + 'px',
                lineHeight: ss + 'px',
                textAlign: 'right'
            };

            row.rightStyle = {
                left: ((row.maxX + 1.5) * self.seatSize()) + 'px',
                top: (row.Y * self.seatSize()) + 'px',
                width: (ss * 2) + 'px',
                height: ss + 'px',
                fontSize: Math.min(ss, 12) + 'px',
                lineHeight: ss + 'px',
                textAlign: 'left'
            };
            mapRows.push(row);
        }
        return mapRows;
    });

}
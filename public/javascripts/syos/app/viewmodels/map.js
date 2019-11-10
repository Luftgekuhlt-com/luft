function MapViewModel(appData) {
    var self = this;
    self.seats = ko.observableArray([]);
    self.sections = appData.sections;
    self.selectedScreenId = appData.selectedScreenId;
    self.zoom = ko.observable(1);
    self.seatSize = ko.observable(25);
    self.mapInfo = ko.observable();
    self.currentZone = ko.observable();
    self.showSummary = function() {
        //router.navigate('');
    };

    self.mapStyle = ko.computed(function() {
        return self.mapInfo() != undefined ? {
            width: (((self.mapInfo().cols + 4) * self.seatSize())) + 'px',
            height: (((self.mapInfo().rows + 3) * self.seatSize())) + 'px',
            margin: '20px auto'
        } : {
            width: '900px',
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
        window.SeatProvider.GetSeats(self.selectedScreenId(), refresh || false).done(function(data) {
            var info = { };
            info.minX = 1000;
            info.minY = 1000;
            info.maxX = 0;
            info.maxY = 0;
            info.containerHeight = $('.seat-map-wrap').height() || 480;
            info.containerWidth = $('.seat-map-wrap').width() || 850;
            ko.utils.arrayForEach(data, function(s) {
                info.minX = Math.min(info.minX, s.XPosition);
                info.minY = Math.min(info.minY, s.YPosition);
                info.maxX = Math.max(info.maxX, s.XPosition);
                info.maxY = Math.max(info.maxY, s.YPosition);
            });
            info.cols = info.maxX - info.minX;
            info.rows = info.maxY - info.minY;
            info.xOffset = info.minX - 2;
            info.yOffset = info.minY;
            self.mapInfo(info);
            var w = Math.max(Math.floor((info.containerWidth - 40) / (info.cols + 4)), 10);
            var h = Math.max(Math.floor((info.containerHeight - 22) / (info.rows + 2)), 10);
            self.seatSize(Math.floor(Math.min(w, h)) * self.zoom());
            self.seats(jQuery.map(data, function(s) {
                s.SeatSize = self.seatSize();
                s.XPosition = s.XPosition - info.xOffset;
                s.YPosition = s.YPosition - info.yOffset;
                return new Seat(s);
            }));
        });
    };

    self.zoom.subscribe(function() {
        self.GetData();
    });


    self.selectedScreenId.subscribe(function() {
        self.GetData(true);
    });
    self.GetData(true);

    self.selectedSeats = ko.computed(function() {
        return ko.utils.arrayFilter(self.seats(), function(seat) {
            return seat.selected();
        });
    });

    self.rows = ko.computed(function() {
        var rowCollection = { };
        $.each(self.seats(), function(ind, seat) {
            if (rowCollection[seat.SeatRow] == undefined) {
                rowCollection[seat.SeatRow] = {
                    Y: seat.YPosition,
                    minX: seat.XPosition,
                    maxX: seat.XPosition,
                    seats: [seat]
                };
            } else {
                var rc = rowCollection[seat.SeatRow];
                rc.seats.push(seat);
                rc.maxX = Math.max(rc.maxX, seat.XPosition);
                rc.minX = Math.min(rc.minX, seat.XPosition);
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

    self.hasSeats = ko.computed(function() {
        return self.seats() && self.seats().length > 0;
    });

    self.selectedSeatsTotal = ko.computed(function() {
        var totalPrice = 0;
        $.each(self.selectedSeats(), function(ind, seat) {
            totalPrice += seat.price();
        });

        return numeral(totalPrice).format('$0,0.00');
    });

    self.zoomIn = function() {
        self.zoom(self.zoom() + 0.2);
    };

    self.zoomOut = function() {
        if (self.zoom() > 1) {
            self.zoom(self.zoom() - 0.2);
        }
    };

    self.reserveSeats = function() {
        var seatCart = { };
        var reqs = [];
        $.each(self.selectedSeats(), function(ind, seat) {
            console.log('reserveSeats', seat)
            seatCart[seat.Zone] = seatCart[seat.Zone] || { seats: [], pricetypes: [], regularCount: 0, childCount: 0 };
            seatCart[seat.Zone]['seats'].push(seat.Id);
            seatCart[seat.Zone]['pricetypes'].push(seat.selectedPriceType());
            if (seat.selectedPriceType() == parseInt(window.app.PriceType)) seatCart[seat.Zone]['regularCount'] += 1;
            if (seat.selectedPriceType() == 260) seatCart[seat.Zone]['childCount'] += 1;
        });
        for (z in seatCart) {
            var cartItem = seatCart[z];
            if (window.syosVars.Family === true && (cartItem['childCount'] == 0 || cartItem['regularCount'] == 0)) {
                alert('At least one adult and one child is required for family pricing.');
                return false;
            } else {
                if (cartItem['childCount'] > 0 && cartItem['regularCount'] == 0) {
                    alert('An adult ticket is required to purchase a child ticket.');
                    return false;
                } else {
                    reqs.push(window.SeatProvider.ReserveSeats(z, cartItem['seats'], cartItem['pricetypes']).done(function(data) {
                        console.log('Reserved ' + data + 'seats.', z, cartItem);
                    }));
                }
            }
        }
        $.when.apply(null, reqs).done(function() {
            window.location = window.syosVars.CartRedirectUrl;
        });
    };

    $('#syos_ctr').on('seat:selection-changed', function () {
        self.seats.valueHasMutated();
    });
}
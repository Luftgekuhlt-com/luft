function Seat(data) {
    var obj = this;
    //console.log(data);

    for (p in data) {
        obj[p] = data[p];
    }

    obj.selected = ko.observable(false);
    obj.selectedPriceType = ko.observable(window.app.PriceType);
    obj.seatText = ko.computed(function () {
        return obj.SeatRow + ' - ' + obj.SeatNumber;
    });

    obj.seatStyle = ko.computed(function () {
        return {
            left: (obj.XPosition * obj.SeatSize) + 'px',
            top: (obj.YPosition * obj.SeatSize) + 'px',
            width: (obj.SeatSize - 5) + 'px',
            height: (obj.SeatSize - 5) + 'px'
        };
    });

    obj.sectionName = ko.computed(function () {
        var name = "";
        $.each(window.app.sections(), function (ind, section) {
                $.each(section.zones, function (ind2, zone) {
                    if (zone == obj.Zone && name.length == 0) {
                        name = section.name;
                    }
                });
        });
        return name;
    });

    obj.price = ko.computed(function () {
        var price = 0;
        var pt = parseInt(obj.selectedPriceType());
        $.each(window.app.sections(), function (ind, section) {
                $.each(section.zones, function (ind2, zone) {
                    if (zone == obj.Zone) {
                        price = section.prices[zone];
                        if (pt != parseInt(window.app.PriceType)) {
                            var sop = section.otherPriceTypes();
                            price = sop[pt][zone];
                        }
                    }
                });
        });
        return price;
    });

    obj.priceFormatted = ko.computed(function () {
        return numeral(obj.price()).format('$0,0.00');
    });

    obj.selectedPriceFormatted = ko.computed(function () {
        var pr = obj.price();
        return numeral(pr).format('$0,0.00');
    });

    obj.otherPriceDisplay = ko.computed(function () {
        var displays = "";
        $.each(window.app.sections(), function (ind, s) {
            $.each(s.zones, function (ind2, zone) {
                if (zone == obj.Zone) {
                    for (var pt in s.otherPrices()) {
                        //console.log('otherPriceDisplay-2', s.otherPrices[pt][zone], s.otherPrices);
                        var price = s.otherPrices()[pt][zone];
                            displays += pt + ': ' + numeral(price).format('$0,0.00');
                    }
                }
            });
        });
        return displays;
	});

	obj.showOtherPriceDisplay = ko.computed(function () {

		return obj.otherPriceDisplay().length > 0;
	});

    obj.tooltipContent = ko.computed(function () {
        var tipHolder = $('<div class="tip-holder"></div>');
        tipHolder.append($('<div/>').addClass('section').html(obj.sectionName()));
        tipHolder.append($('<div/>').addClass('seat-text').html('Row <strong>' + obj.SeatRow + '</strong> Seat <strong>' + obj.SeatNumber + '</strong>'));
        var otherDisplay = obj.otherPriceDisplay();
        if (otherDisplay.length > 0) {
            tipHolder.append($('<div/>').addClass('price').html('Regular: <strong>' + obj.priceFormatted() + '</strong>'));
            tipHolder.append($('<div/>').addClass('price other-price').html(otherDisplay));
        } else {
            tipHolder.append($('<div/>').addClass('price').html('Cost: <strong>' + obj.priceFormatted() + '</strong>'));
        }
        tipHolder.append($('<div/>').addClass('click-text').html('Click to Select Seat'));

        return tipHolder.html();
    });


    obj.otherPriceTypes = ko.computed(function () {
        var pTypes = [];
        for (var p in window.app.OtherPriceTypes) {
            pTypes.push({ id: p, name: window.app.OtherPriceTypes[p] });
        }
        return pTypes;
    });



    obj.toggleSelected = function () {
        if (obj.SeatStatus == 0) {
            obj.selected(!obj.selected());
            $('#syos_ctr').trigger('seat:selection-changed', obj);
        } else {
            obj.selected(false);
        }
    };
}
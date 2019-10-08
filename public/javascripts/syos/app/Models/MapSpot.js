function MapSpot(data) {
    var obj = this;
    //console.log(data);

    for (p in data) {
        obj[p] = data[p];
    }


    obj.section = ko.computed(function () {
        var sec = null;
        $.each(window.app.sections(), function (ind, section) {
            //console.log(section.id, section.zones);
            $.each(section.zones, function (ind2, zone) {
                //console.log(zone.Id, obj.ZoneId);
                if (zone.Id == obj.Z) {
                    sec =  section;
                }
            });
        });
        return sec;
    });

    obj.seatStyle = ko.computed(function () {
        var sectionColor = window.baseMapColor;
        //console.log('obj.section', obj.ZoneId, obj.section(), window.app.sections());
        if(obj.section() != null) {
            sectionColor = obj.section().SectionColor;
        }
        return {
            left: (obj.X * obj.SeatSize) + 'px',
            top: (obj.Y * obj.SeatSize) + 'px',
            width: (obj.SeatSize) + 'px',
            height: (obj.SeatSize) + 'px',
            background: sectionColor
        };
    });

    obj.sectionName = ko.computed(function () {
        var name = "";
        $.each(window.app.sections(), function (ind, section) {
                $.each(section.zones, function (ind2, zone) {
                    if (zone.Id == obj.Z) {
                        name = section.name;
                    }
                });
        });
        return name;
    });
    

    obj.price = ko.computed(function () {
        var price = 0;
        $.each(window.app.sections(), function (ind, section) {
                $.each(section.zones, function (ind2, zone) {
                    if (zone.Id == obj.Z) {
                        price = section.prices[zone];
                    }
                });
        });
        return price;
    });

    obj.priceFormatted = ko.computed(function () {
        return numeral(obj.price()).format('$0,0.00');
    });
}
window.SeatProvider = {};
    //window.SeatProvider.PerformanceNumber = window.syosVars.PerformanceNumber;
    window.SeatProvider.seats = [];

    window.SeatProvider.GetSummary = function (zoneIds, sectionIds, screenIds) {
        var reqData = {};
        if (zoneIds) {
            reqData.zones = zoneIds.join(',');
        }
        if (sectionIds) {
            reqData.sections = sectionIds.join(',');
        }
        if (screenIds) {
            reqData.screens = screenIds.join(',');
        }
        var promise = jQuery.ajax({
            url: '/syos-api/summary/' + window.SeatProvider.PerformanceNumber,
            cache: false,
            data: reqData,
            dataType: 'json',
            success: function (data) {
                return data;
            }
        });
        return promise;
    };

    window.SeatProvider.GetSeats = function (screen, refreshed) {
        if (refreshed === true) {
            window.SeatProvider.seats = [];
        }
        if (window.SeatProvider.seats.length > 0) {
            var deferred = new jQuery.Deferred();
            deferred.resolve(provider.seats);
            return deferred.promise();
        }

        var promise = jQuery.ajax({
            url: '/tickets/' + window.SeatProvider.PerformanceNumber + '/syos-screen/' + screen,
            cache: false,
            dataType: 'json',
            success: function (data) {
                window.SeatProvider.seats = data;
                return data;
            }
        });
        return promise;
    };

    window.SeatProvider.GetSeatMap = function (refreshed) {

        var promise = jQuery.ajax({
            url: '/syos-api/seatmap/' + window.SeatProvider.PerformanceNumber,
            cache: false,
            dataType: 'json',
            success: function (data) {
                return data;
            }
        });
        return promise;
    };

    window.SeatProvider.ReserveSeats = function (zone, seats, pricetype) {
        var pt = window.syosVars.PriceType;
        if (pricetype) {
            pt = pricetype.join(',');
        }
        var reqData = {
            priceType: pt,
			promo: window.syosVars.Promo || "",
			promo_code: window.syosVars.PromoCode || "",
            performanceNumber: window.SeatProvider.PerformanceNumber,
            numberOfSeats: seats.length,
            zone: zone,
            requestedSeats: seats.join(','),
            specialRequests: ''
        };

        var promise = jQuery.ajax({
            url: '/tickets/' + window.SeatProvider.PerformanceNumber + '/syos_reserve',
            type: 'POST',
            data: reqData,
            cache: false,
            dataType: 'json',
            success: function (data) {
                return data;
            }
        });
        return promise;
    };
define(['jquery','moment', 'core_patches'], function (jQuery, moment) {
    var provider = {};
    provider.PerformanceNumber = window.syosVars.PerformanceNumber;

	provider.GetPerformance = function (offerId) {
		var parms = {};
		if (offerId) {
			parms.offer = offerId;
		}
        var promise = jQuery.ajax({
			url: '/syos-api/performance/' + provider.PerformanceNumber,
			data: parms,
            cache: false,
            success: function (data) {
                return data;
            }
        });
        return promise;
    };

    return provider;
});
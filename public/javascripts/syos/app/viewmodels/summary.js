define(['jquery', 'knockout', 'durandal/app', 'plugins/router'], function (jQuery, ko, app, router) {
    var sections = app.sections;
    var performance = app.performance;

    var zoneMapUrl = ko.computed(function () {
        console.log('zoneMapUrl', performance());
        return performance() != undefined ? "/syos/maps/" + performance().zoneMap + ".svg" : null;
    });

    app.performance.subscribe(function () {
        loadSeatMap();
    });

    var loadSeatMap = function () {
        if (zoneMapUrl() == null) return;
        jQuery.get(zoneMapUrl(), null, function (svgDoc) {
            var seatmap = jQuery('.seat-map-svg');
            var importedSeatMapElement = document.importNode(svgDoc.documentElement, true);
            seatmap.html(importedSeatMapElement);
            jQuery('.section-group', seatmap).each(function (ind, el) {
                jQuery(el).bind('click', function () {
                    router.navigate('map/' + $(el).data('screen'));
                });
            });
        }, "xml");
    };

    var compositionComplete = function () {
        loadSeatMap();
    };

    var vmodel = {
        sections: sections,
        performance: performance,
        zoneMapUrl: zoneMapUrl,
        compositionComplete: compositionComplete
    };

    return vmodel;
});
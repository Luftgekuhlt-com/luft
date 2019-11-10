define([
    'jquery',
    'knockout',
    'plugins/router',
    'durandal/app',
    'durandal/viewEngine',
    'syos_performance_provider',
    'syos_seat_provider',
    'syos_zonemap_provider',
    'syos_performance',
    'numeral',
    'core_patches'], function (
        jQuery,
        ko,
        router,
        app,
        viewEngine,
        performanceProvider,
        seatProvider,
        zonemapProvider,
        Performance,
        numeral) {
        
        var activate = function () {
            router.map([
                { route: '', title: 'Select Section', moduleId: '/syos/app/viewmodels/summary.js', nav: true },
                { route: 'map/:code', title: 'Select Seats', moduleId: '/syos/app/viewmodels/map.js', nav: true }
            ]).buildNavigationModel();

            return router.activate();
        };

        app.PerformanceNumber = window.syosVars.PerformanceNumber;
        app.PriceType = window.syosVars.PriceType;
        app.DefaultPriceType = window.syosVars.DefaultPriceType;

        var performance = ko.observable(null);
        app.performance = performance;

        var sections = ko.observableArray([]);
        app.sections = sections;

        app.zoom = ko.observable(1);
        app.seatSize = ko.observable(25);

        performanceProvider.GetPerformance().done(function (perf) {
            var p = new Performance(perf);
            performance(p);
            seatProvider.GetSummary(p.zoneIds).done(function (data) {
                var sectionData = zonemapProvider.GetSections(p.zoneMap);
                $.each(sectionData, function (ind1, s) {
                    $.each(s.zones, function (ind2, z) {
                        var pz = p.zones[z+''];
                        if (pz != undefined) {
                            console.log('pz is defined', pz);
                            s.totalAvailable = pz.availCount;
                            s.price = pz.prices[app.PriceType] || pz.prices[app.DefaultPriceType];
                        }else {
                            console.log('pz is undefined', p.zones);
                        }
                    });
                    s.priceDisplay = ko.computed(function () {
                        return numeral(s.price).format('$0,0.00');
                    });
                });
                sections(sectionData);
            });
        });

        var displayDate = ko.computed(function () {
            if (performance() != undefined) {
                return performance().date.format("dddd, MMMM Do YYYY h:mma");
            }
            return "";
        });


        return {
            performance: performance,
            displayDate: displayDate,
            sections: sections,
            router: router,
            activate: activate
        };
    });
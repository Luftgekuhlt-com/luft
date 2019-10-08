function Performance(data) {
    var obj = this;
    obj.title = data.Title;
    obj.date = moment(data.PerformanceDate);
    obj.displayDate = data.PerformanceDateDisplay;
    obj.zoneMap = data.ZoneMap;
    obj.venue = data.Venue;
    obj.zones = {};
    obj.zoneIds = [];
    obj.sectionNames = [];
    obj.sectionIds = {};
    obj.sections = [];
    $.each(data.Sections, function (ind, section) {
      //if(obj.sectionIds[section.Id] == undefined){
        obj.sectionIds[section.Id] = section;
        var s = {
            description: section.Description,
            zoneId: section.Zone,
            basePrice: section.Prices.RegularPrice,
            availCount: section.AvailableCount,
            prices: {}
        };
        //console.log('perf.prices', section.Prices)
        s.prices[section.Prices.RegularPriceType] = section.Prices.RegularPrice;
        if(section.Prices.ChildPriceType > 0){
            s.prices[section.Prices.ChildPriceType] = section.Prices.ChildPrice;
        }
        obj.sectionNames.push(section.Description);
        obj.zoneIds.push(parseInt(section.Zone));
        obj.zones[s.zoneId+''] = s;
      //}
    });
}
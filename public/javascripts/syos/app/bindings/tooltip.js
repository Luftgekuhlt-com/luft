define(['jquery', 'knockout', 'bootstrap'], function ($, ko) {
    ko.bindingHandlers.tooltip = {
        init: function (element, valueAccessor, allBindings) {
            var local = ko.utils.unwrapObservable(valueAccessor()),
                options = allBindings().tooltipOptions || {};

            ko.utils.extend(options, ko.bindingHandlers.tooltip.options);
            options.title = local;
            options.template = '<div class="tooltip '+(options.tipClass || '')+'" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>';

            //console.log(JSON.stringify(options));
            $(element).tooltip(options);

            ko.utils.domNodeDisposal.addDisposeCallback(element, function () {
                $(element).tooltip('destroy');
            });
        },
        options: {
            html: true
        }
    };
});
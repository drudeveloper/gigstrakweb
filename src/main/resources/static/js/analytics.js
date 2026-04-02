document.addEventListener("DOMContentLoaded", function () {
    var trackedNodes = document.querySelectorAll("[data-analytics-event]");

    trackedNodes.forEach(function (node) {
        node.addEventListener("click", function () {
            if (typeof window.gtag !== "function") {
                return;
            }

            window.gtag("event", node.dataset.analyticsEvent, {
                event_category: "engagement",
                event_label: node.dataset.analyticsLabel || ""
            });
        });
    });
});

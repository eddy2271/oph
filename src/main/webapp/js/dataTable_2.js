/*! DataTables Bulma integration
 * ©2020 SpryMedia Ltd - datatables.net/license
 */
! function(t) {
    "function" == typeof define && define.amd ? define(["jquery", "datatables.net"], function(a) {
        return t(a, window, document)
    }) : "object" == typeof exports ? module.exports = function(a, e) {
        return a = a || window, (e = e || ("undefined" != typeof window ? require("jquery") : require("jquery")(a))).fn.dataTable || require("datatables.net")(a, e), t(e, 0, a.document)
    } : t(jQuery, window, document)
}(function(v, a, i, r) {
    "use strict";
    var s = v.fn.dataTable;
    return v.extend(!0, s.defaults, {
        dom: "<'columns is-gapless is-multiline'<'column is-half'l><'column is-half'f><'column is-full'tr><'column is-half'i><'column is-half'p>>",
        renderer: "bulma"
    }), v.extend(s.ext.classes, {
        sWrapper: "dataTables_wrapper dt-bulma",
        sFilterInput: "input",
        sLengthSelect: "custom-select custom-select-sm form-control form-control-sm",
        sProcessing: "dataTables_processing card"
    }), s.ext.renderer.pageButton.bulma = function(d, a, u, e, c, p) {
        function f(a, e) {
            for (var t, n, i, r, s = function(a) {
                    a.preventDefault(), v(a.currentTarget.firstChild).attr("disabled") || m.page() == a.data.action || m.page(a.data.action).draw("page")
                }, l = 0, o = e.length; l < o; l++)
                if (n = e[l], Array.isArray(n)) f(a, n);
                else {
                    switch (g = b = "", r = !(i = "a"), n) {
                        case "ellipsis":
                            b = "&#x2026;", g = "pagination-link", r = !0, i = "span";
                            break;
                        case "first":
                            b = w.sFirst, g = n, r = c <= 0;
                            break;
                        case "previous":
                            b = w.sPrevious, g = n, r = c <= 0;
                            break;
                        case "next":
                            b = w.sNext, g = n, r = p - 1 <= c;
                            break;
                        case "last":
                            b = w.sLast, g = n, r = p - 1 <= c;
                            break;
                        default:
                            b = n + 1, g = c === n ? "is-current" : ""
                    }
                    b && (t = v("<li>", {
                        id: 0 === u && "string" == typeof n ? d.sTableId + "_" + n : null
                    }).append(v("<" + i + ">", {
                        href: r ? null : "#",
                        "aria-controls": d.sTableId,
                        "aria-disabled": r ? "true" : null,
                        "aria-label": x[n],
                        "aria-role": "link",
                        "aria-current": "is-current" === g ? "page" : null,
                        "data-dt-idx": n,
                        tabindex: d.iTabIndex,
                        class: "pagination-link " + g,
                        disabled: r
                    }).html(b)).appendTo(a), d.oApi._fnBindAction(t, {
                        action: n
                    }, s))
                }
        }
        var b, g, t, m = new s.Api(d),
            w = (d.oClasses, d.oLanguage.oPaginate),
            x = d.oLanguage.oAria.paginate || {};
        try {
            t = v(a).find(i.activeElement).data("dt-idx")
        } catch (a) {}
        var n = v('<nav class="pagination" role="navigation" aria-label="pagination"><ul class="pagination-list"></ul></nav>');
        v(a).empty().append(n), f(n.find("ul"), e), t !== r && v(a).find("[data-dt-idx=" + t + "]").trigger("focus")
    }, v(i).on("init.dt", function(a, e) {
        "dt" === a.namespace && (a = new v.fn.dataTable.Api(e), v("div.dataTables_length select", a.table().container()).wrap('<div class="select">'))
    }), s
});
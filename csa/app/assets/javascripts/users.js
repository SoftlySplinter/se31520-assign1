var DROP_LIST_SURNAME_CLASS = '.drop-list-surname';
var USER_DETAIL_ID = '#user-detail';
var IMAGE_TAG_CLASS = '.image-tag';
var SEARCH_FIELD_ID = '#q';
var UI_AUTOCOMPLETE_CLASS = '.ui-autocomplete';
var SURNAME_SPINNER_ID = '#surname-spinner';
var USER_CHECKBOX_CLASS = '.user_search_checkbox';

var checkboxClicked = { };

$(window).load(function () {

    // Use the jQuery-ui autocomplete function.
    $(SEARCH_FIELD_ID).autocomplete({
        source:function (request, response) {
            // Build the query string to include checkbox selection
            var urlStr = "/users/search.json";
            var firstTime = true;
            $.each(checkboxClicked, function (key, value) {
                if (value) {
                    if (firstTime) {
                        urlStr += '?';
                        firstTime = false;
                    } else {
                        urlStr += '&';
                    }
                    urlStr += key + "=1";
                }
            });
            $.ajax({ url:urlStr,
                dataType:"json",
                data:{ q:request.term }, // Ensures ?q=value sent as url
                success:function (data) {
                    response(data);

                    // Needed to do this otherwise elements in
                    // Ajax generated dropdown list were not
                    // visible to IMAGE_TAG_CLASS event handler
                    bindAll();
                    $(SURNAME_SPINNER_ID).hide();
                }
            })
        },
        search:function (event) {
            $(SURNAME_SPINNER_ID).show();
        }
        // We override the _renderItem function because we need
        // to customize what we display for each menu item
    }).data("autocomplete")._renderItem = function (ul, item) {
        return $("<li class='ui-menu-item'></li>")
            .data("item.autocomplete", item)
            .append(item.html)// The data sent from the server
            .appendTo(ul);
    }

    // Initialize the event handlers
    bindAll();

});

function bindAll() {
    // Called when our Ajax request from an element containing the
    // IMAGE_TAG_CLASS has completed. Here we update the USER_DETAIL_ID
    // element with the returned HTML content
    $(IMAGE_TAG_CLASS).bind('ajax:complete', function (et, e) {
        $(USER_DETAIL_ID).html(e.responseText);
    });

    // Each row in the autocomplete droplist has an image
    // and a span containing the user's surname. When a user
    // clicks on the span we update the input field with the
    // selected text and hide the dropdown list
    $(DROP_LIST_SURNAME_CLASS).click(function (event) {
        //
        $(SEARCH_FIELD_ID).val(event.target.textContent);
        $(UI_AUTOCOMPLETE_CLASS).hide();
    });

    $(USER_CHECKBOX_CLASS).click(function (event) {

        var value = $(this).attr('name');
        var secondTime = false;
        // Add or remove to/from the hashtable
        if ($(this).is(':checked')) {
            if (checkboxClicked[value]) secondTime = true;
            checkboxClicked[value] = true;
        } else {
            if (!checkboxClicked[value]) secondTime = true;
            checkboxClicked[value] = false;
        }
        // Force the autocomplete to search again every time a
        // user clicks on a checkbox. Unfortunately, click is
        // called twice every time a checkbox is clicked. We therefore
        // have to ignore the second call
        if (!secondTime) $(SEARCH_FIELD_ID).autocomplete('search');
    });


}


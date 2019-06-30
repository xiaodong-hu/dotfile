$(function() {
    loadLang();
    shuffleProxy();
    loadSettings();

    // click install button
    $('#install-button').click(function () {
        chrome.tabs.create({'url': 'https://chrome.google.com/webstore/detail/' + ininjaApps.old}, function(tab) { });
    });

    // on/off proxy
    $('#btn-on-off').click(function() {
        if(!$(this).next().hasClass('slider-green')) {
            $('.loader img').show();
            $(this).prop('disabled', true).prop('checked', true);

            var ipsList = $('#proxy-server').val().split(':');
            var randIndex = (ipsList.length > 2) ? getRandomInt(0, ipsList.length - 2) : 0;
            authToServer({
              proxyServer: ipsList[randIndex],
              proxyPort: ipsList[ipsList.length - 1]
            });
        } else {
            resetProxySettings();
        }
    });

    // change proxy server
    $('#proxy-server').change(function() {
        resetProxySettings();
    });

    // open other-apps window
    $('#use-in-other-apps').click(function (e) {
        e.preventDefault();
        var width = 400;
        var height = 350;
        var left = (screen.width/2)-(width/2);
        var top = (screen.height/2)-(height/2);
        chrome.windows.create({
            url: 'other-apps.html',
            type: 'popup',
            width: width,
            height: height,
            focused: true,
            left: left,
            top: top
        }, window.close.bind(window));
    });

    // init tag editor
    chrome.storage.local.get(['whiteList'], function(items) {
        $('#white-list').tagEditor({
            initialTags: items.whiteList,
            placeholder: 'domain.com',
            forceLowercase: true,
            onChange: function(field, editor, tags) {
                chrome.storage.local.get(['proxyIsWork', 'proxyServer', 'proxyPort'], function(items) {
                    var domains = [];
                    for (var i = 0; i < tags.length; i++) {
                        if (isValidDomain(tags[i]))
                            domains.push(tags[i]);
                        else
                            $('#white-list').tagEditor('removeTag', tags[i]);
                        if(isValidURL(tags[i])){
                            var domain = tags[i].split('/')[2];
                            $('#white-list').tagEditor('addTag', domain);
                            domains.push(domain);
                        }
                    }
                    chrome.storage.local.set({whiteList: domains}, function () { });

                    if (items.proxyIsWork)
                        useProxySettings(items.proxyServer, items.proxyPort, domains);
                });
            }

        });
    });

    // open tab settings
    $('#settings').click(function (e) {
        e.preventDefault();

        chrome.storage.local.get(['isAutoStart'], function(items) {
            if(items.isAutoStart)
                $('#checkbox-auto-start').prop('checked', items.isAutoStart);
        });

        $('.wrap').slideUp(500);
        $('.settings-tab').slideDown(500);
    });

    // back to home tab
    $('.back-to-home').click(function() {
        $('.settings-tab').slideUp(500);
        $('.wrap').slideDown(500);
    });

    // on/off auto proxy start
    $('#checkbox-auto-start').click(function() {
        chrome.storage.local.set({ isAutoStart: $('#checkbox-auto-start').prop('checked') }, function() { });
    });

});

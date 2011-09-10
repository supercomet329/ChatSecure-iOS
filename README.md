ChatSecure
=========

ChatSecure is a very simple IM client for iOS that integrates encrypted "Off the Record" messaging support from the [libotr](http://www.cypherpunks.ca/otr/) library. It uses the [LibOrange](https://github.com/unixpickle/LibOrange) library to handle all of the OSCAR functionality and the [xmppframework](http://code.google.com/p/xmppframework/) to handle XMPP (in progress).

Compatibility
=========

**Bold** indicates it has been tested and works properly.

Native
------
* **[Adium](http://adium.im/) (Mac OS X) - OTR works over both XMPP and Oscar.**
* climm (Unix-like), since (mICQ) 0.5.4.
* MCabber (Unix-like), since 0.9.4
* CenterIM (Unix-like), since 4.22.2
* Phoenix Viewer (successor of Emerald Viewer), a Second Life client (Cross-platform)
* Vacuum IM (Cross-platform)
* Jitsi (Cross-platform)
* BitlBee (Cross-platform), since 3.0 (optional at compile-time)

Plug-in
------
* [Pidgin](http://pidgin.im/) (cross-platform), with [pidgin-otr](http://www.cypherpunks.ca/otr/index.php#downloads) plugin.
* Kopete (Unix-like), either with a third-party plugin or, since the addition of Kopete-OTR on 12th of March 2008, with the version of Kopete shipped with KDE 4.1.0 and later releases.
* Miranda IM (Microsoft Windows), with a third-party plugin
* Psi (Cross-platform), with a third-party plugin and build, in Psi+ native usable
* Trillian (Microsoft Windows), with a third-party plugin
* irssi, with a third-party plugin

Proxy (download [here](http://www.cypherpunks.ca/otr/index.php#downloads))
------
* AOL Instant Messenger (Mac OS X, Microsoft Windows)
* iChat (Mac OS X)
* Proteus (Mac OS X)

Phone apps
------
* [Gibberbot](https://guardianproject.info/apps/gibber/) (formerly OtRChat), a free and open source Android application (still in early development) produced by The Guardian Project, provides OTR protocol compatible over XMPP chat.

[Full List](http://en.wikipedia.org/wiki/Off-the-Record_Messaging#Client_support)

License
=========

If you want to use this code in your own project please let me know!

Third-party Libraries
=========

* [Cypherpunks libotr](http://www.cypherpunks.ca/otr/) - provides the core encryption capabilities
* [LibOrange](https://github.com/unixpickle/LibOrange) - handles all of the OSCAR (AIM) functionality
* [xmppframework](http://code.google.com/p/xmppframework/) - XMPP support
* [NSAttributedString-Additions-for-HTML](https://github.com/Cocoanetics/NSAttributedString-Additions-for-HTML) - prettier chat window
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD) - a nice looking progress HUD

Acknowledgements
=========

* [Nick Hum](http://nickhum.com/) - awesome icon concept.
* [Glyphish](http://glyphish.com/) - icons used on the tab bar.
* [Adium](http://adium.im/) - lock/unlock icon used in chat window.
* [Sergio Sánchez López](http://www.iconfinder.com/icondetails/7043/128/aim_icon) - AIM protocol icon.
* [Goxxy](http://rocketdock.com/addon/icons/3462) - Google Talk icon.
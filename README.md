<p align="center">
  <img src="https://github.com/nickimola/genius-hub-lite/blob/master/src/assets/images/logo-dark.png"> 
</p>

## Genius Hub - Lite
Quickly adjust you Genius Hub system directly from Google Chrome! Get it from the [Chrome Web Store](https://chrome.google.com/webstore/detail/genius-app-lite/gnkejjcimppiomocmahbpfeimnobimfp).

### What does this extension do?
This extension provides a quick and easy way to adjust the heating on a specific room without having to open the entire app. The idea came to my mind when working from home: I was feeling a bit cold and i had to open a new tab on Chrome, navigate to the [genius website](https://geniushub.co.uk/app), login to the app and adjust the room in which i was working on. Altough this wasn't really "time consuming", i wish there was a quicker way to do it. Well, there is now! Thanks to this extension, all you have to do (after you set it up the first time) is to click on the icon that lives in the Chrome extension panel and adjust the room you want to. Is that simple! from wherever you are, you can easily adjust your room with ease.

### Options
You only have 2 options to play with:

 - How long you want to override the rooms for (from **1h** to **23h**)
 - The theme of the extension (**Day** or **Night**)

### Under the hood
This extension uses the [public api](https://my.geniushub.co.uk/tokens) provided by genius to extablish a communication between the extension and your system. What happens exactly when you open the extension?

 - When you open the extension, a request to your system is made. This responds with the current zone list as well as the current temperature on each zone
 - When you change the temperature of a zone, a new request is made to override that zone for the time and temperature you selected
 - When you change both theme or default duration, this settings are stored locally and no request is made.

There are no continuous fetch nor unrequired network requests. *As i said before, simplicity is the keyword here.*

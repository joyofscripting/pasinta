WORK IN PROGRESS

# pasinta
An Applescript that searches for media items in the Photos app from a given date and adds them to an album.

## Installation
Download the file pasinta.applescript to your Mac and open it with the application Script Editor, which is preinstalled on all Macs.

Then export the script as an App. This will give you an executable AppleScript. Put it where you can easily access it (e.g. Script menu or the dock).

![](http://www.schoolscout24.de/img/pasinta/pasinta_script.png)

## Usage
Start the pasinta Applescript and choose a date string in the format YYYYMMDD (the default date string is the current day - 365 days).

![](http://www.schoolscout24.de/img/pasinta/pasinta_date.png)

After the script is done with its work it will display a dialog with the result:

![](http://www.schoolscout24.de/img/pasinta/pasinta_result.png)

pasinta will create an album in Photos app with the chosen date string as the album name. If an album with this name already exists, it will add the found media items to this album.

## Video
This is a short screen recording about how to use pasinta:

[![Screen recording](http://www.schoolscout24.de/img/pasinta/pasinta_movie.png)](http://www.schoolscout24.de/img/pasinta/pasinta.mp4)

## Why pasinta was written
I just wanted an easy way to see photos in the Photos app from exactly 1 year ago. And thankfully the Photos app has support for AppleScript.

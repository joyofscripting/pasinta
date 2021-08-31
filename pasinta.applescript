property mytitle : "pasinta"
property myversion : "0.1"

on run
	try
		my main()
	on error errmsg number errnum
		my dsperrmsg(errmsg, errnum)
	end try
end run

on main()
	-- asking the user to choose a date string, default is today - 365 days
	set curdate to ((current date) - (365 * days))
	set curdatestr to my getdatestring(curdate)
	set chosendatestr to my askfordate(curdatestr)
	if chosendatestr is missing value then
		return
	end if
	
	-- searching all media items in Photos for those who have a corresponding date
	tell application "Photos"
		set allmediaitems to every media item
		set foundmediaitems to {}
		
		repeat with mediaitem in allmediaitems
			set mediadate to date of mediaitem
			set mediadatestr to my getdatestring(mediadate)
			if mediadatestr is equal to chosendatestr then
				set foundmediaitems to foundmediaitems & {mediaitem}
			end if
		end repeat
		
		-- only creating the album if the search was successful
		set countmediaitems to length of foundmediaitems
		if countmediaitems is greater than 0 then
			set thealbum to my getcreatealbum(chosendatestr)
			add foundmediaitems to thealbum
		end if
	end tell
	
	-- displaying some information about the result of the search
	if countmediaitems is greater than 0 then
		set msg to ("Found " & countmediaitems as Unicode text) & " relevant media items in the Photos app and added them to the album named " & chosendatestr & "."
	else
		set msg to "Could not find any relevant media items in the Photos app for chosen date string " & chosendatestr & "."
	end if
	
	tell me
		activate
		display dialog msg buttons {"OK"} default button 1 with title mytitle
	end tell
end main

-- asks the user to provide a date string and needs a default date string
-- will return missing value if the user cancels the process
on askfordate(defdatestr)
	try
		tell me
			activate
			display dialog "Please choose a date string to collect photos from this date:" & return & "(format: YYYYMMDD)" default answer defdatestr buttons {"Cancel", "Enter"} default button 2 with title mytitle
			set dlgresult to result
		end tell
		if button returned of dlgresult is "Cancel" then
			return missing value
		else
			set usrinput to text returned of dlgresult
			-- no input, empty string
			if usrinput is "" then
				my askfordate(defdatestr)
			else if length of usrinput is not 8 then
				set errmsg to "This date string has more or less than 8 numbers: " & usrinput
				my dsperrmsg(errmsg, "--")
				my askfordate(defdatestr)
			else
				set nonnumbers to checkfornumbersonly(usrinput)
				if length of nonnumbers is greater than 0 then
					set errmsg to "This date string contains not only numbers: " & usrinput
					my dsperrmsg(errmsg, "--")
					my askfordate(defdatestr)
				else
					return usrinput
				end if
			end if
		end if
	on error errmsg number errnum
		return missing value
	end try
end askfordate

-- creates the album with the given name in Photos app
-- if an album with the given name already exists, it will not create
-- a duplicate, bur return the existing one
on getcreatealbum(albumname)
	tell application "Photos"
		set foundalbums to every album whose name is albumname
	end tell
	if length of foundalbums is greater than 0 then
		set relalbum to item 1 of foundalbums
	else if length of foundalbums is equal to 0 then
		tell application "Photos"
			set relalbum to make album named albumname
		end tell
	end if
	return relalbum
end getcreatealbum

-- transforms a date object into a date string with the format YYYYMMDD
on getdatestring(dateobj)
	set yearnum to year of dateobj as number
	set monthnum to month of dateobj as number
	set daynum to day of dateobj as number
	
	if monthnum < 10 then
		set monthstr to "0" & monthnum as Unicode text
	else
		set monthstr to monthnum as Unicode text
	end if
	
	if daynum < 10 then
		set daystr to "0" & daynum as Unicode text
	else
		set daystr to daynum as Unicode text
	end if
	
	set datestring to yearnum & monthstr & daystr as Unicode text
	return datestring
end getdatestring

-- checks if the given input string contains numbers only
on checkfornumbersonly(input)
	set allnumbers to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
	set chars to every character of input
	set nonnumbers to {}
	repeat with char in chars
		if char is not in allnumbers then
			set nonnumbers to nonnumbers & char
		end if
	end repeat
	
	return nonnumbers
end checkfornumbersonly

-- displays an error message
on dsperrmsg(errmsg, errnum)
	tell me
		activate
		display dialog "Sorry, an error coccured:" & return & return & errmsg & " (" & errnum & ")" buttons {"Never mind"} default button 1 with icon stop with title mytitle
	end tell
end dsperrmsg
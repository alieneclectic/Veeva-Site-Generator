#!/bin/bash

# Pass the folders you need created as arguments after the script name
# Example: ./veevaGenerator.sh page1 page2 page3 page4
# Be sure to start the name with a letter (not a number)
# The script will generate the folders, files and a new compass project populated with the file names

echo  "Generating Veeva Site. Press <CTRL> + C to stop";

compass create

mkdir -p ./ctl_files
mkdir -p ./_globals/css
mkdir -p ./_globals/js
mkdir -p ./_globals/images
mkdir -p ./_globals/pdf
mkdir -p ./_globals/partials

# config
config="http_path = \"/\"\n"
config+="css_dir = \"_globals/css/\"\n"
config+="sass_dir = \"sass\"\n"
config+="images_dir = \"_globals/images\"\n"
config+="javascripts_dir = \"_globals/js\"\n"
config+="output_style = :compressed\n"
config+="line_comments = false"

echo -e $config > ./config.rb

# argument loop
for var in "$@"
do

	# default html
	html="<!DOCTYPE html>\n"
	html+="<html>\n"
	html+="\t<title>$var</title>\n"
	html+="\t<head>\n"
	html+="\t\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" />\n"
	html+="\t\t<meta name=\"format-detection\" content=\"telephone=no\">\n"
	html+="\t\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n"
	html+="\t\t<link rel=\"stylesheet\" href=\"_globals/css/screen.css\" type=\"text/css\" charset=\"utf-8\"/>\n"
	html+="\t</head>\n"
	html+="\t<body>\n"
	html+="\t\t<div class=\"container\">\n"
	html+="\t\t\t<div id=\"$var\">\n"
	html+="\t\t\t\t<!-- PAGE SPECIFIC CONTENT HERE -->\n"
	html+="\t\t\t</div>\n"
	html+="\t\t</div>\n"
	html+="\t</body>\n"
	html+="</html>"
	
	# ctl files
	ctl="USER=cloader@veeva.partner6.mccann\n"
	ctl+="PASSWORD=mccann1234\n"
	ctl+="FILENAME=$var.zip\n"
	ctl+="Name=$var\n"
	ctl+="Description_vod__c=$var"
	
	# css
	css="#$var {\n"
	css+="\n"
	css+="}"
	
	mkdir -p ./$var
	echo -e $html > ./$var/$var.html
	echo -e $css > ./sass/_$var.scss
	echo -e "@import \"$var\";" >> ./sass/screen.scss
	echo -e $ctl > ./ctl_files/$var.ctl
	
	echo "$var created"
	
done

# remove unused default styles
rm -rf ./stylesheets
rm -f ./sass/ie.scss
rm -f ./sass/print.scss

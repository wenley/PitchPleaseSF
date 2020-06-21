# Tool to export Musescore .mscz file into pdf and practice mp3 tracks
# Created by Mike Khor, rev. 12/03/2019

# Changing directories in shell
cd "$(dirname "$0")"

# Setting up musescore short handle
mscore="/Applications/MuseScore*3.app/Contents/MacOS/mscore"

# Grabbing base name; assumes only one mscz file in folder
msczname=$(ls *.mscz)

# Unzip mscz into mscx, a kind of xml file
unzip -o "$msczname" *mscx
mscxname=$(ls *.mscx)

# Convert mscx name to get rid of spaces
newname=.$(ls *.mscx | sed 's/ /-/g')
mv "$mscxname" "$newname"
mscxname=$newname
scorename=${msczname%.mscz}

# Search for all part names; search for <longName></longName>
partnames="$(sed -ne 's@.*<longName>\([^]]*\)<\/longName>@\1@gp' "${mscxname}" | sed 's/ /-/')"

# Reset and expand volume and pan keys
# Both are missing
perl -0777 -pne 's/<program value="0"\/>\n          <synti>Fluid<\/synti>/<program value="0"\/>\n          <controller ctrl="7" value="99"\/>\n          <controller ctrl="10" value="63"\/>\n          <synti>Fluid<\/synti>/g' "${mscxname}" > tmpfile ; mv tmpfile "${mscxname}"
# Only panning is missing
perl -0777 -pne 's/<program value="0"\/>\n          <controller ctrl="7" value=".*"\/>\n          <synti>Fluid<\/synti>/<program value="0"\/>\n          <controller ctrl="7" value="99"\/>\n          <controller ctrl="10" value="63"\/>\n          <synti>Fluid<\/synti>/g' "${mscxname}" > tmpfile ; mv tmpfile "${mscxname}"
# Only volume is missing
perl -0777 -pne 's/<program value="0"\/>\n          <controller ctrl="10" value=".*"\/>\n          <synti>Fluid<\/synti>/<program value="0"\/>\n          <controller ctrl="7" value="99"\/>\n          <controller ctrl="10" value="63"\/>\n          <synti>Fluid<\/synti>/g' "${mscxname}" > tmpfile ; mv tmpfile "${mscxname}"
# Both are present
perl -0777 -pne 's/<program value="0"\/>\n          <controller ctrl="7" value=".*"\/>\n          <controller ctrl="10" value=".*"\/>\n          <synti>Fluid<\/synti>/<program value="0"\/>\n          <controller ctrl="7" value="99"\/>\n          <controller ctrl="10" value="63"\/>\n          <synti>Fluid<\/synti>/g' "${mscxname}" > tmpfile ; mv tmpfile "${mscxname}"

# Creating export files
# 0 - pdf all parts
$mscore -o '0-'${scorename}'.pdf' "${mscxname}"

# 1 - all parts
$mscore -o '1-ALL-'${scorename}'.mp3' "${mscxname}"

# 2 - individual parts; looped
x=1

# For each part x in part list
for PARTNAMEX in $partnames
do
  y=1
  # For each part y in part list
  for PARTNAMEY in $partnames
  do
    # If y is not equal to x
    if [ $x != $y ]
    then
      # Set soft volume in y-th <controller ctrl="7" value="*"/>
      sed '/<Staff id="'$y'">/,/<\/Channel>/ s/<controller ctrl="7" value=".*"/<controller ctrl="7" value="40"/' "${mscxname}" > .tmpfile ; mv .tmpfile "${mscxname}"

      # Set pan to left side
      sed '/<Staff id="'$y'">/,/<\/Channel>/ s/<controller ctrl="10" value=".*"/<controller ctrl="10" value="20"/' "${mscxname}" > .tmpfile ; mv .tmpfile "${mscxname}"

    # Else
    elif [ $x = $y ]
    then
      # Set loud volume in y-th <controller ctrl="7" value="*"/>
      sed '/<Staff id="'$y'">/,/<\/Channel>/ s/<controller ctrl="7" value=".*"/<controller ctrl="7" value="105"/' "${mscxname}" > .tmpfile ; mv .tmpfile "${mscxname}"

      # Set pan to right side
      sed '/<Staff id="'$y'">/,/<\/Channel>/ s/<controller ctrl="10" value=".*"/<controller ctrl="10" value="120"/' "${mscxname}" > .tmpfile ; mv .tmpfile "${mscxname}"
    fi
    ((y++))
  done
  # Export mp3 with name
  ((x++))
  $mscore -o $x'-'$PARTNAMEX'-'${scorename}'.mp3' "${mscxname}"
  ((count++))
done

rm "${mscxname}"

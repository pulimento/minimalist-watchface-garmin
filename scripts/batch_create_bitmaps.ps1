# define the parameters
#$font = "NotoSansMono_Medium"

$generate_primary = $true

if ($generate_primary) {
	#$font = "NotoSansMono-Bold.ttf"
	$font = "NotoSansMono-Regular.ttf"
	$size = 110
	$color = "#AAAAAA"
	$strings = "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
} else {
	#$font = "NotoSansMono-Medium.ttf"
	$font = "NotoSansMono_Condensed-Regular.ttf"
	$size = 40
	$color = "white"
	$strings = "LUN", "MAR", "MIÉ", "JUE", "VIE", "SÁB", "DOM", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
}

Write-Host "Generating images, with font $font, ${size}pt, $color color" 

# loop through the strings
foreach ($s in $strings) {
    # call the Python script with the parameters
    & python create_image.py $s $font -s $size -c $color
}

$scriptpath = $MyInvocation.MyCommand.Path
$storageDir = Split-Path $scriptpath

$webclient = New-Object System.Net.WebClient

$error.clear()
	
$webclient.DownloadString("http://www.google.com") | Out-Null

if($error) { 
cls
Write-Warning "Something went wrong with the download."
Write-Warning "Copying current local files."
exit
} 
 
$downloadlinks = @(
                        "http://www.bleepingcomputer.com/download/combofix/dl/12/",
                        "http://www.bleepingcomputer.com/download/adwcleaner/dl/125/",
                        "http://www.bleepingcomputer.com/download/rkill/dl/10/",
                        "http://www.bleepingcomputer.com/download/minitoolbox/dl/65/",
						"http://www.bleepingcomputer.com/download/junkware-removal-tool/dl/293/",
						"http://www.bleepingcomputer.com/download/hijackthis/dl/89/"
                )
                                       
$downloadparse = @(
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/ComboFix.exe',
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/AdwCleaner.exe',
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/rkill.exe',
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/MiniToolBox.exe',
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/JRT.exe',
						'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/HijackThis.exe'
						)
 
$downloadname = @(
                        "ComboFix",
                        "ADWCleaner",
                        "rkill",
                        "MiniToolBox",
						"JRT",
						"HijackThis"
                )
 
$dlinksarraylength = $downloadlinks.length
$dlinksarraylength--
 
$i = 0
 
 
while ($i -le $dlinksarraylength)
		{
                $dlink = $downloadlinks[$i]
                $dname = $downloadname[$i]
                $dparse = $downloadparse[$i]
               
                $htmlfile = "$storageDir\Download.html"
                $webclient.DownloadFile($dlink,$htmlfile)
               
                #$purl= $(.\sed.exe -ne $dparse $storageDir\Download.html)
				#Used to use a windows sed.exe file to do this, but now it's limited to select-string
				#This will save on dependencies and headaches.
				
				$purl = select-string -Path $storageDir\Download.html -Pattern $dparse | % { $_.Matches} | % { $_.Value} | Select -Skip 1
				
                Write-host "Downloading $dname"
                Write-host "-------------------"
               
                $dfilename = "$storageDir\files\$dname.exe"
                $webclient.DownloadFile($purl,$dfilename)
                Remove-Item "$storageDir\Download.html"
               
                $i++
        }

Write-host "Downloading EmsisoftEmergencyKit"
Write-host "-------------------"

$emsifilename = "$storageDir\files\EmsisoftEmergencyKit.exe"
$webclient.DownloadFile('http://dl.emsisoft.com/EmsisoftEmergencyKit.exe', $emsifilename)

Write-host "Downloading Malwarebytes"
Write-host "-------------------"

$mbamfilename = "$storageDir\files\mbam-setup.exe"
$webclient.DownloadFile('https://downloads.malwarebytes.org/file/mbam_current/', $mbamfilename)

Write-host "Downloading Malwarebytes Defintions"
Write-host "-------------------"

$mbamdefilename = "$storageDir\files\mbam-rules.exe"
$webclient.DownloadFile('http://data.mbamupdates.com/tools/mbam-rules.exe', $mbamdefilename)


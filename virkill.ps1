$scriptpath = $MyInvocation.MyCommand.Path
$storageDir = Split-Path $scriptpath

$webclient = New-Object System.Net.WebClient
 
$downloadlinks = @(
                        "http://www.bleepingcomputer.com/download/combofix/dl/12/",
                        "http://www.bleepingcomputer.com/download/adwcleaner/dl/125/",
                        "http://www.bleepingcomputer.com/download/rkill/dl/10/",
                        "http://www.bleepingcomputer.com/download/minitoolbox/dl/65/"
						"http://www.bleepingcomputer.com/download/junkware-removal-tool/dl/293/"
						"http://www.bleepingcomputer.com/download/hijackthis/dl/89/"
						"http://www.bleepingcomputer.com/download/emsisoft-emergency-kit/dl/102/"
                )
                                       
$downloadparse = @(
                        'http://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/ComboFix.exe',
                        'http://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/AdwCleaner.exe',
                        'http://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/rkill.exe',
                        'http://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/MiniToolBox.exe'
                        'http://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/JRT.exe'
						'http://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/HijackThis.exe'
						'http://dl.emsisoft.com/EmsisoftEmergencyKit.exe'
						)
 
$downloadname = @(
                        "ComboFix",
                        "ADWCleaner",
                        "rkill",
                        "MiniToolBox"
						"JRT"
						"HijackThis"
						"EmisoftEmergencyKit"
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
		
$mbamweb = New-Object System.Net.WebClient

Write-host "Downloading Malwarebytes"
Write-host "-------------------"

$mbamfilename = "$storageDir\files\mbam-setup.exe"
$webclient.DownloadFile('https://downloads.malwarebytes.org/file/mbam_current/', $mbamfilename)

Write-host "Downloading Malwarebytes Defintions"
Write-host "-------------------"

$mbamdefilename = "$storageDir\files\mbam-rules.exe"
$webclient.DownloadFile('http://data.mbamupdates.com/tools/mbam-rules.exe', $mbamdefilename)


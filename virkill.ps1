[CmdletBinding()]
param(
	[bool]$force	
	)

$host.ui.RawUI.WindowTitle = "VirKill"

$scriptpath = $MyInvocation.MyCommand.Path
$storageDir = Split-Path $scriptpath

$filesExist = Test-Path $storageDir\files
if (!$filesExist)
{
    New-Item -type directory $storageDir\files -force | Out-Null
}

function sMenu
{
    
    Write-Host "VirKill Menu"
    Write-Host "1. Run"
    Write-Host '2. Update (Force)'
    Write-Host "3. Copy"
    Write-Host "0. Exit"
}

function mainRun
{
$webclient = New-Object System.Net.WebClient

$error.clear()
	
$webclient.DownloadString("http://www.google.com") | Out-Null

if($error) { 
cls
Write-Warning "Something went wrong with the download."
Write-Warning "Copying current local files."
}
}

function runDownload
{
 
$dloader = New-Object System.Net.WebClient

$downloadCSV = Import-Csv .\downloadlinks.csv
 
ForEach ($bleepDload in ( $downloadCSV | Where-Object -Property Type -EQ "Bleeping" ))
				{

                $dname = $bleepDload.Name
                $dlink = $bleepDload.DownloadLink
                $dparse = $bleepDload.DownloadParse
				$host.ui.RawUI.WindowTitle = "VirKill (Downloading $dname)"

				Write-host
                Write-host "Downloading $dname"
                Write-host "-------------------"
               
			   $dexist = Test-Path $storageDir\files\$dname.exe
               if ($force -ne "False")
               {
			   if ($dexist -eq "True")
				{
					$dhours = New-Timespan -Start (dir $storageDir\files\$dname.exe).LastWriteTime | Select -ExpandProperty Hours
					if ($dhours -le 6)
					{
					Write-host "Recently updated. ($dhours hour(s) ago)"
					Write-host "Skipping."
					Write-host
					continue
					}
				}
                }
				$htmlfile = "$storageDir\Download.html"
                $dloader.DownloadFile($dlink,$htmlfile)

                Write-Debug $htmlfile
				
				$purl = select-string -Path $storageDir\Download.html -Pattern $dparse | % { $_.Matches} | % { $_.Value} | Select -Skip 1
			
				
                $dfilename = "$storageDir\files\$dname.exe"
                $dloader.DownloadFile($purl,$dfilename)
                Remove-Item "$storageDir\Download.html"
				
        }

ForEach ($custDload in ( $downloadCSV | Where-Object -Property Type -EQ "Custom" ))
		{
                $dlink = $custDload.DownloadLink
                $dname = $custDload.Name
                $dexe = $custDload.EXEName
				
				$host.ui.RawUI.WindowTitle = "VirKill (Downloading $dname)"
				
				Write-host
                Write-host "Downloading $dname"
                Write-host "-------------------"
               
			   $dexist = Test-Path $storageDir\files\$dexe.exe
               if ($force -ne "False")
               {
			   if ($dexist -eq "True")
				{
					$dhours = New-Timespan -Start (dir $storageDir\files\$dexe.exe).LastWriteTime | Select -ExpandProperty Hours
					if ($dhours -le 24)
					{
					Write-host "Recently updated. ($dhours hour(s) ago)"
					Write-host "Skipping."
					Write-host
					continue
					}
				}
				}
                $dfilename = "$storageDir\files\$dexe.exe"
                $dloader.DownloadFile($dlink,$dfilename)
        }
}

do
{
    sMenu
    $input = Read-Host Enter menu option
    switch ($input)
    {
        '1'{
            cls
            mainRun
            runDownload
            New-Item -type directory C:\Users\$env:UserName\Desktop\VirusTools\ | Out-Null
            Copy-Item $storageDir\files\* C:\Users\$env:UserName\Desktop\VirusTools\
            Invoke-Item C:\Users\$env:UserName\Desktop\VirusTools\
            cls

            }
        '2'{
            cls
            $force = $true
            mainRun
            runDownload
            cls
            }
        '3'{
            cls
            New-Item -type directory C:\Users\$env:UserName\Desktop\VirusTools\ | Out-Null
            Copy-Item $storageDir\files\* C:\Users\$env:UserName\Desktop\VirusTools\
            Invoke-Item C:\Users\$env:UserName\Desktop\VirusTools\
            cls
            }            
        '0'{
            return
            }
    }
}
until ($input -eq '0')    

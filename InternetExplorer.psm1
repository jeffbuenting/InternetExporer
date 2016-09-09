﻿#------------------------------------------------------------------------------
# Module InernetExplorer
#
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Function Get-IEWebPageImages
#
# Downloads all image files from the specified URL
#------------------------------------------------------------------------------

 Function Get-IEWebPageImage {

 	<#
		.SYNOPSIS
			Downloads all image files from the WebPage Object

		.DESCRIPTION
			Analyzes the web page object for images and returns them.

		.PARAMETER WebPage 
            Web Page object returned from Open-IEWebPage.
		
		.Example
			Get-IEWebPageImage -WebPage $IE

        .Example 
            Open-IEWebPage -Url "http://www.powershell.org" | Get-IEWebPageImage

		.Link
			http://powershell.com/cs/blogs/tobias/archive/2010/03/17/downloading-images-from-webpages.aspx
    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$True,ValueFromPipeline=$True )]
        [PSCustomObject[]]$WebPage
    )

    Process {
        foreach ( $WP in $WebPage ) {
  
            Write-Verbose "Getting Images from $($WP.Url)..."

            $WP.HTML.Images | Write-Output

        }
    }

}

#------------------------------------------------------------------------------

Function Save-IEWebImage {

<#
    .Description
        Copies an image from a web page to the destination folder.  
    
    .Parameter WebImage
        Image obtained from a webpage.  Use Get-IEWebImage to retrieve web images from a page.
        
    .Parameter Destiniation
        Path name where the image will be copied.
        
    .Example
         Get-IEWebPageImage -url $Url | Save-IEWebImage -Destination 'd:\temp\test'

         Copies all images retrieved from $Url web page to d:\temp\test. 
#>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$True,ValueFromPipeline=$True )]
        [String[]]$Source,
        
        [String]$Destination,

        [ValidateSet('ForeGround','High','Normal','Low',IgnoreCase=$True)]
        [String]$Priority = 'Normal',

        [Switch]$BackGround,

        [Switch]$Wait
    )

    Begin {
        Import-Module BitsTransfer

	    if (-not (Test-Path $Destination)) { md $Destination }
    }

    Process {
        Foreach ( $S in $Source ) {
            Write-Verbose "Saving $S"
            
            If ( $Background ) {
                    $BitsJob = Start-BitsTransfer -Source $S -Destination "$Destination\$($S.Split('/')[-1])" -DisplayName "$Destination\$($S.Split('/')[-1])" -Priority $Priority -Asynchronous
                }
                else {
                    $BitsJob = Start-BitsTransfer -Source $S -Destination "$Destination\$($S.Split('/')[-1])" -DisplayName "$Destination\$($S.Split('/')[-1])" -Priority $Priority
            }
            if ( $Wait ) {
                Write-Verbose "Waiting for Bits Transfer to complete"
                While ( ( $BitsJob.JobState -ne 'Error' ) -or ( $BitsJob -ne 'Transferred' ) ) {
                    Sleep -Seconds 15
                }
            }
   
        }

    }

}

#------------------------------------------------------------------------------
# Function Wait-IEWebPageLoad
#
# Helper function that waits until the web page has loaded.  
# http://www.pvle.be/2009/06/web-ui-automationFunction Wait-IEWebPageLoad
#test-using-powershell/
#------------------------------------------------------------------------------

Function Wait-IEWebPageLoad {

	[CmdLetBinding()]
	Param ( $ie,
			[int]$delayTime = 100)

	Write-Verbose "Waiting for Web Page to Load"
  	$loaded = $false
 
  	while ($loaded -eq $false) {
    	[System.Threading.Thread]::Sleep($delayTime) 
 
    	#If the browser is not busy, the page is loaded
    	if (-not $ie.Busy){
      		$loaded = $true
    	}
  	}
	Return $ie
}

#------------------------------------------------------------------------------
# Function Open-IEWebPage 
#
# Opens Web Page.  Returns object holding web page
# http://www.pvle.be/2009/06/web-ui-automationFunction Wait-IEWebPageLoad
#test-using-powershell/
#------------------------------------------------------------------------------

Function Open-IEWebPage {

	[CmdLetBinding()]
	Param ( 
        [Parameter( Mandatory=$True,ValueFromPipeline=$True )]
        [string[]]$url, 
	
    	[int]$delayTime = 400,

        [Switch]$Visible
    )

    Begin {
        If ($PSBoundParameters['Debug']) {
            $DebugPreference = 'Continue'
        }
    }

    Process {
        Foreach ( $U in $Url ) {
            Write-Verbose "Navigating to $U"

            if ( $Visible ) {
                $ie = New-Object -com "InternetExplorer.Application"
	            $ie.visible = $true 
  	            $ie.Navigate($u)
              #  Write-Verbose "hello"
      #$IE
              #  $Title = $IE.LocationName
              #  Write-Verbose "Title = $Title"
               # While ($ie.Busy) { Start-Sleep -Milliseconds $DelayTime }
            }

           


            if ( ( -Not $IE ) ) {
                Write-Verbose "Error - Bad webpage"
                Throw "Open-IEWebPage : Webpage address is incorrect or the web page is offline"
                break
            }


     #       Write-Verbose "Title = $Title"
    #
    #        $win = New-Object -comObject Shell.Application
    #        $try = 0
    #        $ie2 = $null
    #        do {  
    ##            Start-Sleep -milliseconds 500  
    #            $ie2 = @($win.windows() | ? { $_.locationName -like '*PowerShell*' })[0]  
    #            $try ++  
    #            if ($try -gt 20) {    
    #                Throw "Web Page cannot be opened."  
    #            }
    #        } while ($ie2 -eq $null)

           write-verbose "$U"
           Write-Verbose "Should be something on the line above"
            
            Try {
                $WebUrl = Invoke-WebRequest -uri $u -ErrorAction Stop -Verbose:$false
            }
            catch {
                #Write-Error $Error[0].Exception
                Throw "Open-IEWebPage : Problem opening web page"
            }

                    $Properties = @{
                        'HTML' = (  Invoke-WebRequest -uri $u -ErrorAction Stop -Verbose:$false);
                        'Url' = $U;
                        'IEApp' = $IE2;
                        'IE' = $IE;
                        'Title' = $Title;
                    }
                
                

            $WebPage = New-Object -TypeName psobject -Property $Properties

            Write-Debug "WebPage Ojbect"
            Write-Debug ($WebPage.IE | Out-String)

            # ----- Don't know why but a Null value is returning.  This will remove any null values and only return the items ith values
      
            foreach ( $I in $WebPage ) {
       
                if ( $I -ne $Null ) { 
                        Write-Output $I 
                    }
                    Else {
                        Write-Verbose "Null"
                }
  
            }
        }
  }
	  
}

#------------------------------------------------------------------------------

Function Close-IEWebPage {

    [CmdLetBinding()]
	Param ( 
        [Parameter( Mandatory=$True,ValueFromPipeline=$True )]
        [PSCustomObject[]]$WebPage
    )

    Begin {
        # ----- Set Debug to continue without prompting: http://learn-powershell.net/2014/06/01/prevent-write-debug-from-bugging-you/
        If ($PSBoundParameters['Debug']) {
            $DebugPreference = 'Continue'
        }
    }

    Process {
        Foreach ( $WP in $WebPage ) {
            Write-Verbose "Closing $($WP.Url)"
            Write-Debug ($WP.IE | Out-String )

            $WP.IE.Quit()
        }
    }
}

#------------------------------------------------------------------------------

function Resolve-ShortcutFile {
     
<#
    .Description
        Retrieves the web page address (URL) from a shortcut.
    .Parameter FileName
        Full Path to the shortcut
    .Parameter FilterString
        String to filter.  If the wep page address is 'Like' this string then it will be returned.  Otherwise it will be skipped.
    .LINK
        http://blogs.msdn.com/b/powershell/archive/2008/12/24/resolve-shortcutfile.aspx
#>          
           
    [CmdLetBinding()]
    param(
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position = 0)]
        [Alias("FullName")]
        [string]$fileName,

        [String]$LikeString = ''
    )
    
    process {
        
        Write-Verbose "Processing $_"
        if ( $LikeString -ne '' ) {
                Write-Verbose "LikeString = $LikeString - something"
                if ($fileName -like "*.url") {
                    Write-Verbose "Filtering Urls"
                    $ShortCut = Get-Content $fileName | Where-Object { $_ -like "url=*" -and $_ -like "*$LikeString*" } 
                    if ( $ShortCut -ne $Null ) {
                        Write-Output ( New-Object -Type PSObject -Property @{'FileName'= $FileName; 'Url' = $ShortCut.Substring($ShortCut.IndexOf("=") + 1 ) } )
                    }
                }
            }
            Else {
                Write-Verbose "LikeString = Empty"
                if ($fileName -like "*.url") {
                    Write-Verbose "Returning all Urls"
                    $ShortCut = Get-Content $fileName | Where-Object { $_ -like "url=*" } 
                    Write-Output ( New-Object -Type PSObject -Property @{'FileName'= $FileName; 'Url' = $ShortCut.Substring($ShortCut.IndexOf("=") + 1 ) } )

                }  
       }          
    
    }

}  

#------------------------------------------------------------------------------

Function Get-IEWebPageLink {

 	<#
		.SYNOPSIS
			Downloads all Links from the WebPage Object

		.DESCRIPTION
			Analyzes the web page object for Links and returns them.

		.PARAMETER WebPage 
            Web Page object returned from Open-IEWebPage.
		
		.Example
			Get-IEWebPageImage -WebPage $IE

        .Example 
            Open-IEWebPage -Url "http://www.powershell.org" | Get-IEWebPageLink

    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$True,ValueFromPipeline=$True )]
        [PSCustomObject[]]$WebPage
    )
    
    Begin {
        Write-Verbose "Get-IEWebPageLink"
        if ( $VerbosePreference -eq [System.Management.Automation.ActionPreference]::Continue ) {
            Write-Verbose "WebPage Object:"
            $WebPage
        }
    }

    Process {
        foreach ( $WP in $WebPage ) {
            #$WP
            Write-Verbose "Getting Links from $($WP.Url)..."



            $WP.HTML.Links | Write-Output

        }
    }

}

#------------------------------------------------------------------------------

Function Get-IEWebVideo {

 	<#
		.SYNOPSIS
			Downloads all Videos from the WebPage Object

		.DESCRIPTION
			Analyzes the web page object for Videoss and returns them.

		.PARAMETER WebPage 
            Web Page object returned from Open-IEWebPage.
		
		.Example
			Get-IEWebPageImage -WebPage $IE

        .Example 
            Open-IEWebPage -Url "http://www.powershell.org" | Get-IEWebVideo

    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$True,ValueFromPipeline=$True )]
        [PSCustomObject[]]$WebPage
    )

    Begin {
        Write-Verbose ""
        # ----- Set Debug to continue without prompting: http://learn-powershell.net/2014/06/01/prevent-write-debug-from-bugging-you/
        If ($PSBoundParameters['Debug']) {
            $DebugPreference = 'Continue'
        }
        Write-Debug "WebPage passed in"
        Write-Debug ($WebPage | Out-String)

        $WebVideo = @()
    }


 
    Process {
        foreach ( $WP in $WebPage ) {
            Write-Verbose ""
            Write-Verbose "Getting Videos from $($WP.LocationUrl)..."
            Write-Debug ( $WP | Out-String )
            #$WP | FL *   # ------ Don't know why but this won't work without this line.
            
            $BreakError = $False
            $WebVideo = $Null

            Write-Verbose 'Get HTML5 Video elements'
            
            write-Verbose 'Parsing Web page code for video sources'
           
            #Write-Debug "HTML"
            #Write-Debug ($WP.HTML.allelements | Out-String )
            #$WP.HTML.allelements
            Write-Verbose "Checking Tags"
            Write-Verbose "               Source"
            
            # ----- PinkVelvetVault, PornoXO
            $WebVideo = $WP.HTML.allelements | where tagname -eq source | where { ($_.src -like '*.m4v') -or ( $_.src -like '*.webm' ) -or ( $_.src -like '*.mp4') } | Select-object -ExpandProperty src
            $WebVideo += $wp.html.links | where href -like "*.wmv" | Select-Object -ExpandProperty href
            
            $Videos = @()
            Write-Verbose "Checking if WebVideo contains HTTP"
            foreach ( $V in $WebVideo ) {
                if ( $WebVideo -notcontains 'http://' ) {
                    Write-verbose "No Http add base url"
                    $BaseUrl = $WP.Url -replace 'index.html',''
                    $Videos += ,"$BaseUrl$V"
                }
            }
            $WebVideo = $Videos

                


            switch -Regex ( $WP.HTML.RawContent ) {

                # ----- NNConnect.com
                """file"": ""(\S+)""" {
                    Write-Verbose """file"": ""(\S+)"""
                    Write-Verbose "Found: $($Matches[0])"

                    $baseurl = ($WP.Url | Select-string -Pattern '[^/]*(/(/[^/]*/?)?)?' | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).trimend( "/")
                    $WebVideo = "$Baseurl$($Matches[1])"
                   
                }

                 # ----- MyDailyTube.com, YourdailyGirls.com, SweetKiss
                    "clip: {\s+url: '(\S+\.mp4)'" {
                        Write-Verbose "clip: {\s+url: '(\S+\.mp4)'" 
                        Write-Verbose "Found: $($Matches[0])"
                    
                        $WebVideo = $Matches[1]
                        break
                    }

                'file:"(\S+mp4[^"]*)' {
                    Write-Verbose 'file:"(\S+mp4[^"]*)'
                    Write-Verbose "Found: $($Matches[0])"
                    
                    $WebVideo = $Matches[1]
                }

                # ----- TubeCup, VikiPorn
                "video_url: '(\S+.mp4)" {
                    Write-Verbose "video_url: '(\S+.mp4)"
                    Write-Verbose "Found: $($Matches[0])"
                    
                    $WebVideo = $Matches[1]
                }

                # ----- DaPorn
                'Url: "(\S+.mp4)' {
                    Write-Verbose 'Url: "(\S+.mp4)'
                    Write-Verbose "Found: $($Matches[0])"
                    
                    $WebVideo = $Matches[1]
                }

                # ----- NikkiSimsVideos.com, xhamster
                "file=(\S+\.mp4)" {       
                    Write-Verbose "file=(\S+\.mp4)"
                    Write-Verbose "Found: $($Matches[0])"
                    Write-Verbose "$($Matches[1])"

                    $SRC = $Matches[1]

                    if ( $SRC -Match 'http://' ) {
                            $SRC = ($SRC.substring(1)).TrimEnd('"')
                            write-verbose "Source is full URL: $SRC"
                                
                            $WebVideo = $SRC
                        }
                        else {
                            Write-Verbose 'Building Url'
                            #$baseUrl = (($Txt | select-string -Pattern 'src=\S+flvplayer.swf' | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).substring(5)).Replace( 'flvplayer.swf','')
                            $baseUrl = ($WP.HTML.AllElements | where TagName -eq 'Embed' | Select-Object -ExpandProperty SRC).Replace( 'flvplayer.swf','')
                            Write-Verbose "BaseUrl = $BaseUrl"

                            $WebVideo = "$BaseUrl$($Matches[1])"
                    }
                    break
                }

                '\[flv\]([\S]+)\[\/flv\]' {
                    Write-Verbose "video_url: \[flv\]([\S]+)\[\/flv\]"
                    Write-Verbose "Found: $($Matches[0])"
                    
                    $WebVideo = $Matches[1]

                }

                "url: \S+\('([a-z,A-Z,:,\/,\.,\d]+.mp4)" {
                    Write-Verbose "url: \S+\('([a-z,A-Z,:,\/,\.,\d]+.mp4)"
                    Write-Verbose "Found: $($Matches[0])"
                    
                    $WebVideo = $Matches[1]
                }

                # ----- KeezMovies
                #'src="(http://[a-z,A-Z,\d,.,\/,_,\?,=,&]+)' {
                 #   Write-Verbose 'src="(http://[a-z,A-Z,\d,.,\/,_,\?,=,&]+)'
                  #  Write-Verbose "Found: $($Matches[0])"
                   # 
                    #$WebVideo = $Matches[1]
                #}

            }
        
            Write-Verbose "Video Url:"
            Write-Verbose ($WebVideo | Out-String)
            Write-Output $WebVideo        
        }
    }

}

#------------------------------------------------------------------------------


Function Get-HTMLBaseUrl {

<#
    .Synopsis
        Returns the Base path of an HTML Url address.

    .Description
        Using this you can build a complete path from a relitive path found in image and href items.

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [String[]]$Url
    )

    Process {
        Foreach ( $U in $Url ) {
            Write-Verbose "Finding Base path for $U"

            # ----- Removing query (Everything after the ?)
            if ( $U.Contains('?') ) {
                Write-Verbose "Removing query (?)"
                $Root = ($U.split( '?' ))[0]

                # ----- Removing page name
                Write-Verbose "Removing page file name from $Root"
                Write-Output $Root.substring( 0,$Root.lastindexof( '/' ) )
                break
            }

            # ----- remove page from URL
            if (( $U.Contains('.html')) -or ($U.Contains('.php')) ) {
                
                Write-Verbose "Removing HTML/PHP page file name from $U"
                write-verbose "new Base: $($U.substring( 0,$U.lastindexof( '/' ) ))"
                Write-Output ($U.substring( 0,$U.lastindexof( '/' )+1 ))
                break
            }

            Write-Verbose "Returning input unprocessed as it is already the root"
            Write-Output $U
        }
    }
}

#------------------------------------------------------------------------------

Function Get-HTMLRootUrl {

<#
    .Synopsis
        returns HTML address root url
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [String[]]$Url
    )

    Process {
        Foreach ( $U in $Url ) {
            Write-Verbose "Finding root path for $U"
            
            if ( $U -match '(?''base''http:\/\/.*?\/)' ) { Write-Output ( $Matches['base'].Trimend('/') ) }
        }
    }

}

#------------------------------------------------------------------------------

Function Get-IEResponse {
    
<#
    .Link
        http://stackoverflow.com/questions/1473358/how-to-obtain-numeric-http-status-codes-in-powershell
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [String]$Url
    )

    Process {
        Write-Verbose "Getting website Respose for: $Url"
        $Request = [System.Net.HttpWebRequest]::Create($Url)
        try {
                $Response = $Request.GetResponse() 
            }
            Catch {
                Write-Verbose "Error getting Response"
                $Response = $Error[0].Exception.InnerException.Response
        }

       # if ( -Not $Resonse ) { $Response = $Error[0].Exception.InnerException.Response }

        Write-Verbose "Status = $([Int]$Response.StatusCode)"
        
        $Response | Add-Member -MemberType NoteProperty -Name 'Status' -Value ([Int]$Response.StatusCode)
        Write-Output $Response
    }
}

#------------------------------------------------------------------------------

Function Test-IEWebPath {

<#
    .Synopsis
        Checks if a web path exists

    .Description
        Used to check if a web path exists.  For example.  Is the address to a JPG valid.

    .Parameter Url
        Address to the Web Path to test

    .Example
        test if the following JPG exists at the specified webpage

        Test-IEWebPath -Url http://www.contoso.com/award.jpg

    .Link
        http://stackoverflow.com/questions/20259251/powershell-script-to-check-the-status-of-a-url
#>
    
    [CmdletBinding()]
    Param (
        [String]$Url
    )


    # First we create the request.
    $HTTP_Request = [System.Net.WebRequest]::Create($Url)

    # We then get a response from the site.
    $HTTP_Response = $HTTP_Request.GetResponse()

    # We then get the HTTP code as an integer.
    $HTTP_Status = [int]$HTTP_Response.StatusCode

    If ($HTTP_Status -eq 200) { 
        Write-Output $True 
    }
    Else {
        Write-Output $Fals
    }

    # Finally, we clean up the http request by closing it.
    $HTTP_Response.Close()
}

Function Test-IEWebPath {

<#
    .Synopsis
        Checks if a web path exists

    .Description
        Used to check if a web path exists.  For example.  Is the address to a JPG valid.

    .Parameter Url
        Address to the Web Path to test

    .Example
        test if the following JPG exists at the specified webpage

        Test-IEWebPath -Url http://www.contoso.com/award.jpg

    .Link
        http://stackoverflow.com/questions/20259251/powershell-script-to-check-the-status-of-a-url
#>
    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [String]$Url
    )

    Write-Verbose "Test-IEWebPath : Checking for existence of $Url"

    # First we create the request.
    $HTTP_Request = [System.Net.WebRequest]::Create($Url)
    Try {
            # We then get a response from the site.
            $HTTP_Response = $HTTP_Request.GetResponse()

            # We then get the HTTP code as an integer.
            $HTTP_Status = [int]$HTTP_Response.StatusCode

            If ($HTTP_Status -eq 200) { 
                Write-Output $True 
            }
            Else {
                Write-Output $False
            }

            # Finally, we clean up the http request by closing it.
            $HTTP_Response.Close()
        }
        Catch {
            Write-Output $False
    }
}






#[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

Set-Alias -Value Open-IEWebPage -Name Get-IEWebPage
Set-Alias -Value Save-IEWebImage -Name Save-IEWebVideo

#Export-ModuleMember -Function Open-IEWebPage,Close-IEWebPage,Get-IEWebPageImage,Save-IEWebImage,Resolve-ShortcutFile,Get-IEWebPageLink,Get-IEWebVideo,Get-HTMLRootPath -Alias Save-IEWebVideo,Get-IEWebPage
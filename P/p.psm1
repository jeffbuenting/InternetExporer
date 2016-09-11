﻿Function Get-PImages {

    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$True)]
        [PSCustomObject[]]$WebPage,

        [int]$RecurseLevel = 0,

        [int]$MaxRecurseLevel = 1
    )

   

    process {
        Write-Verbose "Recurse Level : $RecurseLevel"
        $RecurseLevel ++
        
        ForEach ( $WP in $WebPage ) {

            Write-Verbose "Get-PImages : -------------------------------------------------------------------------------------"
            Write-Verbose "Get-PImages : -------------------------------------------------------------------------------------"

            Write-Verbose "Get-PImages : Getting Images from $($WP.URL)..."

            $Pics = @()

            #-------------------------------------------------------------------------------
            # ----- Images on the page. Excluding frontpage,littlepics
            Write-verbose "Get-PImages : ---------------------------- Checking for images on page."

            $WP.HTML.images | where src -match '\d*\.jpg' | foreach {
                $SRC = $_.SRC

                Write-Verbose "Get-PImages : Examining: $($_.src)"


                # ----- Match was 
                Write-Verbose "Get-PImage : ----- $SRC -- Does the image start with HTTP?" 
                if ( ( $_.SRC -Match 'http:\/\/.*\/\d*\.jpg' ) -or ($_.SRC -Match 'http:\/\/.*\d*\.jpg' ) `
                    -and ( -Not ($_.src).contains( '468x60') ) `
                    -and ( -Not ($_.src).contains( 'anna') ) `
                    -and ( -Not ($_.src).contains( 'atk') ) `
                    -and ( -Not ($_.src).contains( 'backtohome') ) `
                    -and ( -Not ($_.src).contains( 'backtohome') ) `
                    -and ( -Not ($_.src).contains( 'banner') ) `
                    -and ( -Not ($_.src).contains( 'bella') ) `
                    -and ( -Not ($_.src).contains( 'big.jpg') ) `
                    -and ( -Not ($_.src).contains( 'box_title_main_menu') ) `
                    -and ( -Not ($_.src).contains( '/cm/') ) `
                    -and ( -Not ($_.src).contains( 'friends') ) `
                    -and ( -Not ($_.src).contains( 'front') ) `
                    -and ( -Not ($_.src).contains( 'frontpage') ) `
                    -and ( -Not ($_.src).contains( 'gallery-') ) `
                    -and ( -Not ($_.src).contains( 'girls/') ) `
                    -and ( -Not ($_.src).contains( 'header') ) `
                    -and ( -Not ($_.src).contains( 'header') ) `
                    -and ( -Not ($_.src).contains( 'hor_') ) `
                    -and ( -Not ($_.src).contains( 'imgs/') ) `
                    -and ( -Not ($_.src).contains( '/img') ) `
                    -and ( -Not ($_.src).contains( 'kris') ) `
                    -and ( -Not ($_.src).contains( 'littlepics') ) `
                    -and ( -Not ($_.src).contains( 'lily.jpg') ) `
                    -and ( -Not ($_.src).contains( 'logo') ) `
                    -and ( -Not ($_.src).contains( 'newupdates') ) `
                    -and ( -Not ($_.src).contains( 'nov') ) `
                    -and ( -Not ($_.src).contains( 'oct') ) `
                    -and ( -Not ($_.src).contains( 'paysite.jpg') ) `
                    -and ( -Not ($_.src).contains( 'sascha') ) `
                    -and ( -Not ($_.src).contains( 'search') ) `
                    -and ( -Not ($_.src).contains( 'separator') ) `
                    -and ( -Not ($_.src).contains( 'small') ) `
                    -and ( -Not ($_.src).contains( 'stmac.jpg') ) `
                    -and ( -Not ($_.src).contains( 't.jpg') ) `
                    -and ( -Not ($_.src).contains( 'Template') ) `
                    -and ( -Not ($_.src).contains( 'tgp') ) `
                    -and ( -Not ($_.src).contains( 'th') ) `
                    -and ( -Not ($_.src).contains( 'thumb' ) ) `
                    -and ( -Not ($_.src).contains( 'tk_' ) ) `
                    -and ( -Not ($_.src).contains( 'tn.jpg') ) `
                    -and ( -Not ($_.src).contains( 'tn2') ) `
                    -and ( -Not ($_.src).contains( 'tn_') ) `
                    -and ( (($_.src) -notmatch 'tn\d*\.jpg')) `
                    -and ( -Not ($_.src).contains( 'upload') ) ) { 
                        Write-Verbose "Get-PImages : returning full JPG Url $($_.SRC)"
                      
                        $Pics += $_.SRC
                        Write-Verbose "Get-PImages : -----Found: $($_.SRC)"
                        Write-Output $_.SRC 
                }

                Write-Verbose "Get-PImage : ----- $($_.src) -- No HTTP"                  
                If ( ($_.SRC -notmatch 'http:\/\/.*' ) `
                    -and ( -Not ($_.src).contains( '..') ) `
                    -and ( -Not ($_.src).contains( '468x60') ) `
                    -and ( -Not ($_.src).contains( 'anna') ) `
                    -and ( -Not ($_.src).contains( 'atk') ) `
                    -and ( -Not ($_.src).contains( 'backtohome') ) `
                    -and ( -Not ($_.src).contains( 'banner') ) `
                    -and ( -Not ($_.src).contains( 'bella') ) `
                    -and ( -Not ($_.src).contains( 'big.jpg') ) `
                    -and ( -Not ($_.src).contains( 'box_title_main_menu') ) `
                    -and ( -Not ($_.src).contains( '/cm/') ) `
                    -and ( -Not ($_.src).contains( 'friends') ) `
                    -and ( -Not ($_.src).contains( 'front') ) `
                    -and ( -Not ($_.src).contains( 'gallery-') ) `
                    -and ( -Not ($_.src).contains( 'girls/') ) `
                    -and ( -Not ($_.src).contains( 'header') ) `
                    -and ( -Not ($_.src).contains( 'hor_') ) `
                    -and ( -Not ($_.src).contains( 'imgs/') ) `
                    -and ( -Not ($_.src).contains( '/img') ) `
                    -and ( -Not ($_.src).contains( 'kris') ) `
                    -and ( -Not ($_.src).contains( 'lily.jpg') ) `
                    -and ( -Not ($_.src).contains( 'logo') ) `
                    -and ( -Not ($_.src).contains( 'newupdates') ) `
                    -and ( -Not ($_.src).contains( 'nov') ) `
                    -and ( -Not ($_.src).contains( 'oct') ) `
                    -and ( -Not ($_.src).contains( 'paysite.jpg') ) `
                    -and ( -Not ($_.src).contains( 'sascha') ) `
                    -and ( -Not ($_.src).contains( 'search') ) `
                    -and ( -Not ($_.src).contains( 'separator') ) `
                    -and ( -Not ($_.src).contains( 'small') ) `
                    -and ( -Not ($_.src).contains( 'stmac.jpg') ) `
                    -and ( -Not ($_.src).contains( 't.jpg') ) `
                    -and ( -Not ($_.src).contains( 'Template') ) `
                    -and ( -Not ($_.src).contains( 'tgp') ) `
                    -and ( -Not ($_.src).contains( 'th') ) `
                    -and ( -Not ($_.src).contains( 'tk_' ) ) `
                    -and ( -Not ($_.src).contains( 'tn.jpg') ) `
                    -and ( -Not ($_.src).contains( 'tn2') ) `
                    -and ( (($_.src) -notmatch 'tn\d*\.jpg')) `
                    -and ( -Not ($_.src).contains( 'thumb' ) ) `
                    -and ( -Not ($_.src).contains( 'upload') ) ) {
                            
                            $PotentialIMG = $_.SRC
                            
                            # ----- Check if the link contains /tn_.  if so remove and process image
                            if ( $PotentialIMG.Contains( "\/tn_") ) {
                                $PotentialIMG = $PotentialIMG.Replace( '/tn_','/')
                            }

                            Write-Verbose "Get-PImages : JPG Url is relitive path.  Need base/root."
                            $Root = Get-HTMLBaseUrl -Url $WP.Url -Verbose
                            if ( -Not $Root ) { $Root = Get-HTMLRootUrl -Url $WP.Url -Verbose }

                            # ----- Check to see if valid URL.  Should not contain: //
                            if ( ("$Root$_" | select-string -Pattern '\/\/' -allmatches).matches.count -gt 1 )  {
                                Write-Verbose "Get-PImages : Illegal character, Getting Root"
                                $Root = Get-HTMLRootUrl -Url $WP.Url -Verbose
                            }

                           

                            # ----- Checking if image is a valid path
                           # $URL = "$Root$($_.SRC)"
                          #  Write-Verbose "+++++++++++$Root$($_.SRC)"
                            if ( Test-IEWebPath -Url "$Root$PotentialIMG" -ErrorAction SilentlyContinue ) {
                                    $Pics += "$Root$PotentialIMG"

                                    Write-Verbose "-----Found: $Root$PotentialIMG"
                                    Write-Output "$Root$PotentialIMG"
                                }
                                else {
                                    Write-Verbose "Get-PImage : Root/SRC is not valid.  Checking Root/JPG"
                                    $JPG = $PotentialIMG | Select-String -Pattern '([^\/]+.jpg)' | foreach { $_.Matches[0].value }
                                    if ( Test-IEWebPath -Url $Root$JPG ) {
                                        Write-Verbose "-----Found: $Root$JPG"
                                        Write-Output $Root$JPG
                                    }
                            }
                        }
                        Else {
                            Write-Verbose "Get-PImages :  Image not found $($_.SRC)"
                            $_.SRC
                            write-Verbose "fluffernuter"

                        
                            
                }

            }

           
            if ( $Pics ) { Break }
            
            #-------------------------------------------------------------------------------
            # ----- Check for full URL to Images ( jpgs )
            Write-Verbose "Get-PImages : ---------------------------- Checking for JPG with full URL"
            $WP.HTML.links | where { ( $_.href -Match 'http:\/\/.*\.jpg' ) -and ( -Not $_.href.contains('?') ) } | Select-Object -ExpandProperty HREF | Where { Test-IEWebPath -Url $_ } | Foreach {
                Write-Verbose "----- Found : $_"
                Write-Output $_
            }
            #if ( $FullJPGUrl ) {
            #    Write-Verbose "----- Found: $FullJPGUrl"
            #    Write-Output $FullJPGUrl
            #}

         #   if ( $WP.HTML.links | where { ( $_.href -Match 'http:\/\/.*\.jpg' ) -and ( -Not $_.href.contains('?') ) } ) { break }
            
            #-------------------------------------------------------------------------------
            # ----- Check to see if there are links to images ( jpgs ) - Relative Links (not full URL)
            Write-Verbose "Get-PImages : ---------------------------- Checking for Links to JPGs"
            $Root = Get-HTMLBaseUrl -Url $WP.Url -Verbose
            if ( -Not $Root ) { $Root = Get-HTMLRootUrl -Url $WP.Url -Verbose }

            Write-Verbose "Website Root Path = $Root"
            $WP.HTML.links | where href -like *.jpg | Select-Object -ExpandProperty href | Foreach {
                Write-Verbose "Image Found: $Root$_"
                
                # ----- Check to see if valid URL.  Should not contain: //
                if ( (("$Root$_" | select-string -Pattern '\/\/' -allmatches).matches.count -gt 1) -or ( ("$Root$_").contains('#') ) ) {
                    Write-Verbose "Illegal character, Getting Root"
                    $Root = Get-HTMLRootUrl -Url $WP.Url -Verbose
                }
                if (( $_[0] -ne '/' ) -and ( $Root[$Root.length - 1] -ne '/' ) ) { $HREF = "/$_" } else { $HREF = $_ }

                # ----- Check if the image exists
                Write-Verbose "Get-PImage : Checking if image path exists and correct"
                if ( Test-IEWebPath -Url $Root$HREF -ErrorAction SilentlyContinue ) {
                        Write-Verbose "-----Found: $Root$HREF"
                        Write-Output $Root$HREF
                    }
                    else {
                        Write-Verbose "Get-PImage : Root/HREF is not valid.  Checking Root/JPG"
                        $JPG = $HREF | Select-String -Pattern '([^\/]+.jpg)' | foreach { $_.Matches[0].value }
                        if ( Test-IEWebPath -Url $Root$JPG -ErrorAction SilentlyContinue ) {
                            Write-Verbose "-----Found: $Root$JPG"
                            Write-Output $Root$JPG
                        }
                }
            }
            
            if ( $WP.HTML.links | where href -like *.jpg ) { break }

            #-------------------------------------------------------------------------------
            # ----- Check for links to image page ( ddd.htm )
            Write-Verbose "Get-PImages : ---------------------------- Checking for html links"

            # ----- Do not process if we have already followed one link ( stop if the URL is PHP )
            if ( $WP.Url -notmatch "\d+\.php" ) {
                $WP.HTML.Links | where { ($_.href -like "*.html") -or ($_.HREF -match "\d+\.php") } | Select-Object -ExpandProperty href | Write-Verbose
                $WP.HTML.Links | where { ($_.href -like "*.html") -or ($_.HREF -match "\d+\.php") } | Select-Object -ExpandProperty href | foreach {
                    Write-Verbose "`n"
                    Write-Verbose "Can I follow : $_"
                
                    $HREF = $_
                    $Root = $Null

                    if ( -not ( $_ -match 'http:\/\/' ) ) { 
                            $Root = Get-HTMLBaseUrl -Url $WP.Url -Verbose
                            if ( -Not $Root ) { $Root = Get-HTMLRootUrl -Url $WP.Url -Verbose }
                            Write-Verbose "Get-PImages : ---------------------------- Following Link: $Root$HREF"
                            Try {
                                    # ----- Check if we are recursing and how deep we have gone.
                                    if ( $RecurseLevel -le $MaxRecurseLevel ) { 
                                        Write-Output ( Get-IEWebPage -Url $Root$HREF -Visible | Get-PImages -Verbose )
                                    }
                                }
                                Catch {
                                    # ----- If error following web link.  Try getting web root and following that
                                    $Root = Get-HTMLRootUrl -Url $WP.Url -Verbose 
                                    Write-Verbose "Error -- Will Try : $Root$HREF "
                                    # ----- Check if we are recursing and how deep we have gone.
                                    if ( $RecurseLevel -le $MaxRecurseLevel ) { 
                                        Write-Output ( Get-IEWebPage -Url $Root$HREF -Visible | Get-PImages -Verbose )
                                    }

                            }
                        }
                        else {

                            Write-Verbose "Get-PImages : -------------------- Following Link: $HREF"


                            # Write-Output (Get-IEWebPage -url $HREF -Visible | Get-Pics -Verbose)
                            # ----- Check if we are recursing and how deep we have gone.
                            if ( $RecurseLevel -le $MaxRecurseLevel ) { 
                                Write-Output (Get-IEWebPage -url $HREF -Visible | Get-PImages -Verbose)
                            }
                    }
                }
            }
  
            if ( $WP.HTML.Links | where href -like  *.html ) { Break }

            #-------------------------------------------------------------------------------
            # ----- Checking for links where the src is a jpg thumbnail ( link does not end in html )
            Write-Verbose "checking for links where the src is a tn.jpg"
            $WP.HTML.Links | where { ( $_.innerHTML -match 'src=.*tn\.jpg' ) } | Foreach {
                if ( $_.HREF -match 'http:\/\/' ) {
                    $HREF = $_.href
                    Write-Verbose "Following Link: $HREF"
                    #Get-IEWebPage -Url $HREF -visible

                    # ----- Check if we are recursing and how deep we have gone.
                    if ( $RecurseLevel -le $MaxRecurseLevel ) { 
                        $Pics = Get-IEWebPage -url $HREF -Visible | Get-PImages -Verbose
                    }

                    Write-Output $Pics
                }
                
            }

            if ( $Pics ) { Break }
           
        }
    }



}

#--------------------------------------------------------------------------------------

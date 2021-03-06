﻿#------------------------------------------------------------------------------
# Function Get-webpage 
#
# Opens Web Page.  Returns object holding web page
# http://www.pvle.be/2009/06/web-ui-automationFunction Wait-IEWebPageLoad
#test-using-powershell/
#------------------------------------------------------------------------------

Function Get-WebPage {

	[CmdLetBinding()]
	Param ( 
        [Parameter( Mandatory=$True,ValueFromPipeline=$True )]
        [string[]]$url, 
	
    	[int]$delayTime = 400,

        [ValidateSet ('Chrome','Edge','IE')]
        [String]$Browser,

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


            Switch ( $Browser ) {
                'IE' {
                    Write-Verbose "Opening in IE"
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
                        Throw "Get-webpage : Webpage address is incorrect or the web page is offline"
                        break
                    }
                }
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
                # ----- Force connection to be TLS 1.2
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $WebUrl = Invoke-WebRequest -uri $u -ErrorAction Stop -Verbose:$false
            }
            catch {
                #Write-Error $Error[0].Exception
                Throw "Get-webpage : Problem opening web page"
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

Set-Alias -Name Open-IEWebPage -Value Get-WebPage
#Set-Alias -Name Get-IEWebPage -Value Get-WebPage

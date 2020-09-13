function Get-PokemonLocation
    {
    <#
    .Synopsis
    Grabs info on locations from Pokemon
    .Description
    Displays info on locations from the Pokemon games
    .Parameter Location
    The location you want to find
    .Example
    Get-PokemonLocations -Location "canalave city"
    Grabs info on canalave city
    .Link
    https://github.com/nerenther/PSPokeAPI
    #>
        
        [CmdletBinding()] 
            Param (
                [Parameter(Mandatory=$True,Position=0,HelpMessage='Location to get info on')][string]$Location
                  )
    Begin {
        #Changing case
        Write-Verbose "Changing $($Location) to lowercase"
        $Location = $Location.ToLower()
        Write-Verbose "Type is now $($Location)"

        #Changing spaces to dashes
        Write-Verbose "Changing spaces to dashes"
        $Location = $Location.Replace(" ","-")

        #Setting URI
        Write-Verbose "Defining URI"
        $BaseURI = "https://pokeapi.co/api/v2/location/"
        
    } #EndBegin

    Process {
        Try {
        #Searching for location
        Write-Verbose "Trying to pull info on $($Location)"
        $LocationFromAPI = Invoke-RestMethod -Method Get -Uri "$($BaseURI)$($Location)"
        }

        catch [System.Net.WebException] {
            Write-Verbose "Catched a WebException"
            
            if ($error[0].Exception -like "*404*") {
                Write-Verbose "404 discovered"
                throw "Failed to find location, check spelling"               
            } #EndIFFirst404

            else {
                Write-Verbose "WebException is not a 404"
                Throw "There was a webException"
            }

        } #EndCatchFirstWebException

        catch {
            Write-Verbose "Cathed an unhandled exception"
            throw "Something went wrong"
        } #EndFirstCatchall

 
    }

    End {
        #Displaying a subset of info
        Write-Verbose "Displaying info"
        Write-Progress -Activity "Displaying info" -PercentComplete 90

        Write-Verbose "Showing output"
        $LocationFromAPI | Select-Object @{label="Name";expression={($_.names | Where-Object {$_.language.name -like "*en*"}).name}},@{label="Region";expression={$_.region.name}},@{label="Generation";expression={(($_.game_indices.generation.name).substring(11)).ToUpper()}}

        Write-Progress -Activity "Displaying info" -Completed
    } #EndEnd     

}
function Get-RandomLocation
    {
    <#
    .Synopsis
    Gets a random location from the PokeAPI
    .Description
    Pulls a random location from the PokeAPI
    .Example
    Get-RandomLocation
    Grabs info on a random location
    .Link
    https://github.com/nerenther/PSPokeAPI
    #>
        [CmdletBinding()] 
            Param (
            )

    Begin {
        #Getting all location
        Write-Verbose "Trying to get all location"
        Write-Progress -Activity "Grabbing all location"
        try {
            Write-Verbose "Getting all location"
            $alllocation = Invoke-RestMethod -Method Get -Uri "https://pokeapi.co/api/v2/location?limit=40000"
            Write-Verbose "Got all location"
        } #EndTry

        catch {
            throw "Failed to get all location, unable to continue"
        } #EndCatchall

        #Picking a random location
        Write-Verbose "Picking a random location"
        Write-Progress -Activity "Picking a random location" -PercentComplete 10
        $Randomlocation = $alllocation.Results | Get-Random
        Write-Verbose "I picked $($Randomlocation.Name) for you"

        #Setting Uri        
        Write-Progress -Activity "Putting together Uri" -PercentComplete 15
        Write-Verbose "Setting Uri"
        $Uri = $Randomlocation.url
        Write-Verbose "Final Uri is: $($Uri)"

    } #EndBegin

    Process {
        try {
            #Trying to invoke rest method
            Write-Verbose "Invoking REST"
            Write-Progress -Activity "Invoking REST method" -PercentComplete 30
            $location = Invoke-RestMethod -Method Get -Uri $Uri
            Write-Verbose "Got a REST response"
        } #EndTry

        catch [System.Net.WebException] {
            Write-Verbose "Catched a WebException"
            if ($error[0].Exception -like "*404*") {
                Write-Verbose "404 discovered"
            } #EndIf404

            Write-Verbose "It was not a 404"
            Throw "There was a webException"
        }#EndCatchWebException

        catch {
            Write-Verbose "Catched an unhandled exception"
            throw "Something went wrong"
        } #EndCatchall
    } #EndProcess

    End {
        #Displaying info
        Write-Verbose "Displaying info"
        Write-Progress -Activity "Outputting info" -PercentComplete 95
        $location | Select-Object Name,ID
        
        Write-Verbose "Cleaning up"
        Clear-Variable Randomlocation,Uri,location,alllocation -ErrorAction SilentlyContinue
        Write-Verbose "Done"

        Write-Progress -Activity "Displaying info" -Completed

    } #EndEnd

}
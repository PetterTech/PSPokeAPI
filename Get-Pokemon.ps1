function Get-Pokemon
    {
    <#
    .Synopsis
    Gets a pokemon from the PokeAPI
    .Description
    Based on input, pulls info on given Pokemon and displays a subset
    .Parameter Name
    Name of the pokemon
    .Example
    Get-Pokemon charmander
    Grabs info on charmander
    .Link
    https://github.com/nerenther/PSPokeAPI
    #>
        [CmdletBinding()] 
            Param (
                [Parameter(Mandatory=$True,Position=0,HelpMessage='Name of pokemon')][string]$Name
                  )
    Begin {
        #Setting Uri
        Write-Verbose "Setting Uri to https://pokeapi.co/api/v2/pokemon/ plus $($Name)"
        Write-Progress -Activity "Putting together Uri" -PercentComplete 10
        
        $Uri = "https://pokeapi.co/api/v2/pokemon/" + $Name
        
        Write-Verbose "Final uri is: $($Uri)"
        } #EndBegin

    Process {
        #Trying to invoke rest method, catching errors if they occur
        try {
            Write-Verbose "Invoking REST method"
            Write-Progress -Activity "Invoking REST" -PercentComplete 15
            $Pokemon = Invoke-RestMethod -Method Get -Uri $Uri
            Write-Verbose "Got a REST response"
        } #EndTryToInvoke

        catch [System.Net.WebException] {
            Write-Verbose "Catched a WebException"
            
            if ($error[0].Exception -like "*404*") {
                Write-Verbose "404 discovered"
                throw "Failed to find pokemon, check spelling"
            } #EndIF404

            Write-Verbose "WebException is not a 404"
            Throw "There was a webException"
        } #EndCatchWebException

        catch {
            Write-Verbose "Cathed an unhandled exception"
            throw "Something went wrong"
        } #EndCatchall
    }

    End {
        #Displaying a subset of info
        Write-Verbose "Displaying info"
        Write-Progress -Activity "Displaying info" -PercentComplete 90

        $Pokemon | Select-Object Name,ID,@{label="Type";expression={$_.types.type.name}},@{label="Regular Form";expression={$_.sprites.front_default}},@{label="Shiny Form";expression={$_.sprites.front_shiny}}

        Write-Verbose "Cleaning up"
        Clear-Variable Name,Uri,Pokemon -ErrorAction SilentlyContinue
        Write-Verbose "Done"

        Write-Progress -Activity "Displaying info" -Completed
    } #EndEnd
    
} #EndFunction
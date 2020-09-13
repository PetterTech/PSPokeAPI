function Get-PokemonByType
    {
    <#
    .Synopsis
    Gets all pokemon of given type
    .Description
    Pulls a list of all pokemon of the type given
    .Parameter Type
    The type want to list pokemons of
    .Example
    Get-PokemonByType Fire
    Gets all pokemon that is fire type
    .Link
    https://github.com/nerenther/PSPokeAPI
    #>
        [CmdletBinding()] 
            Param (
                [Parameter(Mandatory=$True,Position=0,HelpMessage='The type of pokemon you want to list')]
                [ValidateSet('Normal','Fighting','Flying','Poison','Rock','Bug','Ghost','Steel','Fire','Ground','Ice','Water','Grass','Electric','Psychic','Dragon','Fairy','Dark')]
                [string]$Type
                  )
    Begin {
        #Changing case
        Write-Verbose "Changing $($type) to lowercase"
        $Type = $Type.ToLower()
        Write-Verbose "Type is now $($Type)"

        #Setting Uri
        Write-Verbose "Setting Uri to https://pokeapi.co/api/v2/pokemon/ plus $($Type)"
        Write-Progress -Activity "Putting together Uri" -PercentComplete 10
        
        $Uri = "https://pokeapi.co/api/v2/type/" + $Type
        
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

        Write-Verbose "Showing list output"
        ($Pokemon.pokemon.pokemon) | Select-Object name | Sort-Object Name

        Write-Progress -Activity "Displaying info" -Completed
    } #EndEnd

}
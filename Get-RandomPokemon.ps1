function Get-RandomPokemon
    {
    <#
    .Synopsis
    Gets a random pokemon from the PokeAPI
    .Description
    Pulls a random pokemon and info on said Pokemon, then displays a subset of its info
    .Example
    Get-Pokemon 
    Grabs info on a random pokemon
    .Link
    https://github.com/nerenther/PSPokeAPI
    #>
        [CmdletBinding()] 
            Param (
            )

    Begin {
        #Getting all pokemons
        Write-Verbose "Trying to get all pokemons"
        Write-Progress -Activity "Grabbing all pokemons"
        try {
            Write-Verbose "Getting all pokemons"
            $allPokemons = Invoke-RestMethod -Method Get -Uri "https://pokeapi.co/api/v2/pokemon?limit=40000"
            Write-Verbose "Got all pokemons"
        } #EndTry

        catch {
            throw "Failed to get all pokemons, unable to continue"
        } #EndCatchall

        #Picking a random pokemon
        Write-Verbose "Picking a random pokemon"
        Write-Progress -Activity "Picking a random pokemon" -PercentComplete 10
        $RandomPokemon = $allPokemons.Results | Get-Random
        Write-Verbose "I picked $($RandomPokemon.Name) for you"

        #Setting Uri        
        Write-Progress -Activity "Putting together Uri" -PercentComplete 15
        Write-Verbose "Setting Uri"
        $Uri = $RandomPokemon.url
        Write-Verbose "Final Uri is: $($Uri)"

    } #EndBegin

    Process {
        try {
            #Trying to invoke rest method
            Write-Verbose "Invoking REST"
            Write-Progress -Activity "Invoking REST method" -PercentComplete 30
            $Pokemon = Invoke-RestMethod -Method Get -Uri $Uri
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
        $Pokemon | Select-Object Name,ID,@{label="Type";expression={$_.types.type.name}},@{label="Regular Form";expression={$_.sprites.front_default}},@{label="Shiny Form";expression={$_.sprites.front_shiny}}
        
        Write-Verbose "Cleaning up"
        Clear-Variable RandomPokemon,Uri,Pokemon,allPokemons -ErrorAction SilentlyContinue
        Write-Verbose "Done"

        Write-Progress -Activity "Displaying info" -Completed

    } #EndEnd

}
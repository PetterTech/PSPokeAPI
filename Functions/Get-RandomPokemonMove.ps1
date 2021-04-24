function Get-RandomPokemonMove
    {
    <#
    .Synopsis
    Select a random pokemon move
    .Description
    Grabs all pokemon moves, selects a random one and displays some info
    .Example
    Get-RandomPokemonMove
    Displays info on a random pokemon move
    .Link
    https://github.com/nerenther/PSPokeAPI
    #>
        [CmdletBinding()] 
            Param (
            )

    Begin {
        #Getting all moves
        Write-Verbose "Trying to get all moves"
        Write-Progress -Activity "Grabbing all moves"
        try {
            Write-Verbose "Getting all moves"
            $allmoves = Invoke-RestMethod -Method Get -Uri "https://pokeapi.co/api/v2/move?limit=4000"
            Write-Verbose "Got all moves"
        } #EndTry

        catch {
            throw "Failed to get all moves, unable to continue"
        } #EndCatchall

        #Picking a random move
        Write-Verbose "Picking a random move"
        Write-Progress -Activity "Picking a random move" -PercentComplete 10
        $RandomMove = $allmoves.Results | Get-Random
        Write-Verbose "I picked $($RandomMove.Name) for you"

        #Setting Uri        
        Write-Progress -Activity "Putting together Uri" -PercentComplete 15
        Write-Verbose "Setting Uri"
        $Uri = $RandomMove.url
        Write-Verbose "Final Uri is: $($Uri)"
        }

    Process {
        try {
            #Trying to invoke rest method
            Write-Verbose "Invoking REST"
            Write-Progress -Activity "Invoking REST method" -PercentComplete 30
            $Move = Invoke-RestMethod -Method Get -Uri $Uri
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
    }

    End {
        #Displaying a subset of info
        Write-Verbose "Displaying info"
        Write-Progress -Activity "Displaying info" -PercentComplete 90

        Write-Verbose "Showing output"
        $Move | Select-Object @{label="Name";expression={($_.names | Where-Object {$_.language.name -like "*en*"}).name}},@{label="Type";expression={$_.type.name}},Accuracy,@{label="Class";expression={$_.damage_class.name}},Power,PP,@{label="Generation";expression={(($_.generation.name).substring(11)).ToUpper()}},@{label="Effect";expression={($_.effect_entries | Where-Object {$_.language.name -like "*en*"}).effect}},@{label="Text";expression={($_.flavor_text_entries | Where-Object {($_.language.name -like "*en*") -and ($_.version_group.name -like "*heartgold-soulsilver*")}).flavor_text}}

        Write-Progress -Activity "Displaying info" -Completed
	
    }

}
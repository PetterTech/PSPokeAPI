function Start-PokemonBattle
    {
    <#
    .Synopsis
    Starts a pokemon battle
    .Description
    Start a battle between random, or chosen pokemon, and simulates a battle on a random location, or a chosen one
    .Parameter Pokemon1
    Name of the first pokemon
    .Parameter Pokemon2
    Name of the second pokemon
    .Parameter Location
    Name of the location where the battle should take place
    .Example
    Start-PokemonBattle
    Simulates a battle between random pokemons on a random location
    .Link
    https://github.com/nerenther/PSPokeAPI
    #>
        [CmdletBinding()] 
            Param (
                [Parameter(Mandatory=$False,Position=0,HelpMessage='Name of first pokemon')][string]$Pokemon1,
                [Parameter(Mandatory=$False,Position=0,HelpMessage='Name of second pokemon')][string]$Pokemon2,
                [Parameter(Mandatory=$False,Position=0,HelpMessage='Name of location')][string]$Location
                  )
    Begin {
        #Checking if input was given, getting randoms if not
        Write-Progress -Activity "Validating inputs, getting randoms if none given" -PercentComplete 1

        Write-Verbose "Checking if Pokemon1 is set"
        if (!($Pokemon1)) {
            Write-Verbose "Pokemon 1 was not set, getting a random one"
            
            try {
                $Pokemon1 = (Get-RandomPokemon).name
            }
            catch {
                throw "Failed get a random pokemon"
            }
            Write-Verbose "Got a random pokemon: $($Pokemon1)"
        }

        if (!($Pokemon2)) {
            Write-Verbose "Pokemon 2 was not set, getting a random one"
            
            try {
                $Pokemon2 = (Get-RandomPokemon).name
            }
            catch {
                throw "Failed get a random pokemon"
            }
            Write-Verbose "Got a random pokemon: $($Pokemon2)"
        }

        if (!($Location)) {
            Write-Verbose "Location was not set, getting a random one"
            
            try {
                $Location = (Get-RandomLocation).name
            }
            catch {
                throw "Failed get a random location"
            }
            Write-Verbose "Got a random location: $($Location)"
        }

        #Getting info on pokemons
        Write-Verbose "Getting info on pokemon1"
        try {
            Write-Verbose "Trying to get info on pokemon1"
            $Pokemon1Info = Get-Pokemon -Name $Pokemon1 -AllInfo
        }
        catch {
            Write-Verbose "Failed to get info on pokemon1"
            throw "Failed to get info on pokemon1"
        }
        Write-Verbose "Got all info on pokemon1"

        Write-Verbose "Getting info on pokemon2"
        try {
            Write-Verbose "Trying to get info on pokemon2"
            $Pokemon2Info = Get-Pokemon -Name $Pokemon2 -AllInfo
        }
        catch {
            Write-Verbose "Failed to get info on pokemon2"
            throw "Failed to get info on pokemon2"
        }
        Write-Verbose "Got all info on pokemon2"

    } #EndBegin

    Process {
        #Picking starting pokemon
        $FirstPokemon = $Pokemon1,$pokemon2 | Get-Random
        if ($FirstPokemon -eq $Pokemon1) {
            $SecondPokemon = $Pokemon2
        }
        else {
            $SecondPokemon = $Pokemon1
        }

        #Getting pokemon moves
        $FirstPokemonMoves = (Get-Pokemon -Name $FirstPokemon -AllInfo).moves.move.name
        $SecondPokemonMoves = (Get-Pokemon -Name $SecondPokemon -AllInfo).moves.move.name

        #Picking winner
        if (($null -eq $FirstPokemonMoves) -and ($null -eq $SecondPokemonMoves)) {
            $Draw = $true
            $Round1MoveFirst = "nothing"
            $Round1MoveSecond = "nothing"
        }

        elseif ($null -eq $FirstPokemonMoves) {
            $Winner = $SecondPokemon
            $Round1MoveFirst = "nothing"
        }

        elseif ($null -eq $SecondPokemonMoves) {
            $Winner = $FirstPokemon
            $Round1MoveSecond = "nothing"
        }

        else {
            $Winner = $Pokemon1,$pokemon2 | Get-Random
        }

        if ($Winner -eq $Pokemon1) {
            $Loser = $Pokemon2
        }
        else {
            $Loser = $Pokemon1
        }
        
        #Starting battle simulation
        if (!($Round1MoveFirst)) {
            $Round1MoveFirst = $FirstPokemonMoves | Get-Random    
        }
        
        if (!($Round1MoveSecond)) {
            $Round1MoveSecond = $SecondPokemonMoves | Get-Random    
        }
        

    } #EndProcess

    End {
        
        #Outputting battle log to host
        if ($Draw) {
            Write-Host "We are gathered here at lovely $($Location) for a battle between $($Pokemon1) and $($Pokemon2)" -ForegroundColor Green
            Start-Sleep -Seconds 1
            Write-Host "What!? Neither pokemon have any moves. It's a draw!" -ForegroundColor Green
            Write-Host "That's all from $($Location)! Have a nice day people" -ForegroundColor Green
        }
        else {
            Write-Host "We are gathered here at lovely $($Location) for a battle between $($Pokemon1) and $($Pokemon2)" -ForegroundColor Green
            Start-Sleep -Seconds 1
            Write-Host "$($Pokemon1) is getting ready" -ForegroundColor Green
            Start-Sleep -Seconds 1
            Write-Host "$($Pokemon2) looks ready already" -ForegroundColor Green
            Start-Sleep -Seconds 1
            Write-Host "$($FirstPokemon) goes first" -ForegroundColor Green
            Start-Sleep -Seconds 1
            Write-Host "He uses $($Round1MoveFirst) on $($SecondPokemon)" -ForegroundColor Green
            Start-Sleep -Seconds 1
            if ($FirstPokemon -eq $Winner) {
                Write-Host "It works like a charm! $($Loser) is not able to fight on" -ForegroundColor Green
                Start-Sleep -Seconds 1
                Write-Host "$($Winner) wins this battle" -ForegroundColor Green
                Start-Sleep -Seconds 1
            }
            else {
                Write-Host "It fails spectaculary!" -ForegroundColor Red
                Start-Sleep -Seconds 1
                Write-Host "$($SecondPokemon) counters with $($Round1MoveSecond)" -ForegroundColor Green
                Start-Sleep -Seconds 1
                Write-Host "It works like a charm! $($Loser) is not able to fight on" -ForegroundColor Green
                Start-Sleep -Seconds 1
            }
            Write-Host "That's all from $($Location)! Have a nice day people" -ForegroundColor Green
        }


        #Test battle
        #Write-Host "$($pokemon1) beat $($pokemon2) at $($Location)"


    } #EndEnd
    
} #EndFunction
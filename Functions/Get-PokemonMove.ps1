function Get-PokemonMove
    {
    <#
    .Synopsis
    Gets info on move
    .Description
    Connects to PokeAPI and grabs info on given move
    .Parameter Move
    The move you want info on
    .Example
    Get-PokemonMove pound
    Grabs info on the pound move
    .Link
    https://github.com/nerenther/PSPokeAPI
    #>
        [CmdletBinding()] 
            Param (
                [Parameter(Mandatory=$True,Position=0,HelpMessage='The move you want info on')][string]$Move
                  )
    Begin {
        #Changing case
        Write-Verbose "Changing $($Move) to lowercase"
        $Move = $Move.ToLower()
        Write-Verbose "Type is now $($Move)"

        #Changing spaces to dashes
        Write-Verbose "Changing spaces to dashes"
        $Move = $Move.Replace(" ","-")

        #Setting URI
        Write-Verbose "Defining URI"
        $BaseURI = "https://pokeapi.co/api/v2/move/"
	
        }

    Process {
        Try {
            #Searching for move
            Write-Verbose "Trying to pull info on $($Move)"
            $MoveFromAPI = Invoke-RestMethod -Method Get -Uri "$($BaseURI)$($Move)"
            }
    
            catch [System.Net.WebException] {
                Write-Verbose "Catched a WebException"
                
                if ($error[0].Exception -like "*404*") {
                    Write-Verbose "404 discovered"
                    throw "Failed to find move, check spelling"               
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
        $MoveFromAPI | Select-Object @{label="Name";expression={($_.names | Where-Object {$_.language.name -like "*en*"}).name}},@{label="Type";expression={$_.type.name}},Accuracy,@{label="Class";expression={$_.damage_class.name}},Power,PP,@{label="Generation";expression={(($_.generation.name).substring(11)).ToUpper()}},@{label="Effect";expression={($_.effect_entries | Where-Object {$_.language.name -like "*en*"}).effect}},@{label="Text";expression={($_.flavor_text_entries | Where-Object {($_.language.name -like "*en*") -and ($_.version_group.name -like "*heartgold-soulsilver*")}).flavor_text}}

        Write-Progress -Activity "Displaying info" -Completed
    } #EndEnd 

}
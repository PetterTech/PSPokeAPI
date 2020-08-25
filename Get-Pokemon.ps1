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
                [Parameter(Mandatory=$True,Position=0,HelpMessage='Lorem Ipsum')][string]$Name
                  )
    Begin {
        $Uri = "https://pokeapi.co/api/v2/pokemon/" + $Name
        }

    Process {
        Invoke-RestMethod -Method Get -Uri $Uri | Select-Object Name,ID,@{label="Type";expression={$_.types.type.name}}
        }

    End {
	
        }
    
        

}
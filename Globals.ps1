#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------


#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}


function Add-ToTreeView
{
	[cmdletbinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[System.Array]$ArrayOfObjects,
		[Parameter(Mandatory = $true)]
		[System.String]$DisplayMember,
		[Parameter(Mandatory = $false)]
		[System.Object]$DisplayFunction,
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.TreeView]$TreeView,
		[Parameter(Mandatory = $true)]
		[System.Collections.Hashtable]$CheckedNodes,
		[Parameter(Mandatory = $false)]
		[System.String]$Filter,
		[Parameter(Mandatory = $false)]
		[System.String]$MemberToFilterOn
	)
	# for each gpo
	$ArrayOfObjects | %{
		if ($DisplayFunction)
		{
			# don't forget the quotes around displaymember so powershell doesn't convert it into an array by default (fn expects string))
			$name = (Invoke-Expression "$DisplayFunction '$($_.$DisplayMember)'")
			
			#Write-Debug ("Invoke: $DisplayFunction $($_.$DisplayMember)")
			#Write-Debug "`t yielded: $name"
			
			$node = New-Object -TypeName System.Windows.Forms.TreeNode -ArgumentList "$name"
		}
		else
		{
			$node = New-Object -TypeName System.Windows.Forms.TreeNode -ArgumentList $_.$DisplayMember
		}
		
		# ref this object in the tag property
		$node.Tag = $_
		
		# if it was previously in the checked items list, check it again (if re-adding the node to the tree...)
		if ($CheckedNodes -and $CheckedNodes[$_.Id])
		{
			$node.Checked = $true
		}
		
		# add it to the tree view
		if ($Filter)
		{
			Write-Debug "Match $($_.$MemberToFilterOn) -like $Filter"
			if ($_.$MemberToFilterOn -like "*$Filter*")
			{
				$TreeView.Nodes.Add($node)
			}
		}
		else
		{
			$TreeView.Nodes.Add($node)
		}
	}
}

function Get-CanonicalName ([string[]]$DistinguishedName)
{
	foreach ($dn in $DistinguishedName)
	{
		$d = $dn.Split(',') ## Split the dn string up into it's constituent parts 
		$arr = (@(($d | Where-Object { $_ -notmatch 'DC=' }) | ForEach-Object { $_.Substring(3) })) ## get parts excluding the parts relevant to the FQDN and trim off the dn syntax 
		[array]::Reverse($arr) ## Flip the order of the array. 
		
		## Create and return the string representation in canonical name format of the supplied DN 
		"{0}/{1}" -f (($d | Where-Object { $_ -match 'dc=' } | ForEach-Object { $_.Replace('DC=', '') }) -join '.'), ($arr -join '/')
	}
}

function Get-CheckedNode
{
<#
	.SYNOPSIS
		This function collects a list of checked nodes in a TreeView

	.DESCRIPTION
		This function collects a list of checked nodes in a TreeView

	.PARAMETER  $NodeCollection
		The collection of nodes to search

	.PARAMETER  $CheckedNodes
		The ArrayList that will contain the all the checked items
	
	.EXAMPLE
		$CheckedNodes = New-Object System.Collections.ArrayList
		Get-CheckedNode $treeview1.Nodes $CheckedNodes
		foreach($node in $CheckedNodes)
		{	
			Write-Host $node.Text
		}
#>
	param (
		[ValidateNotNull()]
		[System.Windows.Forms.TreeNodeCollection]$NodeCollection,
		[ValidateNotNull()]
		[System.Collections.ArrayList]$CheckedNodes
	)
	
	foreach ($Node in $NodeCollection)
	{
		if ($Node.Checked)
		{
			[void]$CheckedNodes.Add($Node)
		}
		Get-CheckedNode $Node.Nodes $CheckedNodes
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory

$script:version = "v0.1"



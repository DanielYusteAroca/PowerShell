# Declaration of parameters
param(
    [Parameter(Mandatory, HelpMessage = 'Path for an input file containing one IP address per line')] [string]$InputFile,
    [Parameter(Mandatory, HelpMessage = 'Path for an output file where reachable addresses will be stored')] [string]$OutputFile
)

# If the output file already exists, then abort execution.
if (Test-Path $OutputFile){
    throw "File $OutputFile already exists"
}

# Read input file.
$fileContent = Get-Content $InputFile

# Initialize output file
Set-Content -Path $OutputFile -Value 'Reachable IP addresses:'

#Initialize counters
$numLines = $fileContent.Length
$processedLines = 0
$validAddresses = 0
$reachableAddresses = 0

# Loop through the input file lines
foreach ($line in $fileContent){
    # Check if the line is  valid IP address
    if ($line -as [IPAddress] -as [Bool]){
        $validAddresses++
        Write-Output "Testing $line"
        if (Test-Connection -TargetName $line -Count 1 -TimeoutSeconds 1 -Quiet){
            $reachableAddresses++
            Add-Content -Path $OutputFile -Value $line
        }
    }
    # If the line is not a valid IP address
    else {
        Write-Error "$line is not a valid IP address"
    }
    $processedLines++
}

Add-Content -Path $OutputFile -Value ''
Add-Content -Path $OutputFile -Value "Lines read: $numlines"
Add-Content -Path $OutputFile -Value "Lines processed: $processedLines"
Add-Content -Path $OutputFile -Value "Valid IP addresses: $validAddresses"
Add-Content -Path $OutputFile -Value "Reachable IP addresses: $reachableAddresses"

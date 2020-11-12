#-----------------------------------------------------------------
# Project: Import Address Data
# Subject: Import Address Data from Address Data File from Swiss Post
# Description: Generate CSV files for database import.
#-----------------------------------------------------------------
# Rev | Date Modified | Developer      | Change Summary
#-----------------------------------------------------------------
# 001 | 12.11.2020    | Martin Valer   | Initial Version
#-----------------------------------------------------------------


#-----------------------------------------------------------------
# Configs

# Source directory
#$inDir = $PSScriptRoot + "\" + "in"
$inDir = "c:\Temp\AddressData\in"

# Target directory
#$outDir = $PSScriptRoot + "\" + "out"
$outDir = "c:\Temp\AddressData\out"

$dbSchema = "dbo"
$dbTable = "Ort"
#-----------------------------------------------------------------

# Include helper functions
. "$PSScriptRoot\Helpers.ps1"

# Script start
$startTime = (Get-Date)

$zipFiles = Get-ChildItem -Path $inDir -Include *.zip -Recurse
foreach ($zipFile in $zipFiles) {
    # Extract zip file
    Expand-Archive -LiteralPath $zipFile -DestinationPath $inDir 
} 

# Cleaning: delete all files in out dir
Get-ChildItem -Path $outDir -Include *.* -Recurse | ForEach-Object { $_.Delete()}

$csvFiles = Get-ChildItem -path $inDir -include *.csv -Recurse
foreach ($csvFile in $csvFiles) {
    # Import csv records, skip lines if record type (column A) is not equal to "01"
    $data = Import-Csv -Path $csvFile -Delimiter ";" -Header A,B,C,D,E,F,G,H,I,J -Encoding "UTF7" | Where-Object A -eq "01"

    Write-Host "Reading " $data.Count "record(s) from file" $csvFile

    $fileNameWithoutExtension = Split-Path $csvFile -LeafBase
    $outputFile = $outDir + "\" + $fileNameWithoutExtension + ".sql"

    foreach($row in $data){

        $recArt = $row.A
        $onrp = $row.B
        $plz = $row.E
        $ort = $row.H
        $kanton = $row.J

        #Write-Host "RecArt:" $recArt " ONRP:" $onrp " PLZ:" $plz " Ort:" $ort " Kanton:" $kanton

        # Prepare SQL statement
        $fields = "ONRP, PLZ, Ort, Kanton"
        $values = "$onrp, $plz," + (ToVarchar $ort) + "," + (ToVarchar $kanton)

        # Add record to output file
        Add-Content $outputFile -Value "INSERT INTO [$dbSchema].[$dbTable] ($fields) VALUES ($values);" -Encoding "UTF8"
    }
}

$endTime = (Get-Date)
$duration = New-TimeSpan -Start $startTime -End $endTime

Write-Host "Script finished. Duration:" ("{0:hh\:mm\:ss\.fffff}" -f $duration) -ForegroundColor Green
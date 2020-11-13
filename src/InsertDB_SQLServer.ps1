#-----------------------------------------------------------------
# Project: Import Address Data
# Subject: Import Address Data from Address Data File from Swiss Post
# Description: Insert Data directly into SQL Server Database
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

# Target database
$dbSchema = "dbo"
$dbTable = "Ort"
$connString = "Server=localhost;Database=Gritec.AddressData;Trusted_Connection=True;"  
#-----------------------------------------------------------------

# Include helper functions
. "$PSScriptRoot\Helpers.ps1"

# Script start
$startTime = (Get-Date)

$zipFiles = Get-ChildItem -Path $inDir -Include *.zip -Recurse
foreach ($zipFile in $zipFiles) {
    # Extract zip file
    Expand-Archive -LiteralPath $zipFile -DestinationPath $inDir -Force
} 

# Prepare DB connection
$conn = New-Object System.Data.SqlClient.SqlConnection                     
$conn.ConnectionString = $connString                                      
$conn.Open()

$csvFiles = Get-ChildItem -path $inDir -include *.csv -Recurse
foreach ($csvFile in $csvFiles) {
    # Import csv records, skip lines if record type (column A) is not equal to "01"
    $data = Import-Csv -Path $csvFile -Delimiter ";" -Header A,B,C,D,E,F,G,H,I,J -Encoding "UTF7" | Where-Object A -eq "01"

    Write-Host "Reading " $data.Count "record(s) from file" $csvFile

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

        # Create INSERT statement
        $sql = "INSERT INTO [$dbSchema].[$dbTable] ($fields) VALUES ($values);"

        $cmd = New-Object System.Data.SqlClient.SqlCommand                         
        $cmd.CommandText = $sql                                                    
        $cmd.Connection = $conn                                                    
        $cmd.ExecuteNonQuery()   
    }
}

$conn.close()

$endTime = (Get-Date)
$duration = New-TimeSpan -Start $startTime -End $endTime

Write-Host "Script finished. Duration:" ("{0:hh\:mm\:ss\.fffff}" -f $duration) -ForegroundColor Green
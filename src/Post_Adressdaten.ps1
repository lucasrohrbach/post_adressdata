# Adressen aus data1.csv importieren
$source_dir = "$PSScriptRoot"
$source_file = $source_dir + "\" + "Post_Adressdaten20201103.csv"

$schema = "dbo"
$sqlTableName = "Ort"
$exportFile = $source_dir + "\" + $sqlTableName + ".sql"
#$data = Import-Csv -Path $source_file -Header A,B,C,D,E,F,G | Where-Object A -eq '01'
if (Test-Path $exportFile) { Remove-Item $exportFile }

$data = Import-Csv -delimiter ";" -Path $source_file -Header A,B,C,D,E,F,G,H,I,J -Encoding "UTF7"
foreach($row in $data){
$ONRP = $row.B
$PLZ = $row.C
$Ort = $row.H 
$Kanton = $row.J

  
  
   $fields = "ONRP, PLZ, Ort, Kanton"
   $values = "$ONRP, $PLZ, '$Ort', '$Kanton'"
 

Add-Content $exportFile -Value @("INSERT INTO [$schema].[$sqlTableName] ($fields) VALUES ($values);") -Encoding "Unicode" 
} 
function ToVarchar($value){
    if (($value -ne $null))
    {
        if ($value.Contains("'"))
        {
            # Hochkomma für INSERT-Statement verdoppeln
            $value = $value.Replace("'","''")
        }
        return "'" + $value + "'"
    } else {
        return "NULL"
    }
}

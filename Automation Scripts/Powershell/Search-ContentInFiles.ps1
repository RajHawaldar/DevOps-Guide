# To search content in files recursively 

Get-ChildItem -Filter *.config -Recurse | Select-String "KeyWord_to_search"

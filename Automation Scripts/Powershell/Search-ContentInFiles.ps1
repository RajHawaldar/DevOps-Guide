# To search content in files recursively 

Get-ChildItem -Filetr *.config -Recurse | Select-String "KeyWord_to_search"

//%attributes = {}
var $XLSX : cs:C1710.XLSX

$XLSX:=cs:C1710.XLSX.new()

$file:=File:C1566("/RESOURCES/template.xlsx")

$status:=$XLSX.read($file)

$file:=Folder:C1567(fk desktop folder:K87:19).file("export.xlsx")

$status:=$XLSX.write($file)
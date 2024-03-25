//%attributes = {}
var $xlsx : cs:C1710.XLSX

$xlsx:=cs:C1710.XLSX.new()
$file:=File:C1566("/RESOURCES/template.xlsx")
$xlsx.read($file)

$values:={}
$values.A2:="テスト"

$values.A3:=Current date:C33
$values.B3:=Current date:C33
$values.C3:=Current date:C33
$values.D3:=Current date:C33
$values.E3:=Current date:C33
//$values.A2:=False

$xlsx.fullCalcOnLoad:=False:C215

$xlsx.setValues($values; 1)

$file:=Folder:C1567(fk desktop folder:K87:19).file("template-copy.xlsx")
$xlsx.write($file)

OPEN URL:C673($file.platformPath)

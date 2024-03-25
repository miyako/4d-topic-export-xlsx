//%attributes = {}
var $XLSX : cs:C1710.XLSX

$XLSX:=cs:C1710.XLSX.new()

$file:=File:C1566("/RESOURCES/template.xlsx")

$status:=$XLSX.read($file)

$values:={}
$idx:=2
For each ($student; ds:C1482.Student.all())
	
	$values["A"+String:C10($idx)]:=$student.fullName
	$values["B"+String:C10($idx)]:=$student.birthday
	$values["C"+String:C10($idx)]:=$student.lastNameFirst
	$values["D"+String:C10($idx)]:=$student.age
	$values["E"+String:C10($idx)]:=New object:C1471("f"; "IF(C"+String:C10($idx)+",\"はい\",\"いいえ\")"; "v"; $student.lastNameFirst ? "はい" : "いいえ")
	
	//fullCalcOnLoadの検証
	//$values["E"+String($idx)]:=New object("f"; "IF(C"+String($idx)+",\"はい\",\"いいえ\")"; "v"; $student.lastNameFirst ? "" : "")
	
	$idx+=1
	
End for each 

$values["A1"]:="フルネーム"
$values["B1"]:="生年月日"
$values["C1"]:=""
$values["D1"]:="年齢"
$values["E1"]:="姓名順に出力"

$status:=$XLSX.setValues($values; 1)

$file:=Folder:C1567(fk desktop folder:K87:19).file("export.xlsx")

$status:=$XLSX.write($file)

OPEN URL:C673($file.platformPath)
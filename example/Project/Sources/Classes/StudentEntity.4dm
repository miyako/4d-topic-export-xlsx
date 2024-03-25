Class extends Entity

local Function get computedAge() : Object
	
	Case of 
		: (This:C1470.birthday=Null:C1517)
			return Null:C1517
			
		: (This:C1470.birthday=!00-00-00!)
			return Null:C1517
			
		Else 
			
			return ds:C1482.computeAge(Current date:C33; This:C1470.birthday)
			
	End case 
	
	//MARK:-age
	
local Function get age() : Integer
	
	var $computedAge : Object
	$computedAge:=This:C1470.computedAge
	
	return $computedAge#Null:C1517 ? $computedAge.years : Null:C1517
	
Function query age($event : Object) : Object
	
	var $operator : Text
	var $parameters : Collection
	
	$operator:=$event.operator
	
	var $currrentDate : Date
	$currrentDate:=Current date:C33
	
	Case of 
		: ($event.value=Null:C1517)
			return {query: "birthday == null"}
		: (Value type:C1509($event.value)=Is collection:K8:32) && ($operator="in") && ($event.value.length#0)
			var $idx : Integer
			$idx:=1
			$criteria:=[]
			$parameters:=[]
			For each ($value; $event.value)
				$age:=Num:C11($value)
				$fromDate:=Add to date:C393($currrentDate; -$age-1; 0; 0)
				$toDate:=Add to date:C393($fromDate; 1; 0; 0)
				$parameters.push($fromDate).push($toDate)
				$criteria.push("birthday > :"+String:C10($idx)+" and birthday <= :"+String:C10($idx+1))
				$idx+=2
			End for each 
			$query:=$criteria.join(" or ")
		Else 
			$age:=Num:C11($event.value)
			Case of 
				: ($operator="==")
					$query:="birthday > :1 and birthday <= :2"
				: ($operator="===")  //today is birthday
					$query:="birthday = :2"
				: ($operator="!=")
					$query:="birthday <= :1 or birthday > :2"
				: ($operator="!==")  //today is not birthday
					$query:="birthday # :2"
				: ($operator="<")
					$query:="birthday >= :1"
				: ($operator="<=")
					$query:="birthday > :1"
				: ($operator=">")
					$query:="birthday < :2"
				: ($operator=">=")
					$query:="birthday <= :2"
				Else 
					return Null:C1517  //not implemented
			End case 
			$fromDate:=Add to date:C393($currrentDate; -$age-1; 0; 0)
			$toDate:=Add to date:C393($fromDate; 1; 0; 0)
			$parameters:=[$fromDate; $toDate]
	End case 
	
	return {query: $query; parameters: $parameters}
	
Function orderBy age($event : Object) : Text
	
	If ($event.descending=True:C214)
		return "birthday asc"
	Else 
		return "birthday desc"
	End if 
	
	//MARK:-fullName
	
Function get fullName : Text
	
	Case of 
		: (This:C1470.lastNameFirst)
			return [This:C1470.lastName; This:C1470.firstName].join(" "; ck ignore null or empty:K85:5)
		Else 
			return [This:C1470.firstName; This:C1470.lastName].join(" "; ck ignore null or empty:K85:5)
	End case 
	
Function query fullName($event : Object) : Object
	
	var $operator : Text
	var $parameters : Collection
	
	$operator:=$event.operator
	
	var $firstname; $lastName : Text
	
	Case of 
		: ($event.value=Null:C1517)
			return {query: "firstName == null and lastName == null"}
		: (Value type:C1509($event.value)=Is collection:K8:32) && ($operator="in") && ($event.value.length#0)
			var $idx : Integer
			$idx:=1
			$criteria:=[]
			$parameters:=[]
			For each ($value; $event.value)
				$components:=Split string:C1554(String:C10($value); " "; sk trim spaces:K86:2 | sk ignore empty strings:K86:1)
				Case of 
					: ($components.length=0)
						$firstname:=""
						$lastName:=""
					: ($components.length=1)
						$firstname:=$components[0]
						$lastName:=""
					Else 
						$firstname:=$components[0]
						$lastName:=$components.slice(1).join(" ")
				End case 
				$parameters.push($firstname).push($lastName)
				$criteria.push([\
					"((lastNameFirst != true and firstName == :"+String:C10($idx)+" and lastName == :"+String:C10($idx+1)+")"; \
					" (lastNameFirst == true and lastName == :"+String:C10($idx)+" and firstName == :"+String:C10($idx+1)+"))"].join(" or "))
				$idx+=2
			End for each 
			$query:=$criteria.join(" or ")
		Else 
			$components:=Split string:C1554(String:C10($event.value); " "; sk trim spaces:K86:2 | sk ignore empty strings:K86:1)
			Case of 
				: ($components.length=0)
				: ($components.length=1)
					$firstname:=$components[0]
				Else 
					$firstname:=$components[0]
					$lastName:=$components.slice(1).join(" ")
			End case 
			$parameters:=[$firstname; $lastName]
			
			$query:=[\
				"(lastNameFirst != true and firstName "+$operator+" :1 and lastName "+$operator+" :2)"; \
				"(lastNameFirst  "+$operator+" true and lastName "+$operator+" :1 and firstName "+$operator+" :2)"].join(" or ")
	End case 
	
	return {query: $query; parameters: $parameters}
	
Function orderBy fullName($event : Object) : Text
	
	Case of 
		: (This:C1470.lastNameFirst)
			return [This:C1470.lastName; " "; $event.operator; This:C1470.firstName; " "; $event.operator].join("")
		Else 
			return [This:C1470.firstName; " "; $event.operator; This:C1470.lastName; " "; $event.operator].join("")
	End case 
	
	//MARK:public
	
local Function get currentYearLevel() : Text
	
	var $currentYearLevel : cs:C1710.YearLevel
	
	$currentYearLevel:=This:C1470._yearLevel(Current date:C33; This:C1470.birthday)
	
	Case of 
		: ($currentYearLevel=Null:C1517)
			return ""
		Else 
			return $currentYearLevel.school+$currentYearLevel.grade
	End case 
	
	//MARK:private
	
local Function _yearLevel($currentDate : Date; $birthDate : Date) : cs:C1710.YearLevel
	
	$startOfSchoolYear:=Add to date:C393(!00-00-00!; Year of:C25($currentDate); 4; 1)
	
	$age:=ds:C1482.computeAge($startOfSchoolYear; $birthDate).years
	
	Case of 
		: ($age=6)
			return cs:C1710.YearLevel.new("小学校"; "一年生")
		: ($age=7)
			return cs:C1710.YearLevel.new("小学校"; "二年生")
		: ($age=8)
			return cs:C1710.YearLevel.new("小学校"; "三年生")
		: ($age=9)
			return cs:C1710.YearLevel.new("小学校"; "四年生")
		: ($age=10)
			return cs:C1710.YearLevel.new("小学校"; "五年生")
		: ($age=11)
			return cs:C1710.YearLevel.new("小学校"; "六年生")
		: ($age=12)
			return cs:C1710.YearLevel.new("中学校"; "一年生")
		: ($age=13)
			return cs:C1710.YearLevel.new("中学校"; "二年生")
		: ($age=14)
			return cs:C1710.YearLevel.new("中学校"; "三年生")
		: ($age=15)
			return cs:C1710.YearLevel.new("高等学校"; "一年生")
		: ($age=16)
			return cs:C1710.YearLevel.new("高等学校"; "二年生")
		: ($age=17)
			return cs:C1710.YearLevel.new("高等学校"; "三年生")
		Else 
			return Null:C1517
	End case 
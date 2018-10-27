# is this a comment in Powershell?

Write-Host "sample of an if statement"
$broj = 10
if ($broj -gt 0)
{
    Write-Host "greater than zero"
}
else {
    Write-Host "less or equal to zero"
}


Write-Host "Some sample formating options"
Write-Host "using the format METHOD"
$name = "Stavre"
$recenica1 = [string]::Format("Kaj si be {0}", $name)
$recenica1

Write-Host "using the format OPERATOR"
$recenica2 = "Pozdrav {0}" -f $name
$recenica2

Write-Host "using the Expanding String"
$recenica3 = "Gubis se $name"
$recenica3


Write-Host "Arighmetic Operators"
$a = 9
$b = 5
$sum = $a+$b
Write-Host "$a + $b = $sum"

$difference = $a - $b
Write-Host "$a - $b = $difference"

$multiplicationResult = $a * $b
Write-Host "$a * $b = $multiplicationResult"

$devisionResult = $a / $b
Write-Host "$a / $b = $devisionResult"

$modulusResutl = $a%$b
Write-Host "$a % $b = $modulusResutl"


Write-Host "Logical operators"
$aTrue = $True
$bTrue = $True
$aFalse = $False
$bFalse = $False

$andResult = $aTrue -and $bTrue
Write-Host "andResult: $andResult"

$orResult = $aTrue -or $bFalse
Write-Host "orResult: $orResult"

$xorREsult = $aTrue -xor $bFalse
Write-Host "xorResult: $xorResult"

$xorREsult2 = $aTrue -xor $bTrue
Write-Host "xorResult2: $xorResult2"

$notResult = -not($andResult)
Write-Host "notResult : andResult : $andResult negated is : $notResult"


Write-Host "Comparison operators =, >, <, >= and <="
$First = 10
$Second = 6
$SameAsFirst = 10
Write-Host "Comparing $First and $Second"
Write-Host "$First -eq $Second = $($First -eq $Second)"
Write-Host "$First -eq $SameAsFirst = $($First -eq $SameAsFirst)"
Write-Host "$First -gt $Second = $($First -gt $Second)"
Write-Host "$First -ge $SameAsFirst = $($First -ge $SameAsFirst)"
Write-host "$First -lt $Second = $($First -lt $Second)"
Write-host "$First -le $SameAsFirst = $($First -le $SameAsFirst)"

Write-Host "Like and NotLike - work only on string and checks a string against a whildchar character"
$Sentence = "Something beautifull"
$likeThing = $Sentence -like "*thing*"
Write-Host  "$Sentence -like *thing* = $likeThing"
Write-Host "$Sentence -like *full = $($Sentence -like "*full")"
Write-Host  "$Sentence -like some* = $($Sentence -like "some*")"

Write-Host  "$Sentence -notlike *thing* = $($Sentence -notlike "*thing*")"
Write-Host "$Sentence -notlike *full = $($Sentence -notlike "*full")"
Write-Host  "$Sentence -notlike some* = $($Sentence -notlike "some*")"


Write-Host "Match and NotMatch work on a string or an array of strings and match against a regular expression and set the Matches automatic variable with all the matches"
$matchSentence = "It's a sunny day on Sunday which is today"
Write-Host "$matchSentence -match sun : $($matchSentence -match "sun")"
$Matches

Write-Host "$matchSentence -match day : $($matchSentence -match "day")"
$Matches

Write-Host "$matchSentence -match bun : $($matchSentence -match "bun")"
$Matches


Write-Host "$matchSentence -notmatch sun : $($matchSentence -notmatch "sun")"
$Matches

Write-Host "$matchSentence -notmatch day : $($matchSentence -notmatch "day")"
$Matches

Write-Host "$matchSentence -notmatch bun : $($matchSentence -notmatch "bun")"
$Matches

$matchCollection = "Today", "Tuesday", "Sunday", "Sunnny"
Write-Host "$matchCollection -match day : $($matchCollection -match "day")"
$Matches

Write-Host "$matchCollection -match sun : $($matchCollection -match "sun")"
$Matches

Write-Host "$matchCollection -notmatch day : $($matchCollection -notmatch "day")"
$Matches

Write-Host "$matchCollection -notmatch sun : $($matchCollection -notmatch "sun")"
$Matches


Write-Host "Contains and notContains - looks like it works only on collections"
$refernceValues = "first", "second", "third"
$testValue = "second"
$isContained = $refernceValues -contains $testValue
Write-Host "$refernceValues -contains $testValue : $isContained"
$testValue = "sec"
Write-Host "$refernceValues -contains $testValue : $($refernceValues -contains $testValue) - this is not an exact match"
Write-Host "When the test value is not a single string but another collection, the contains operator is comparing references, so if the reference of the test collection matches to the reference of at least one of the items in the collection of reference values, the operator will return True"

$testValue = "first", "second"
Write-Host "now the 'testValue' : $testValue is not a single string but a collection/list of two items but those are two strings and since the strings act as a value type and are immutable when comparing them with the items in the original collection they have completely different references "
$isContained = $refernceValues -contains $testValue
Write-Host "$refernceValues -contains $testValue : $($refernceValues -contains $testValue)"

$firstAndSecond = "first", "second"
$refernceValues = $firstAndSecond, "third"
Write-Host "now the list of reference values is composed of 2 items where the first item would match to the test value"
Write-host "$refernceValues -contains $firstAndSecond : $($refernceValues -contains $firstAndSecond)"


Write-Host "in - is the same as the contains operator BUT the order of the reference value and the test value is switched"
$refernceValues = "first", "second", "third"
$testValue = "second"
Write-Host "$testValue -in $refernceValues : $($testValue -in $refernceValues)"


Write-host "replace - in most simple form can be used to replace sections of a string"
$inString = "somebody was here"
$originalValue = "some"
$newValue = "no"
$newString = $inString -replace $originalValue, $newValue

Write-host "$inString -replace $originalValue, $newValue : $($newString)"
Write-host "case sensitive comparison "
$inString = "Somebody was here"
$originalValue = "some"
$newValue = "no"
Write-host "$inString -creplace $originalValue, $newValue : $($inString -creplace $originalValue, $newValue) - no replacement is being made here due to the case mistmatch"
$originalValue = "Some"
Write-host "$inString -creplace $originalValue, $newValue : $($inString -creplace $originalValue, $newValue) - replacement is being made here due to the case match"


Write-Host "type comparison with is - used to compare if two instances are of the same type"
$x = 1
$y = "1"
Write-Host "$x.GetType() : $($x.GetType())"
Write-Host "$y.GetType() : $($y.GetType())"
Write-Host "$x -is $y.GetType() : $($x -is $y.GetType())"



Write-Host "Loops - for"
for ( $i = 10 ; $i -le 100; $i+=10 ){
    Write-Host $i
}

$myList = "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"
Write-host $myList.Length
for( $i=0 ; $i -le $myList.Length; $i+=2){
    Write-Host $myList[$i]
}

foreach ($item in $myList){
    Write-Host $item
}
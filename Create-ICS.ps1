function Process-File {
    param (
        [string]$inputFile
    )

    $outputFile = [System.IO.Path]::ChangeExtension($inputFile, "ics")

    # Extract year and month from filename
    $filename = [System.IO.Path]::GetFileName($inputFile)
    $year = $filename.Substring(0, 4)
    $month = $filename.Substring(4, 2)

    Write-Host "Processing $inputFile for $year-$month"

    $icsContent = @"
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Prayer Times//EN

"@

    $lines = Get-Content $inputFile
    foreach ($line in $lines) {
        $parts = $line -split '\|' | ForEach-Object { $_.Trim() }
        if ($parts.Count -ne 7) { continue }

        $day, $dawn, $sunrise, $midday, $afternoon, $sunset, $night = $parts
        $day = "{0:D2}" -f [int]$day

        $prayers = @{
            "Dawn" = $dawn
            "Sunrise" = $sunrise
            "Midday" = $midday
            "Afternoon" = $afternoon
            "Sunset" = $sunset
            "Night" = $night
        }

        foreach ($prayer in $prayers.GetEnumerator()) {
            $name = $prayer.Key
            $time = $prayer.Value

            $hour, $minute = $time -split ':'
            $startTime = "{0:D2}{1:D2}00" -f [int]$hour, [int]$minute

            $endTime = [DateTime]::ParseExact("$year-$month-$day $time", "yyyy-MM-dd HH:mm", $null).AddMinutes(15)
            $endTimeFormatted = $endTime.ToString("HHmmss")

            $icsContent += @"
BEGIN:VEVENT
DTSTART:$year$month$day`T$startTime
DTEND:$year$month$day`T$endTimeFormatted
SUMMARY:$name Prayer
DESCRIPTION:$name Prayer Time
END:VEVENT

"@
        }
    }

    $icsContent += "END:VCALENDAR"
    Set-Content -Path $outputFile -Value $icsContent
    Write-Host "ICS file created: $outputFile"
}

if ($args.Count -eq 0) {
    Write-Host "Please provide input file(s)."
    exit 1
}

foreach ($file in $args) {
    if ($file -match '^\d{6}\.txt$') {
        Process-File $file
    }
    else {
        Write-Host "Skipping $file: Filename should be in YYYYMM.txt format"
    }
}

$answer = Read-Host "Do you want to concatenate all ICS files into a single file? (y/n)"
if ($answer.ToLower() -eq 'y') {
    $allIcsContent = Get-ChildItem -Filter *.ics | Get-Content
    Set-Content -Path "all_prayer_times.ics" -Value $allIcsContent
    Write-Host "All ICS files concatenated into all_prayer_times.ics"
}

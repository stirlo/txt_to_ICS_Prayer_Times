<?php

function process_file($input_file) {
    $output_file = pathinfo($input_file, PATHINFO_FILENAME) . '.ics';

    // Extract year and month from filename
    $filename = basename($input_file);
    $year = substr($filename, 0, 4);
    $month = substr($filename, 4, 2);

    echo "Processing $input_file for $year-$month\n";

    $ics_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//Prayer Times//EN\n";

    $lines = file($input_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        $parts = array_map('trim', explode('|', $line));
        if (count($parts) != 7) continue;

        list($day, $dawn, $sunrise, $midday, $afternoon, $sunset, $night) = $parts;
        $day = sprintf("%02d", $day);

        $prayers = [
            "Dawn" => $dawn,
            "Sunrise" => $sunrise,
            "Midday" => $midday,
            "Afternoon" => $afternoon,
            "Sunset" => $sunset,
            "Night" => $night
        ];

        foreach ($prayers as $name => $time) {
            list($hour, $minute) = explode(':', $time);
            $start_time = sprintf("%02d%02d00", $hour, $minute);

            $end_time = new DateTime("$year-$month-$day $time");
            $end_time->add(new DateInterval('PT15M'));
            $end_time_formatted = $end_time->format('His');

            $ics_content .= "BEGIN:VEVENT\n";
            $ics_content .= "DTSTART:{$year}{$month}{$day}T{$start_time}\n";
            $ics_content .= "DTEND:{$year}{$month}{$day}T{$end_time_formatted}\n";
            $ics_content .= "SUMMARY:$name Prayer\n";
            $ics_content .= "DESCRIPTION:$name Prayer Time\n";
            $ics_content .= "END:VEVENT\n";
        }
    }

    $ics_content .= "END:VCALENDAR\n";
    file_put_contents($output_file, $ics_content);
    echo "ICS file created: $output_file\n";
}

if ($argc < 2) {
    echo "Please provide input file(s).\n";
    exit(1);
}

for ($i = 1; $i < $argc; $i++) {
    $file = $argv[$i];
    if (preg_match('/^\d{6}\.txt$/', $file)) {
        process_file($file);
    } else {
        echo "Skipping $file: Filename should be in YYYYMM.txt format\n";
    }
}

echo "Do you want to concatenate all ICS files into a single file? (y/n) ";
$answer = trim(fgets(STDIN));
if (strtolower($answer) === 'y') {
    $all_ics_content = '';
    foreach (glob("*.ics") as $ics_file) {
        $all_ics_content .= file_get_contents($ics_file);
    }
    file_put_contents("all_prayer_times.ics", $all_ics_content);
    echo "All ICS files concatenated into all_prayer_times.ics\n";
}

#!/bin/bash

process_file() {
    input_file=$1
    output_file="${input_file%.*}.ics"

    year=${input_file:0:4}
    month=${input_file:4:2}

    echo "Processing $input_file for $year-$month"

    {
        echo "BEGIN:VCALENDAR"
        echo "VERSION:2.0"
        echo "PRODID:-//Prayer Times//EN"

        while IFS='|' read -r day dawn sunrise midday afternoon sunset night; do
            day=$(printf "%02d" "$((10#$(echo "$day" | tr -d '[:space:]')))")

            for prayer in "Dawn:$dawn" "Sunrise:$sunrise" "Midday:$midday" "Afternoon:$afternoon" "Sunset:$sunset" "Night:$night"; do
                IFS=':' read -r name time <<< "$prayer"
                name=$(echo "$name" | tr -d '[:space:]')
                time=$(echo "$time" | tr -d '[:space:]')

                IFS=':' read -r hour minute <<< "$time"
                start_time=$(printf "%02d%02d00" "$((10#$hour))" "$((10#$minute))")

                end_hour=$((10#$hour))
                end_minute=$((10#$minute + 15))
                if [ $end_minute -ge 60 ]; then
                    end_hour=$((end_hour + 1))
                    end_minute=$((end_minute - 60))
                fi
                end_time=$(printf "%02d%02d00" "$end_hour" "$end_minute")

                echo "BEGIN:VEVENT"
                echo "DTSTART:${year}${month}${day}T${start_time}"
                echo "DTEND:${year}${month}${day}T${end_time}"
                echo "SUMMARY:$name"
                echo "DESCRIPTION:$name"
                echo "END:VEVENT"
            done
        done < "$input_file"

        echo "END:VCALENDAR"
    } > "$output_file"

    echo "ICS file created: $output_file"
}

if [ $# -eq 0 ]; then
    echo "Please provide input file(s)."
    exit 1
fi

for file in "$@"; do
    if [[ $file =~ ^[0-9]{6}\.txt$ ]]; then
        process_file "$file"
    else
        echo "Skipping $file: Filename should be in YYYYMM.txt format"
    fi
done

echo "Do you want to concatenate all ICS files into a single file? (y/n)"
read -r answer

if [[ $answer =~ ^[Yy]$ ]]; then
    {
        echo "BEGIN:VCALENDAR"
        echo "VERSION:2.0"
        echo "PRODID:-//Prayer Times//EN"

        for file in *.ics; do
            sed -n '/BEGIN:VEVENT/,/END:VEVENT/p' "$file"
        done

        echo "END:VCALENDAR"
    } > all_prayer_times.ics
    echo "All ICS files concatenated into all_prayer_times.ics"
fi

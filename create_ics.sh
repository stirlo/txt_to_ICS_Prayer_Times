#!/bin/bash

# Function to process a single file
process_file() {
    input_file=$1
    output_file="${input_file%.*}.ics"  # Create output filename by replacing .txt with .ics

    # Extract year and month from filename
    filename=$(basename "$input_file")
    year=${filename:0:4}  # First 4 characters are the year
    month=${filename:4:2}  # Next 2 characters are the month

    echo "Processing $input_file for $year-$month"

    # Start the ICS file with required headers
    echo "BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Prayer Times//EN" > "$output_file"

    # Read the input file line by line
    while IFS='|' read -r day dawn sunrise midday afternoon sunset night; do
        # Remove leading/trailing spaces from each field
        day=$(echo "$day" | xargs)
        dawn=$(echo "$dawn" | xargs)
        sunrise=$(echo "$sunrise" | xargs)
        midday=$(echo "$midday" | xargs)
        afternoon=$(echo "$afternoon" | xargs)
        sunset=$(echo "$sunset" | xargs)
        night=$(echo "$night" | xargs)

        # Pad day with leading zero if necessary (e.g., 1 becomes 01)
        day=$(printf "%02d" "$day")

        # Generate events for each prayer time
        for prayer in "Dawn:$dawn" "Sunrise:$sunrise" "Midday:$midday" "Afternoon:$afternoon" "Sunset:$sunset" "Night:$night"; do
        IFS=':' read -r name time <<< "$prayer"  # Split prayer name and time


            # Convert time to hours and minutes
            IFS=':' read -r hour minute <<< "$time"

            # Calculate end time (15 minutes later)
            end_hour=$hour
            end_minute=$((10#$minute + 15))
            if [ $end_minute -ge 60 ]; then
                end_hour=$((10#$hour + 1))
                end_minute=$((end_minute - 60))
            fi

            # Format start and end times for ICS
            start_time=$(printf "%02d%02d00" $((10#$hour)) $((10#$minute)))
            end_time=$(printf "%02d%02d00" $end_hour $end_minute)

            # Write event to ICS file
            echo "BEGIN:VEVENT
DTSTART:${year}${month}${day}T${start_time}
DTEND:${year}${month}${day}T${end_time}
SUMMARY:${name}${name == 'Sunrise' ? '' : ' Prayer'}
DESCRIPTION:${name}${name == 'Sunrise' ? '' : ' Prayer Time'}
END:VEVENT" >> "$output_file"
done
    done < "$input_file"

    # End the ICS file
    echo "END:VCALENDAR" >> "$output_file"

    echo "ICS file created: $output_file"
}

# Check if input files are provided
if [ $# -eq 0 ]; then
    echo "Please provide input file(s)."
    exit 1
fi

# Process each input file
for file in "$@"; do
    if [[ $file =~ ^[0-9]{6}\.txt$ ]]; then  # Check if filename matches YYYYMM.txt format
        process_file "$file"
    else
        echo "Skipping $file: Filename should be in YYYYMM.txt format"
    fi
done

# Optionally concatenate all ICS files
read -p "Do you want to concatenate all ICS files into a single file? (y/n) " answer
if [[ $answer =~ ^[Yy]$ ]]; then
    cat *.ics > all_prayer_times.ics  # Concatenate all .ics files in the current directory
    echo "All ICS files concatenated into all_prayer_times.ics"
fi


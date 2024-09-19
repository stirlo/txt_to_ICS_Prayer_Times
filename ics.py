import sys
import os
from datetime import datetime, timedelta
import re

def process_file(input_file):
    output_file = os.path.splitext(input_file)[0] + '.ics'

    filename = os.path.basename(input_file)
    year = filename[:4]
    month = filename[4:6]

    print(f"Processing {input_file} for {year}-{month}")

    ics_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//Prayer Times//EN\n"

    with open(input_file, 'r') as f:
        for line in f:
            parts = [part.strip() for part in line.split('|')]
            if len(parts) != 7:
                continue

            day, dawn, sunrise, midday, afternoon, sunset, night = parts
            day = f"{int(day):02d}"

            prayers = {
                "Dawn": dawn,
                "Sunrise": sunrise,
                "Midday": midday,
                "Afternoon": afternoon,
                "Sunset": sunset,
                "Night": night
            }

            for name, time in prayers.items():
                hour, minute = map(int, time.split(':'))
                start_time = f"{hour:02d}{minute:02d}00"

                end_time = datetime.strptime(f"{year}-{month}-{day} {time}", "%Y-%m-%d %H:%M")
                end_time += timedelta(minutes=15)
                end_time_formatted = end_time.strftime("%H%M%S")

                ics_content += f"""BEGIN:VEVENT
DTSTART:{year}{month}{day}T{start_time}
DTEND:{year}{month}{day}T{end_time_formatted}
SUMMARY:{name}
DESCRIPTION:{name}
END:VEVENT
"""

    ics_content += "END:VCALENDAR\n"
    with open(output_file, 'w') as f:
        f.write(ics_content)
    print(f"ICS file created: {output_file}")

if len(sys.argv) < 2:
    print("Please provide input file(s).")
    sys.exit(1)

for file in sys.argv[1:]:
    if re.match(r'^\d{6}\.txt$', file):
        process_file(file)
    else:
        print(f"Skipping {file}: Filename should be in YYYYMM.txt format")

answer = input("Do you want to concatenate all ICS files into a single file? (y/n) ")
if answer.lower() == 'y':
    all_ics_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//Prayer Times//EN\n"
    for ics_file in [f for f in os.listdir() if f.endswith('.ics')]:
        with open(ics_file, 'r') as f:
            content = f.read()
            events = re.findall(r'BEGIN:VEVENT.*?END:VEVENT', content, re.DOTALL)
            all_ics_content += '\n'.join(events) + '\n'
    all_ics_content += "END:VCALENDAR\n"
    with open("all_prayer_times.ics", 'w') as f:
        f.write(all_ics_content)
    print("All ICS files concatenated into all_prayer_times.ics")

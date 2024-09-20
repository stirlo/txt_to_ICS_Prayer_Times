# Prayer Times Calendar Generator

This bash script converts prayer time data from text files into iCalendar (ICS) format, making it easy to import prayer schedules into various calendar applications.

## Features

- Processes prayer time data for multiple months and years
- Generates ICS files with 15-minute duration for each prayer event
- Supports batch processing of multiple input files
- Option to concatenate all generated ICS files into a single file
- Uses English terms for prayer times (Dawn, Sunrise, Midday, Afternoon, Sunset, Night)

## Requirements

- Bash shell (available on most Unix-like operating systems, including Linux and macOS)
- Input files named in the format `YYYYMM.txt` (e.g., `202409.txt` for September 2024)

## Usage

1. Clone this repository or download the script file.

2. Make the script executable:
   ```
   chmod +x create_ics.sh
   ```

3. Prepare your input files:
   - Name them in the format `YYYYMM.txt` (e.g., `202409.txt` for September 2024)
   - Each file should contain daily prayer times, one day per line
   - Use the format: `day | dawn | sunrise | midday | afternoon | sunset | night`
   - Example: `1 | 05:14 | 06:41 | 12:20 | 15:09 | 17:58 | 19:26`

4. Run the script with one or more input files:
   ```
   ./create_ics.sh 202409.txt 202410.txt 202411.txt
   ```

5. The script will generate an ICS file for each input file and ask if you want to concatenate them into a single file.

## Output

- Individual ICS files named after the input files (e.g., `202409.ics`)
- Optionally, a combined file named `all_prayer_times.ics`

## Importing to Calendar Applications

Most calendar applications (Google Calendar, Apple Calendar, Microsoft Outlook, etc.) can import ICS files. Refer to your calendar application's documentation for specific instructions on importing ICS files.

## Customization

You can modify the script to adjust:
- The duration of prayer events (currently set to 15 minutes)
- The naming of prayer times
- The format of the input files

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check [issues page](link-to-your-issues-page) if you want to contribute.

## License

[MIT](https://choosealicense.com/licenses/mit/) 

## Author

Stirling Campbell

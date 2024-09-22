# Plaintext to ICS Converter

This project provides tools to convert plaintext prayer time data into iCalendar (ICS) format, making it easy to import prayer schedules into various calendar applications. It now includes implementations in Bash, PowerShell, Python, Swift, and a web-based converter.

## Features

- Processes prayer time data for multiple months and years
- Generates ICS files with 15-minute duration for each prayer event
- Supports batch processing of multiple input files
- Option to concatenate all generated ICS files into a single file
- Uses English terms for prayer times (Dawn, Sunrise, Midday, Afternoon, Sunset, Night)
- Multiple implementation options: Bash, PowerShell, Python, Swift, and Web

## Implementations

### Bash Script

- Located in `create_ics.sh`
- Runs on most Unix-like operating systems, including Linux and macOS

### PowerShell Script

- Located in `Create-ICS.ps1`
- Runs on Windows, macOS, and Linux with PowerShell installed

### Python Script

- Located in `create_ics.py`
- Requires Python 3.x

### Swift Script

- Located in `CreateICS.swift`
- Requires Swift compiler (works on macOS, Linux, and Windows with Swift installed)

### Web-based Converter

- Located in `index.html`, `styles.css`, and related files
- Runs in web browsers, no server-side processing required
- Accessible online at: [https://stirlo.github.io/txt_to_ICS_Prayer_Times/](https://stirlo.github.io/txt_to_ICS_Prayer_Times/)

To use the web-based converter:
1. Visit [https://stirlo.github.io/txt_to_ICS_Prayer_Times/](https://stirlo.github.io/txt_to_ICS_Prayer_Times/) in your web browser
2. Upload text files using the file input
3. Click "Convert to ICS" to generate and download the ICS file


## Usage

### Bash Script

1. Make the script executable: `chmod +x create_ics.sh`
2. Run: `./create_ics.sh 202409.txt 202410.txt 202411.txt`

### PowerShell Script

Run: `.\Create-ICS.ps1 -InputFiles 202409.txt,202410.txt,202411.txt`

### Python Script

Run: `python create_ics.py 202409.txt 202410.txt 202411.txt`

### Swift Script

1. Compile: `swiftc CreateICS.swift`
2. Run: `./CreateICS 202409.txt 202410.txt 202411.txt`

### Web-based Converter

1. Open `index.html` in a web browser
2. Upload text files and click "Convert to ICS"

## Input File Format

- Name files as `YYYYMM.txt` (e.g., `202409.txt` for September 2024)
- Each file should contain daily prayer times, one day per line
- Use the format: `day | dawn | sunrise | midday | afternoon | sunset | night`
- Example: `1 | 05:14 | 06:41 | 12:20 | 15:09 | 17:58 | 19:26`

## Output

- Individual ICS files named after the input files (e.g., `202409.ics`)
- Optionally, a combined file named `all_prayer_times.ics`

## Importing to Calendar Applications

Most calendar applications (Google Calendar, Apple Calendar, Microsoft Outlook, etc.) can import ICS files. Refer to your calendar application's documentation for specific instructions on importing ICS files.

## Customization

You can modify the scripts to adjust:

- The duration of prayer events (currently set to 15 minutes)
- The naming of prayer times
- The format of the input files

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check [issues page](https://github.com/stirlo/txt_to_ICS_Prayer_Times/issues) if you want to contribute.

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Author

Stirling Campbell

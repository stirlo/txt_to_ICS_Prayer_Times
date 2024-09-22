## Plaintext to ICS Converter

This project converts plaintext prayer time data into iCalendar (ICS) format for easy calendar import. It supports multiple languages, including English, and has implementations in Bash, PowerShell, Python, Swift, and a web-based converter.

## Features

- Processes prayer time data for multiple months and years
- Generates ICS files with 15-minute duration for each event
- Supports batch processing and concatenating generated ICS files
- Uses English terms for prayer times

## Implementations

- Bash script (`create_ics.sh`) runs on Unix-like operating systems
- PowerShell script (`Create-ICS.ps1`) runs on Windows, macOS, and Linux with PowerShell
- Python script (`create_ics.py`) requires Python 3.x
- Swift script (`CreateICS.swift`) requires Swift and works on macOS, Linux, and Windows
- Web-based converter (`index.html`, `styles.css`, etc.) runs in web browsers

## To use the web-based converter:

- Access it online at: [https://stirlo.github.io/txt_to_ICS_Prayer_Times/](https://stirlo.github.io/txt_to_ICS_Prayer_Times/)
Visit [https://stirlo.github.io/txt_to_ICS_Prayer_Times/](https://stirlo.github.io/txt_to_ICS_Prayer_Times/) in your browser, upload text files using the file input, and click “Convert to ICS” to generate the ICS file.

## Usage

### Bash Script

- Make the script executable: `chmod +x create_ics.sh`
- Run: `./create_ics.sh 202409.txt 202410.txt 202411.txt`

### PowerShell Script

Run: `.\Create-ICS.ps1 -InputFiles 202409.txt,202410.txt,202411.txt`

### Python Script

Run: `python create_ics.py 202409.txt 202410.txt 202411.txt`

### Swift Script

1. Compile: `swiftc CreateICS.swift`
2. Run: `./CreateICS 202409.txt 202410.txt 202411.txt`

### Web-based Converter

- Open `index.html` in a web browser
- Upload text files and click “Convert to ICS”

## Input File Format

- Name files as `YYYYMM.txt` (e.g., `202409.txt` for September 2024)
- Each file should contain daily prayer times, one day per line
- Use the format: `day | dawn | sunrise | midday | afternoon | sunset | night`
- Example: `1 | 05:14 | 06:41 | 12:20 | 15:09 | 17:58 | 19:26`

## Output

- Individual ICS files named after the input files (e.g., `202409.ics`)
- Optionally, a combined file named `all_prayer_times.ics`

## Importing to Calendar Applications

Most calendar apps (Google Calendar, Apple Calendar, Microsoft Outlook, etc.) can import ICS files. Refer to your app’s documentation for specific instructions.

## Customization

- Adjust the duration of prayer events (currently 15 minutes)
- Name prayer times
- Change the input file format

## Contributing

Issues, feature requests, and contributions are welcome. Check [issues page](https://github.com/stirlo/txt_to_ICS_Prayer_Times/issues) to contribute.

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Author

Stirling Campbell

import Foundation

func processFile(_ inputFile: String) {
    let outputFile = (inputFile as NSString).deletingPathExtension + ".ics"

    // Extract year and month from filename
    let filename = (inputFile as NSString).lastPathComponent
    let year = String(filename.prefix(4))
    let month = String(filename.dropFirst(4).prefix(2))

    print("Processing \(inputFile) for \(year)-\(month)")

    var icsContent = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//Prayer Times//EN\n"

    do {
        let contents = try String(contentsOfFile: inputFile, encoding: .utf8)
        let lines = contents.components(separatedBy: .newlines)

        for line in lines {
            let parts = line.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            guard parts.count == 7 else { continue }

            let (day, dawn, sunrise, midday, afternoon, sunset, night) = (parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6])
            let paddedDay = String(format: "%02d", Int(day) ?? 0)

            let prayers = [
                "Dawn": dawn,
                "Sunrise": sunrise,
                "Midday": midday,
                "Afternoon": afternoon,
                "Sunset": sunset,
                "Night": night
            ]

            for (name, time) in prayers {
                let timeParts = time.components(separatedBy: ":")
                guard timeParts.count == 2,
                      let hour = Int(timeParts[0]),
                      let minute = Int(timeParts[1]) else { continue }

                let startTime = String(format: "%02d%02d00", hour, minute)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                guard let date = dateFormatter.date(from: "\(year)-\(month)-\(paddedDay) \(time)") else { continue }

                let endDate = date.addingTimeInterval(15 * 60)
                let endTime = String(format: "%02d%02d00", Calendar.current.component(.hour, from: endDate), Calendar.current.component(.minute, from: endDate))

                let summary = name == "Sunrise" ? name : "\(name) Prayer"
                let description = name == "Sunrise" ? name : "\(name) Prayer Time"
            
                icsContent += """
                BEGIN:VEVENT
                DTSTART:\(year)\(month)\(paddedDay)T\(startTime)
                DTEND:\(year)\(month)\(paddedDay)T\(endTime)
                SUMMARY:\(summary)
                DESCRIPTION:\(description)
                END:VEVENT
            
                """
            }
        }
    } catch {
        print("Error reading file: \(error)")
        return
    }

    icsContent += "END:VCALENDAR\n"

    do {
        try icsContent.write(toFile: outputFile, atomically: true, encoding: .utf8)
        print("ICS file created: \(outputFile)")
    } catch {
        print("Error writing file: \(error)")
    }
}

let arguments = CommandLine.arguments
if arguments.count < 2 {
    print("Please provide input file(s).")
    exit(1)
}

for file in arguments.dropFirst() {
    if file.range(of: #"^\d{6}\.txt$"#, options: .regularExpression) != nil {
        processFile(file)
    } else {
        print("Skipping \(file): Filename should be in YYYYMM.txt format")
    }
}

print("Do you want to concatenate all ICS files into a single file? (y/n) ")
if let answer = readLine()?.lowercased(), answer == "y" {
    var allIcsContent = ""
    let fileManager = FileManager.default
    do {
        let icsFiles = try fileManager.contentsOfDirectory(atPath: ".").filter { $0.hasSuffix(".ics") }
        for icsFile in icsFiles {
            if let content = try? String(contentsOfFile: icsFile) {
                allIcsContent += content
            }
        }
        try allIcsContent.write(toFile: "all_prayer_times.ics", atomically: true, encoding: .utf8)
        print("All ICS files concatenated into all_prayer_times.ics")
    } catch {
        print("Error concatenating files: \(error)")
    }
}

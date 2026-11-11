#!/usr/bin/env bash

# collect data
GENERATED_AT=$(date)
UPTIME_TEXT=$(uptime -p)
DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}')
DISK_PERCENT=$(echo "$DISK_USAGE" | tr -d '%')
MEM_TOTAL=$(free -m | awk 'NR==2 {print $2}')
MEM_AVAILABLE=$(free -m | awk 'NR==2 {print $NF}')
GITHUB_URL="https://github.com/HenkkaOAMK/linuxkurssi"

# check disc space

get_disk_status() {
    if [ "$DISK_PERCENT" -ge 80 ]
    then
	echo "WARNING"
    else
	echo "OK"
    fi
}

DISK_STATUS=$(get_disk_status)

cat > /var/www/html/viikko3/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Week 3 – Server Status Report</title>
    <style>
        body {
            font-family: Courier New;
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
            line-height: 1.6;
            background: #000000;
            color: #FF0000;
        }

        h1, h2 {
            color: #00FF66;
        }

        section {
            margin: 24px 0;
            padding: 24px;
            background: #111111;
	    border: 2px solid #FF0000;
            border-radius: 12px;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            border: 1px solid #FF0000;
            padding: 12px;
            text-align: left;
        }

        th {
            background: #111111;
	    color: 00FF66;
        }

        code {
            background: #222222;
	    color: #00FF66
            padding: 2px 5px;
            border-radius: 4px;
            overflow-wrap: anywhere;
        }

        a {
            color: #00FF66;
        }

        .note {
            color: #FF0000;
        }
    </style>
</head>
<body>
    <header>
        <h1>Server Status Report</h1>
        <p>Week 3: Linux command line and Bash scripting</p>
        <p>This is the week 3 homework. Idea was to automatically generate a report using Bash script and update it every minute.</p>
    </header>

    <section>
        <h2>Current server status</h2>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th scope="col">Information</th>
                        <th scope="col">Value</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row">Report generated</th>
                        <td>$GENERATED_AT</td>
                    </tr>
                    <tr>
                        <th scope="row">Server uptime</th>
                        <td>$UPTIME_TEXT</td>
                    </tr>
                    <tr>
                        <th scope="row">Root filesystem disk usage</th>
                        <td>$DISK_USAGE</td>
                    </tr>
                    <tr>
                        <th scope="row">Disk space status</th>
                        <td>$DISK_STATUS</td>
                    </tr>
                    <tr>
                        <th scope="row">Total RAM</th>
                        <td>$MEM_TOTAL MiB</td>
                    </tr>
                    <tr>
                        <th scope="row">Available RAM</th>
                        <td>$MEM_AVAILABLE MiB</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <p>
            Disk space status is <strong>OK</strong> below 80% usage
            and <strong>WARNING</strong> at 80% or above.
        </p>

        <p class="note">
            Bash generates this report once per minute.
            Wait approximately 1–2 minutes and reload the page
            to see a new generation time.
        </p>
    </section>

    <section>
        <h2>Commands used</h2>
        <ul>
            <li>
                <code>date</code>:
                displays the current date, time and time zone
                using the format specified in the script.
            </li>
            <li>
                <code>uptime -p</code>:
                displays how long the server has been running.
            </li>
            <li>
                <code>df -P / | awk 'NR == 2 {print &#36;5}'</code>:
                passes filesystem information to awk, which extracts
                the usage percentage from the second row.
            </li>
            <li>
                <code>free -m</code>:
                displays memory information in mebibytes (MiB).
            </li>
        </ul>
    </section>

    <section>
        <h2>How the script works</h2>
        <p>
            The script collects server information using Linux commands
            and stores the results in Bash variables through command
            substitution. A function uses an if statement to determine
            the disk space status.
        </p>
        <p>
            The script generates a temporary HTML file and then moves
            the completed file into place as index.html.
            Nginx serves this file at /viikko3/.
        </p>
        <p>
            The disk space status is determined by function called get_disk_status(). Function uses if 
            statement to check if disk usage is below 80% for OK status and 80% or more for WARNING status.
	</p>
	<p>
	    An example of piping used in the script is: df -P / | awk 'NR2==2 {print $5}'. The df command provides 
	    filesystem info and awk selects the disk usage percentage from the output.
        </p>
    </section>

    <section>
        <h2>Scheduling</h2>
        <p>
            I chose to use cron. Which was also the one that teacher suggested. Cron schedule that I used 
	    was: *****/home/ubuntu/viikko3/report.sh, where the update happens every minute.
	</p>
	<p>
	    After I got it work, I rebooted the virtual machine and tested it again. Cron schedule continued
	    running automatically as intended. Updates kept coming every minute.
        </p>
    </section>

    <section>
        <h2>Test results</h2>

        <h3>Syntax check and manual execution</h3>
        <p>
            The script was checked using: <code>bash -n report.sh</code>. I got no errors. 
	    After that I execute the script manually using ./report.sh. Report was generated succesfully and
	    the browser showd everything as it should.
        </p>

        <h3>Disk space status tests</h3>
        <p>
            I tested the status logic using temporary input values.
            Then I recorded my actual results below and restored real disk
            usage afterwards.
        </p>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th scope="col">Test input</th>
                        <th scope="col">Expected status</th>
                        <th scope="col">Actual status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>50%</td>
                        <td>OK</td>
                        <td>OK</td>
                    </tr>
                    <tr>
                        <td>80%</td>
                        <td>WARNING</td>
                        <td>WARNING</td>
                    </tr>
                    <tr>
                        <td>90%</td>
                        <td>WARNING</td>
                        <td>WARNING</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h3>Automatic updates</h3>
        <p>
            Here are records of first three automatic updates:
	</p>

	<ul>
	    <li>Wed Nov 11 08:24:01 EET 2026</li>
	    <li>Wed Nov 11 08:25:01 EET 2026</li>
	    <li>Wed Nov 11 08:26:01 EET 2026</li>
        </ul>

        <h3>Reboot test</h3>
        <p>
            I rebooted the virtual machine using sudo reboot. After reboot I tested
	    that all my previous homeworks were up and running and of course the newesr viikko 3 homework
	    was up and running. 
	</p>
	<p>
	    I also made sure that Cron was still working and below is new time after reboot:
        </p>
	<ul>
	    <li>Wed Nov 11 08:33:50 EET 2026.</li>
	</ul>
    </section>

    <section>
        <h2>A problem solved or a lesson learned</h2>
        <p>At first the script could not write to /var/www/html/viikko3 becouse of file permissions.
	   Problem was solved by changing the directory owner to ubuntu, not root.
	</p>
    </section>

    <footer>
        <p><a href="$GITHUB_URL">View the source code on GitHub</a></p>
    </footer>
</body>
</html>
EOF

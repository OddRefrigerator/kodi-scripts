# Kodi Scripts

A collection of useful scripts for automating and enhancing the Kodi media center experience. These scripts aim to improve the management, customization, and automation of Kodi tasks, allowing users to streamline their media playback, library updates, and other routine tasks.

## Features

- **Automated Library Updates:** Scripts to automatically update the Kodi library, ensuring your media collection stays current.
- **Media Playback Automation:** Control media playback, such as auto-playing playlists or scheduling playback tasks.
- **Custom Notifications:** Send custom notifications to your Kodi interface, useful for alerts or status updates.
- **Backup and Restore:** Scripts to automate the backup and restoration of Kodi configurations and media databases.
- **Cross-Platform Support:** Works on any platform that supports Kodi, including Windows, macOS, Linux, and Raspberry Pi.

## Requirements

- Kodi media center installed on your device.
- Python installed (if required by specific scripts).
- SSH access or file transfer ability to copy scripts to your Kodi machine (optional but recommended).

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/OddRefrigerator/kodi-scripts.git
   ```

2. Copy the desired script(s) to your Kodi installation directory. For example, place them in a directory such as `~/.kodi/userdata/`.

3. Make sure the scripts have the appropriate executable permissions:
   ```bash
   chmod +x script-name.py
   ```

4. Integrate the script with Kodi by following Kodi's custom script integration guidelines or trigger the scripts using a scheduled task (e.g., cron jobs on Linux).

## Usage

### Example: Automatic Library Update Script

To use the automatic library update script:

1. Copy the script to your Kodi machine.
2. Set up a scheduled task to run the script at regular intervals. For Linux:
   ```bash
   crontab -e
   ```
   Add a cron job, such as:
   ```bash
   0 * * * * /path/to/update-library-script.py
   ```
   This will update the Kodi library every hour.

### Example: Custom Notifications

To send a custom notification to your Kodi interface:

1. Modify the script to include your desired message.
2. Run the script to send the notification:
   ```bash
   python custom-notification.py
   ```

### Backup and Restore

Use the backup and restore scripts to save and restore your Kodi configuration and database. Modify the paths as needed to suit your system setup.

## Customization

You can modify any of the scripts to suit your needs. Each script contains comments and documentation to help you understand its functionality and how to customize it. Feel free to adjust paths, media sources, and settings according to your Kodi setup.

## Contributing

Contributions are welcome! If you have ideas for new scripts or improvements, feel free to fork the repository and submit a pull request.

### Steps for Contribution

1. Fork the repository.
2. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of your feature or fix"
   ```
4. Push your branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request with a detailed explanation of your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any inquiries or issues, feel free to open an issue on GitHub or contact the repository owner.

---

Enjoy your enhanced Kodi experience with these useful scripts!

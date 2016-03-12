## Testme - test running automation
`testme.pl` is the simple pure Perl-script that checks your source files for the last modification time then sleeps for the given period of time. If some of files described in config has changed - it will run associated test command.

It doesn't requires inotify-tools for Linux, nor fswatch for OSX.

By default, testme.pl looking for `testme.json` config in current directory. You could also specify this location by command-line option `-c`:

```bash
testme.pl -c /path/to/config.json
```
Example of expected configuration file:

```json
{
  "testme": {
    "sleep": 2,
    "working_directory": "/var/www/site",
    "targets": [
      {
        "src": ["public/script1.js", "public/script2.js"],
        "test": "casperjs --disk-cache=true test /var/www/site/t/test.js"
      },
      {
        "src": ["lib/Object.pm"],
        "test": "prove /var/www/site/t/Object.t"
      }
    ]
  }
}
```
If you already have configuration file in JSON for your application, you can add `testme`-property to the first level of it to store all configs in one place.

Above configuration means: if file `public/script1.js` or `public/script2.js` located in `/var/www/site` has changed, then command: `casperjs --disk-cache=true test /var/www/site/t/test.js` will be executed. Similarly for the perl scripts below. This check will repeat in `2` seconds later.

### Configuration file options:
 - `sleep` - period of time in seconds before next checking iteration. Default is: 1.
 - `working_directory` - prefix for each file, described in `targets.src` array
 - `targets`:
   - `src` - array of files to check last modification time. Each file prefixed by `working_directory` parameter.
   - `test` - shell command to execute when one of src-files has changed

#### AUTHOR

MDn <maddemon@gmail.com>

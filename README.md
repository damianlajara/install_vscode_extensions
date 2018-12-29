# install_vscode_extensions
A simple little ruby script that will allow you to install VS Code extensions after using the plugin `Settings Sync`.

## Installation
Make sure you are using the [code-settings-sync plugin](https://github.com/shanalikhan/code-settings-sync) and you followed all the directions and have uploaded your settings.

This is will create a gist. Simply copy the gist id and pass it in as a parameter to the script.

## Run
Make sure you get the gist ID from the above step and run the following in your terminal: `ruby ./install_exstensions.rb <GIST_ID>`

Made it simple enough so that this can easily be modified to work without depending at all on the gist from the `code-settings-sync` plugin if you need to adapt it to your current situation.

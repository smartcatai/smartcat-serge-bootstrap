# Sample continuous localization project for Smartcat

This example project has everything you need to set up your continuous localization project on [Smartcat](https://smartcat.ai/) platform in minutes.

What we offer here is a pre-configured Docker container with our command-line localization automation tool, [Serge](https://serge.io/) _(String Extraction and Resource Generation Engine)_, which will pull the changes from your code repository, scan and parse the files, send translation data over to Smartcat, get translations back, integrate them into its local database, generate localized files and push them back to your repo, all in a single sweep.

This approach to localization:

-   Doesn't require writing custom low-level integration code: you write declarative configuration files instead
-   Doesn't require you to change your CI/CD build process: translations are integrated statically into your source code repository
-   Is secure: you don't give Smartcat direct access to your source code repositories, and you control all the synchronization
-   Is vendor lock-in free: you own your translation data, and can generate localized resource files completely offline
-   Is flexible: you can manually run it on your computer, or run it on a schedule on a dedicated host
-   Is powerful: you can implement localization workflows that otherwise would require many months of development (see below).

## Features

With our continuous localization solution, you have an unprecedented flexibility and power. Some ideas that might inspire you are:

-   Automatic discovery and localization of multiple product branches
-   Ability to prohibit localized file updates unless they are 100% translated (handy for marketing materials!)
-   Ability to specify target languages right in each file, to enable automated self-service scenarios
-   Pseudo-localization for easier internationalization (i18n) QA
-   Conditional exclusion of certain strings by mask
-   Ability to auto-generate comments and preview links for each string
-   Ability to group multiple repositories and different file types under a same logical project
-   Ability to preprocess source files for greater flexibility
-   Ability to post-process localized files so that the final result is CI/CD-ready
-   Ability to email developers if source files are broken
-   ... and much more!

# Installation

1. [Install Docker](https://www.docker.com/products/docker-desktop) for your Windows, Mac, or Linux.

2. Run this command to install Serge for the first time, or to update it to a latest version:

       $ docker pull smartcatcom/serge:v2

3. Clone this repository into any directory and switch to v2 branch:

       $ git clone https://github.com/smartcatai/smartcat-serge-bootstrap.git .
       $ git checkout v2

# Getting Started

## Running Serge in interactive mode

In the root directory of this repo we have provided you a script to run a Serge shell, from which you will have access to `serge` tool, as well as convenience commands like `localize`, `pull`, and so on. To enter the interactive shell, run it without any command-line parameters:

    $ ./serge-shell

When you enter your shell, the directory of your bootstrap project will be mounted as `/root`, your project directory structure will be initialized, and you will see the following prompt:

    [Serge Shell] ~ $

---

**Note:** Here and below, it is assumed that you're running the commands inside this shell. At the same time, you can continue editing the configuration files or browse the directory outside of the shell in Explorer, Finder, or any other favorite file management tool and code editor.

---

Now you that you are inside this interactive shell, you can run Serge (the command below will just show some short usage synopsis and a list of available commands):

    $ serge

To exit the shell later, use the `exit` command:

    $ exit

## Getting around

This repository contains sample project data under the `data` folder. First things to do are:

-   See the configuration file: [config.serge](config.serge)
-   Look at the contents of the source project folder: [data](data)

This sample project is set up to have `en` (English) as a source language and `de` (German) and `ru` (Russian) as target languages, and will process all keys in JSON resource files in [data/en](data/en) directory.

## Initial run

Run the localization command:

    $ localize

This will create localized files under `data/de` and `data/ru` directories. These files will have English content, since translations have not been provided just yet.

The same localization step will generate translation files under `ts/de` and `ts/ru` directories. You can examine the generated `.po` files and also see their initial state with no translations.

## Doing translations locally

Edit e.g. `ts/de/example.json.po` file and provide a translation for a single string (for testing purposes, any random "translation" will work).

Run `localize` command once again. If you now open the localized resource file, e.g. `data/de/example.json`, you will see that your translation has been integrated into the JSON file.
## Connecting this project with your Git repository

1. Put your private SSH key into `.ssh` directory of this project, and name it `id_rsa` (as you would do when setting SSH on your host machine).
2. Restart Serge Shell for the changes to take effect.
3. Edit the [config.serge](config.serge) file and provide your Git clone URL as `remote_path` parameter.

Run initial checkout:

    $ pull --initialize

This will replace the contents of your `data` folder with the downloaded content.

Now you will need to adjust your [config.serge](config.serge) file to use the proper parser and file paths (see `source_dir`, `source_match`, `output_file_path` and `parser -> plugin` parameters). For more information on available parser plugins and their settings, as well as help on Serge configuration parameters, see [Serge documentation](https://serge.io/docs/), starting with the [configuration file syntax and reference](https://serge.io/docs/configuration-files/syntax/).

## Connecting this project with Smartcat

1. Create a new project in Smartcat with _English_ as a source language and _German_ and _Russian_ as target ones to match your configuration file settings. Languages must be registered on the project before you can upload files targeting those languages. You can later change the list of target languages at any time.
2. Edit the [config.serge](config.serge) file and fill out your account parameters and credentials under _ts_ config section: `base_url`, `account_id`, `token`, and `project_id`. Instructions next to each parameter will help you understand where to get the values from. Once defined, these settings will be shared across your future localization projects.

Now you can push your translation files to Smartcat:

    $ push-ts

Go to Smartcat, open the test project you created, and there you will see your `example.json_de` and `example.json_ru` files available for translation, one for German, and another one for Russian.

Open e.g. `example.json_de` and edit the translation for the string that you translated previously.

Now you can pull translations from Smartcat and then a localization cycle:

    $ pull-ts
    $ localize

If you now open the localized resource file, `vcs/project-a/de/example.json`, you will see that the new translation has been integrated into the JSON file.

Before pushing changes to your remote repository, you can examine changes using Git:

    $ cd ~/data
    $ git diff

If everything looks good, push changes to Git:

    $ push

# Running it all at once

Above you learned how to run individual commands to pull and push data to Git, push translation files and pull them back from Smartcat, and how to generate localized files. Now you can do all of this with a single command:

    $ sync

This command is equivalent to the following sequence:

    $ pull
    $ pull-ts
    $ localize
    $ push-ts
    $ push
    $ clean-ts

## Running the localization continuously

It's time to automate your synchronization process. Instead of entering the interactive shell and then running the `sync` command manually, you can simply run the following command from the host machine:

    $ ./serge-shell sync

This will run the command in a docker container, and the container will exit automatically upon finishing. You can run this command every day, every hour, or every 15 minutes — it's up to you. The smaller the synchronization cycle, the faster you will have your source strings exposed for translation, and the faster you will get new translations integrated back into your repository, where you can do CI/CD builds, or run internal checks and test automation.

## Getting professional support

At Smartcat, we strive to build delightful localization processes that work seamlessly and don't slow you down. We offer managed solutions and localization engineering services [as a part of the subscription](https://www.smartcat.com/pricing/) so you can get everything up and running as quickly as possible!</p>

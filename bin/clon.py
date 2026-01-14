#!/usr/bin/env python

# clon but in python

# Help: clon -h

# rclone options:

# -P : show progress real-time
# --skip-links : don't sync symbolic links
# --exclude-from : exclude certain files
# --dry-run : don't do anything, just simulate
# --no-update-modtime : avoid having to reupload
#   tons of files just because the modification
#   time wasn't carried during a copy operation

# Inside .csv file:
# Just by appending a path key to DEST dict, and ending the
# local folder with a Conf.cp char,
# prepend the folder with this root path


# Libraries
import argparse
import os
import subprocess
import re
import sys
import csv


# Conf
class Conf:

    # Special chars in CSV file
    ci = "#"    # ignore line
    cl = "^"    # copy links
    cp = "^"    # root path

    # Root folder of config files
    root = "/home/fabi/.clon"

    # File with all syncs
    
    # option,prefix,sync,path
    # option: shorthand of the sync in command line
    # prefix: name of the sync in rclone
    # sync: name of the CSV file with the folder names for that sync
    # path: optional root folder to append to folder names
    dests = "dests.csv"

    # Name of file with blacklist
    exclude_file = "exclude"

    # Check if conf files exist
    @classmethod
    def check(cls):

        if not os.path.isdir(cls.root):
            sys.exit("Missing root configuration folder")

        # Set drive names
        cls.DEST = {}

        try:
            with open(cls.root + "/" + cls.dests) as file:
                reader = csv.DictReader(file)
                for row in reader:
                    cls.DEST[row["option"]] = {
                            "prefix": row["prefix"],
                            "sync": row["sync"],
                            "path": row["path"],
                        }

        except FileNotFoundError:
            sys.exit("Missing services configuration file")

        # Analyze all files
        files = [cls.DEST[x]["sync"] for x in cls.DEST]
        if cls.exclude_file:
            files += [cls.exclude_file]

        for file in files:
            if not os.path.isfile(cls.root + "/" + file):
                sys.exit(f"Missing configuration file '{file}'")


    # Set options
    @classmethod
    def set(cls):

        # Read parameters
        args = cls.parse_args()

        # Edit CSV?
        if args.service == "edit":
            files = [cls.root + "/" + cls.DEST[x]["sync"] for x in cls.DEST]
            subprocess.run(["vim"] + files)
            sys.exit()

        # Set exclude variable
        if cls.exclude_file:
            cls.exclude = ["--exclude-from", cls.root + "/" + cls.exclude_file]
        else:
            cls.exclude = ""

        # Age
        if args.max_age:
            cls.max_age = args.max_age
        else:
            cls.max_age = ""

        # Dry run
        if args.dry_run:
            cls.dryrun = "--dry-run"
        else:
            cls.dryrun = ""

        # Decide sync service
        cls.service = args.service

        # Direction
        if args.reverse:
            cls.reverse = True
        else:
            cls.reverse = False


    # Handle command line parameters
    @classmethod
    def parse_args(cls):

        parser = argparse.ArgumentParser(description="Frontend to rclone")

        # Service
        parser.add_argument("service", help="service to sync to",
            choices=[s for s in cls.DEST] + ["edit"])

        # Direction
        parser.add_argument("-r", "--reverse", help="don't upload, download from the cloud",
            action="store_true")

        # Dry run (just see the effect, don't change actual files)
        parser.add_argument("-d", "--dry-run", help="don't change anything in the cloud",
            action="store_true")

        # Max age (check only files newer than this age
        parser.add_argument("-m", "--max-age", help="check files max this old")
            #action="store_true")

        # Return object with arguments accesible as attribs
        return parser.parse_args()


def main():

    # Check configuration files
    Conf.check()

    # Set options
    Conf.set()

    # Get sync routes
    syncs = get_syncs()
    
    # Iterate on syncs
    for sync in syncs:
        exec_sync(sync)


# Banner
def banner(message):
    print("\n", 30 * "-", "|", "| Now syncing:", "|", sep="\n")
    print("|", re.sub(r"(.+/)+", "", message))
    print("|", 30 * "-", "\n", sep="\n")


# Get sync list from file
def get_syncs():

    syncs = []
    service = Conf.service
    prefix = Conf.DEST[service]["prefix"]
    filename = Conf.root + "/" + Conf.DEST[service]["sync"]

    # Extra root path
    path = ""
    if "path" in Conf.DEST[service] and not os.path.isdir(Conf.DEST[service]["path"]):
        sys.exit(f'No folder {Conf.DEST[service]["path"]} found')
    else:
        path = Conf.DEST[service]["path"]

    with open(filename) as file:

        reader = csv.reader(file)
        for row in reader:

            # Ignore comments
            if row[0].startswith(Conf.ci):
                continue

            start, end = row

            # Append extra path
            if path and start.endswith(Conf.cp):

                # Handle links special character
                if start.startswith(Conf.cl):
                    start = Conf.cl + path + start.removeprefix(Conf.cl)
                else:
                    start = path + start
            # Remove root path character
            start = start.removesuffix(Conf.cp)
                
            syncs.append({ "start": start, "end": prefix + end })

    return syncs


# Execute rclone command
def exec_sync(sync):

    # Revert source and dest if parameter -u
    if Conf.reverse:
        start = sync["end"]
        end = sync["start"]
    else:
        start = sync["start"]
        end = sync["end"]

    # Print banner
    banner(start)

    # If it starts with \", copy links
    if start.startswith(Conf.cl):
        Conf.links = "--copy-links"
        print("WARNING: copying links...\n")
    else:
        Conf.links = "--skip-links"

    # subprocess.run requires a list
    cmd = ["rclone", "sync", "-P", "--no-update-modtime"]
    if Conf.exclude:
        cmd += Conf.exclude
    if Conf.max_age:
        cmd += ["--max-age", Conf.max_age]
    if Conf.dryrun:
        cmd += [Conf.dryrun]
    cmd += [Conf.links]
    cmd += [start.removeprefix(Conf.cl), end.removeprefix(Conf.cl)]

    # Sync
    try:
        subprocess.run(cmd)
    except KeyboardInterrupt:
        print()
        sys.exit()


if __name__ == "__main__":
    main()

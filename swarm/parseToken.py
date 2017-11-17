#!/usr/bin/env python3

import sys
import re


def main():
    reParser = re.compile(r"--token\s(\S+)", re.IGNORECASE)
    found = False
    for line in sys.stdin:
        checkLine = reParser.match(line.strip())
        if checkLine:
            print(str(checkLine.group(1)))
            found = True
    if not found:
        print("Token Not Found")


if __name__ == '__main__':
    main()

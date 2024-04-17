#!/usr/bin/env python3
def main(*_):
    ...


def cli():
    import argparse
    import sys
    parser = argparse.ArgumentParser(description='Parse file')
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'),
                        default=sys.stdin, help='input file or stdin')
    parser.add_argument('outfile', nargs='?', type=argparse.FileType('w'),
                        default=sys.stdout, help='output file or stdout')
    parser.add_argument("-u", "--username", action="store", nargs=1, dest="username",
                        choices=['prod', 'dev', 'tst'],
                        help="Username to change credentials for")
    parser.add_argument('--dry-run', '-n', action='store_true', default=False)
    args = parser.parse_args()
    if not args.username:
        parser.print_help()
        sys.exit(1)

    main(**vars(args))


if __name__ == '__main__':
    cli()

import sys
import argparse
from interpreter import miniLispInterpreter
import logging

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--debug', action='store_true')
    args = parser.parse_args()
    if args.debug:
        logging.basicConfig(level=logging.DEBUG)
    miniLispInterpreter().interpret(sys.stdin.read())

from hw8_1 import getDict
import sys

def main():
    ngramDict = getDict(sys.argv[1])
    sortedList = sorted(ngramDict.items(), key=lambda kv: kv[1])
    print(sortedList[len(sortedList)-1:len(sortedList)-11:-1])

if __name__ == '__main__':
    main()
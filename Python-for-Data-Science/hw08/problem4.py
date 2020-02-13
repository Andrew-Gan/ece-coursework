import hw8_4

def main():
    doclist = ['lecs/' + str(i) + '_vidText.txt' for i in range(1, 12)]
    docword, wordlist = hw8_4.buildDocWordMatrix(doclist)
    print(hw8_4.findDistinctiveWords(docword, wordlist, doclist))

if __name__ == '__main__':
    main()
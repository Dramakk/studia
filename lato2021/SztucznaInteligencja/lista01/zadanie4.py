def opt_dist(word, length):
    wordQueue = []

    def checkForValidBlock(wordString, blockLength):
        startOfBlock = wordString.find('1'*blockLength)

        if startOfBlock == -1:
            return 0
        else:
            if wordString[0:startOfBlock].find('1') == -1 and wordString[(startOfBlock+blockLength):(len(wordString))].find('1') == -1:
                return 1
        
        return 0
    
    def checkNewPermutation():
        isFound = 0

        while wordQueue != []:
            wordString, steps, position = wordQueue.pop(0)
            isFound = checkForValidBlock(wordString, length)

            if isFound:
                return steps
                
            wordToList = list(wordString)
            if position < len(wordString):
                if wordToList[position] == '0':
                    wordQueue.append([''.join(wordToList.copy()), steps, position+1])
                    wordToList[position] = '1'
                    wordQueue.append([''.join(wordToList.copy()), steps+1, position+1])
                else:
                    wordQueue.append([''.join(wordToList.copy()), steps, position+1])
                    wordToList[position] = '0'
                    wordQueue.append([''.join(wordToList.copy()), steps+1, position+1])

    wordQueue.append([word, 0, 0])
    return checkNewPermutation()

inFile = open('zad4_input.txt', 'r')
outFile = open('zad4_output.txt', 'w')
for i in inFile:
    line = i.split()
    print(opt_dist(line[0], int(line[1])), file=outFile)
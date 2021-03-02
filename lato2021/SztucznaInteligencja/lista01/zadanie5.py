import re
import random

rows = []

columns = []


def opt_elem(rowsDescription, columnsDescription, file=None):
    rowsDim = len(rowsDescription)
    columnsDim = len(columnsDescription)
    
    def myCopy(imageDescription):
        newImage = []
        for i in imageDescription:
            newImage.append(i[:])

        return newImage

    def draw(imageDescription, file=None):
        for i in range(0, rowsDim):
            for j in range(0, columnsDim):
                characterToPrint = '#'
                if imageDescription[i][j] == 0:
                    characterToPrint = '.'
                print(characterToPrint, end='', file=file)
            print(file=file)

    def generateImageDescription():
        imageDescription = []
        for _ in range(0, rowsDim):
            row = []
            for _ in range(0, columnsDim):
                row.append(random.randint(0, 1))
            imageDescription.append(row)
        return imageDescription
    
    def findGroups(word):
        return re.findall(r'[1]{1,}', word)
    
    def getColumn(imageDescription, i):
        column = []

        for j in range(0, rowsDim):
            column.append(imageDescription[j][i])
        return column
    
    def getRow(imageDescription, i):
        row = []

        for j in range(0, columnsDim):
            row.append(imageDescription[i][j])
        return row

    def getBadColumns(imageDescription):
        badColumns = []

        for i in range(0, columnsDim):
            column = getColumn(imageDescription, i)
            column = map(str, column)

            groupsInColumn = findGroups(''.join(column))

            if len(groupsInColumn) != len(columnsDescription[i]):
                badColumns.append(i)
            elif len(groupsInColumn[0]) != columnsDescription[i][0]:
                badColumns.append(i)

        return badColumns

    def getBadRows(imageDescription):
        badRows = []

        for i in range(0, rowsDim):
            row = getRow(imageDescription, i)
            row = map(str, row)

            groupsInRow = findGroups(''.join(row))

            if len(groupsInRow) != len(rowsDescription[i]):
                badRows.append(i)
            elif len(groupsInRow[0]) != rowsDescription[i][0]:
                badRows.append(i)

        return badRows
    
    def scoreImage(imageDescription):
        squareSum = 0
        for i in range(0, rowsDim):
            onesInRow = 0
            for j in getRow(imageDescription, i):
                onesInRow = onesInRow + j
            squareSum += (rowsDescription[i][0] - onesInRow)**2
        for i in range(0, columnsDim):
            onesInColumn = 0
            for j in getColumn(imageDescription, i):
                onesInColumn = onesInColumn + j
            squareSum += (columnsDescription[i][0] - onesInColumn)**2
        
        return squareSum + len(getBadRows(imageDescription)) + len(getBadColumns(imageDescription))

    def createBetterImage(imageDescription, moveChoice):
        # moveChoice[1] = True - zmiana wiersza wpp kolumny
        unchangedScore = scoreImage(imageDescription)
        maxChangedScore = [imageDescription, unchangedScore]

        if moveChoice[1] == True:
            for i in range(0, columnsDim):
                imageDescriptionCopy = imageDescription
                changed = 0

                if imageDescriptionCopy[moveChoice[0]][i] == 0:
                    imageDescriptionCopy[moveChoice[0]][i] = 1
                else:
                    imageDescriptionCopy[moveChoice[0]][i] = 0
                    changed = 1
                
                changedScore = scoreImage(imageDescriptionCopy)

                if changedScore <= maxChangedScore[1]:
                    maxChangedScore = [myCopy(imageDescriptionCopy), changedScore]
                
                imageDescriptionCopy[moveChoice[0]][i] = changed

            if maxChangedScore[1] >= unchangedScore:
                return -1
            return maxChangedScore[0]
        else:
            for i in range(0, rowsDim):   
                imageDescriptionCopy = imageDescription
                changed = 0
                if imageDescriptionCopy[i][moveChoice[0]] == 0:
                    imageDescriptionCopy[i][moveChoice[0]] = 1
                else:
                    imageDescriptionCopy[i][moveChoice[0]] = 0
                    changed = 1

                changedScore = scoreImage(imageDescriptionCopy)

                if changedScore <= maxChangedScore[1]:
                    maxChangedScore = [myCopy(imageDescriptionCopy), changedScore]

                imageDescriptionCopy[i][moveChoice[0]] = changed
            
            if maxChangedScore[1] >= unchangedScore:
                return -1
            return maxChangedScore[0]

    def isGoodImage(imageDescription):
        for i in range(rowsDim):
            row = getRow(imageDescription, i)
            row = map(str, row)
            groupsInRow = findGroups(''.join(row))
            
            if len(groupsInRow) != 1 or (len(groupsInRow[0]) != rowsDescription[i][0]):
                return False

        for i in range(columnsDim):
            column = getColumn(imageDescription, i)
            column = map(str, column)
            groupsInColumn = findGroups(''.join(column))
            
            if len(groupsInColumn) != 1 or (len(groupsInColumn[0]) != columnsDescription[i][0]):
                return False
        return True
    
    def solveImage(imageDescription):
        isFinished = isGoodImage(imageDescription)
        iterationsWithoutEffect = 0

        while not isFinished:
            if iterationsWithoutEffect > 10:
                imageDescription = generateImageDescription()
                iterationsWithoutEffect = 0
            
            badRows = getBadRows(imageDescription)
            badColumns = getBadColumns(imageDescription)
            moveChoice = []

            if badRows == []:
                moveChoice = [[random.choice(badColumns), False]]
            elif badColumns == []:
                moveChoice = [[random.choice(badRows), True]]
            else:
                moveChoice = [[random.choice(badRows), True], [random.choice(badColumns), False]]
            
            moveChoice = random.choice(moveChoice)
            betterImage = createBetterImage(imageDescription, moveChoice)
            
            if betterImage == -1:
                iterationsWithoutEffect = iterationsWithoutEffect+1
            else:
                imageDescription = betterImage
                iterationsWithoutEffect = 0

            isFinished = isGoodImage(imageDescription)
        draw(imageDescription, file=file)

    imageDescription = generateImageDescription()
    solveImage(imageDescription)

inFile = open('zad5_input.txt', 'r')
outFile = open('zad5_output.txt', 'w')

descLine = inFile.readline().split()
rws, cols = int(descLine[0]), int(descLine[1])

index = 0
for i in inFile:
    line = i.split()
    if index >= rws:
        columns.append([int(line[0])])
    else:
        rows.append([int(line[0])])
    index+=1
opt_elem(rows,columns, outFile)
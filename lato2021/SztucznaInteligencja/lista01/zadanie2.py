def wordBreak(start, dict, str, lookup, maxStr, prev):
    wordLength = len(str)
    
    if wordLength == 0:
        return
        
    if lookup[start+len(str)][2] <= maxStr:
        lookup[start+len(str)] = [prev, True, maxStr]
    
    for i in range(1, wordLength+1):
        prefix = str[:i]
        
        if prefix in dict:
            if lookup[i+start][2] >= maxStr+(len(prefix)**2):
                continue
            else:
                lookup[i+start] = [prev + ' ' + prefix, True, maxStr+(len(prefix)**2)]
                wordBreak(start+i, dict, str[i:], lookup, maxStr+(len(prefix)**2), prev + ' ' + prefix)
            
dict = open('words_for_ai1.txt', 'r')
dictSet = set()
for i in dict:
    dictSet.add(i.strip())
text = open('zad2_input.txt', 'r')
output = open('zad2_output.txt', 'w')
for i in text:
    max = ['', 0]
    lookup = [['', True, 0]]
    lookup.extend([['', False, -1]]*(len(i)))
    wordBreak(0, dictSet, i, lookup, 0, '')
    for j in range(0, len(lookup)):
        if lookup[j][2] >= max[1]:
            max = lookup[j]
    print(max[0], file=output)
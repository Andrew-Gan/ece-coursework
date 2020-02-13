import re

#Match phone numbers. Return True or False. See README for details.
def problem1(searchstring) :
    #fill in
    patt = re.compile('\(\d{3}\) \d{3}-\d{4}|\d{3}-\d{3}-\d{4}|\d{3}-\d{4}')
    return bool(patt.fullmatch(searchstring))

def problem2(searchstring) :
    #fill in
    patt = re.compile('\d+ ([A-Z][a-z]* )+(Rd.|Dr.|Ave.|St.)')
    temp = patt.search(searchstring).group(0)
    patt = re.compile('([A-Z][a-z]* )+')
    res = patt.search(temp).group(0)
    res = res.strip()
    return res
    
#Garble street name. See README for details
def problem3(searchstring) :
    #fill in
    res = problem2(searchstring)
    flipped_street = res[::-1]
    newString = searchstring.replace(res, flipped_street)
    return newString
        
if __name__ == '__main__' :
    print(problem1('765-494-4600')) #True
    print(problem1(' 765-494-4600 ')) #False
    print(problem1('(765) 494 4600')) #False
    print(problem1('(765) 494-4600')) #True    
    print(problem1('494-4600')) #True
    
    print(problem2('The EE building is at 465 Northwestern Ave.')) #Northwestern
    print(problem2('Meet me at 201 South First St. at noon')) #South First
    
    print(problem3('The EE building is at 465 Northwestern Ave.'))
    print(problem3('Meet me at 201 South First St. at noon'))
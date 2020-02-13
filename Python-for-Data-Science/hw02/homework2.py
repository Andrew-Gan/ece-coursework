def histogram(data, n, l, h):
    hist = [0] * n								# initialize array of zeros
    w = (h - l) / n								# compute data range per histogram group
    for k in data:
        i = 0
        while(i < n):
            if(k >= (l + w * i) and k < (l + w * (i + 1))):			# check if value within range of histogram group
                hist[i] = hist[i] + 1						# increment histogram count by 1
                i = n
            else:
                i = i + 1							# check for next histogram group
    return(hist)

def addressbook(name_to_phone, name_to_address):
    address_to_all = {}								# initialize empty dictionary
    dictName = name_to_address.keys()
    for name in dictName:
        if(name_to_address[name] in address_to_all):				# add to name list if address found in address_to_all
            nameField = address_to_all[name_to_address[name]][0]
            nameField.append(name)
            phone_nameToPhoneDict = name_to_phone[name]
            phone_addrToAllDict = address_to_all[name_to_address[name]][1]
            if(phone_nameToPhoneDict != phone_addrToAllDict):			# print warning msg if same address contains different phone number
                firstNameOfAddr = address_to_all[name_to_address[name]][0][0]
                print('Warning: {} has a different number for {} than {}. Using the number for {}.' .format(name, name_to_address[name], firstNameOfAddr, firstNameOfAddr))
        else:									# create new key and value if address not found in address_to_all
            address_to_all.update({name_to_address[name]:([name], name_to_phone[name])})
    return(address_to_all)

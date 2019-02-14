import spacy
import difflib


def mainNLP(raw_text,parameterNames):
    nlp = spacy.load('en_core_web_sm')
    doc = nlp(raw_text)
    sentences = [sent.string.strip() for sent in doc.sents]
    parameters = []
    for text in sentences:
        doc = nlp(text)
        parameters.append(detectParameter(doc,parameterNames))
    i = 0
    finalList = []
    while i < len(sentences):
        j = 0
        while j< len(parameters[i]):
            finalList.append(parameters[i][j])
            j += 1
        i += 1
    return finalList

# Detect if there are numbers in a sentence
def detectNumber(doc):
    numberFlag = False
    for token in doc:
        if token.pos_ == "NUM":
            numberFlag = True
    return numberFlag

# Detect numbers in a sentence:
def findValueNumerical(doc):
    values = []
    for ent in doc.ents:
        if ent.label_ == "QUANTITY":
            value = ent.text
            for token in ent:
                if token.pos_ == "NUM":
                    values.append(token.text)
        elif ent.label_ == "CARDINAL":
            value = ent.text
        elif ent.label_ == "DATE":
            value = ent.text
            for token in ent:
                if token.pos_ == "NUM":
                    values.append(token.text)
    return values

# Detect VALUE for attributes that are not numerical (EX: Orbit Type: LEO)
def findValueNonNumerical(doc):
    values = []
    for token in doc:
        if token.dep_ == "attr" or token.dep_ == "acomp" or token.dep_=="nummod":
            values.append(token.text)
    return values

# Detect the name of the parameter in a sentence [ATTRIBUTE_DESCRIPTOR + of + ATTRIBUTE is VALUE]:
def findAttributeOfIs(doc):
    mainName = ""
    subject = ""
    for token in doc:
        if token.dep_ == "nsubj":
            subject = token.text
            adj = ""
            for child in token.children:
                if child.pos_ == "ADJ" or child.pos_ == "NOUN":
                    adj = child.text
        elif token.dep_ == "pobj":
            adj2 = ""
            for child in token.children:
                if child.pos_ == "ADJ":
                    adj2 = child.text
            mainName =  token.text
    parameter = adj2 + ' ' + mainName + ' '+ adj + ' ' + subject
    return parameter

# Detect the name of the parameter in a sentence [ATTRIBUTE_DESCRIPTOR + has a + ATTRIBUTE of VALUE]:
def findAttributeHas(doc):
    mainName = ""
    subject = ""
    for token in doc:
        if token.dep_ == "nsubj":
            subject = token.text
            adj = ""
            for child in token.children:
                if child.pos_ == "ADJ" or child.pos_ == "NOUN":
                    adj = child.text
        elif token.dep_ == "dobj":
            adj2 = ""
            for child in token.children:
                if child.pos_ == "ADJ":
                    adj2 = child.text
            mainName =  token.text
    parameter = adj + ' ' + subject + ' '+ adj2 + ' ' + mainName
    return parameter

# Detect the name of the parameter in a sentence [ATTRIBUTE is VALUE]
def findAttributeIs(doc):
    mainName = ""
    subject = ""
    adj = ""
    for token in doc:
        if token.dep_ == "nsubj":
            subject = token.text
            adj2 = ""
            for child in token.children:
                if (child.pos_ == "ADJ" or child.pos_ == "NOUN")  and adj == "":
                    adj = child.text
                elif (child.pos_ == "ADJ" or child.pos_ == "NOUN") and adj2 == "":
                    adj2 = child.text
    parameter = adj + ' ' + adj2 + ' ' + subject
    return parameter

# Detect the type of syntax in the sentence
def detectSyntax(doc):
    ofWord = False
    appos = False
    for token in doc:
        if token.pos_ == "VERB":
            if token.lemma_ == "have":
                Syntax = "Has"
            elif token.lemma_ == "be":
                Syntax = "Is"
        elif token.lemma_ == "of":
            ofWord = True
        elif token.dep_ == "conj" and Syntax != "conjunction3":
            Syntax = "conjunction"
            for child in token.children:
                if child.dep_ == "conj":
                    Syntax = "conjunction3"
        elif token.dep_ == "appos":
            appos = True

    if Syntax == "Is" and ofWord == True:
        Syntax = "IsOf"
        return Syntax
    elif Syntax == "conjunction" and appos == True:
        Syntax = "conjunction3"
        return Syntax
    else:
        return Syntax

# Detect the name of the parameter in a sentence [ATTRIBUTE_DESCRIPTOR + has a + ATTRIBUTE of VALUE, a ATTRIBUTE2 OF VALUE2
# AND ATTRIBUTE3 of VALUE3]:
def findConjunction3(doc):
    mainName = ""
    subject = ""
    secondElement = ""
    thirdElement = ""
    for token in doc:
        if token.dep_ == "nsubj":
            subject = token.text
            adj = ""
            for child in token.children:
                if child.pos_ == "ADJ" or child.pos_ == "NOUN":
                    adj = child.text
        elif token.dep_ == "dobj":
            adj2 = ""
            for child in token.children:
                if child.pos_ == "ADJ" and child.dep_ != "appos":
                    adj2 = child.text
            mainName =  token.text
        elif (token.dep_ == "appos" or token.dep_ == "conj") and secondElement == "":
            adj3 = ""
            for child in token.children:
                if (child.pos_ == "ADJ" or child.pos_ == "NOUN")  and child.dep_ != "conj":
                    adj3 = child.text
            secondElement =  token.text
        elif token.dep_ == "conj":
            adj4 = ""
            for child in token.children:
                if child.pos_ == "ADJ" or child.pos_ == "NOUN":
                    adj4 = child.text
            thirdElement =  token.text


    parameter1 = adj + ' ' + subject + ' '+ adj2 + ' ' + mainName
    parameter2 =  adj3 + ' ' + secondElement
    parameter3 =  adj4 + ' ' + thirdElement
    parametersList = [parameter1,parameter2,parameter3]
    return parametersList

# Detect the name of the parameter in a sentence [ATTRIBUTE_DESCRIPTOR + has a + ATTRIBUTE of VALUE, a ATTRIBUTE2 OF VALUE2
# AND ATTRIBUTE3 of VALUE3]:
def findConjunction(doc):
    mainName = ""
    subject = ""
    secondElement = ""
    thirdElement = ""
    for token in doc:
        if token.dep_ == "nsubj":
            subject = token.text
            adj = ""
            for child in token.children:
                if child.pos_ == "ADJ" or child.pos_ == "NOUN":
                    adj = child.text
        elif token.dep_ == "dobj":
            adj2 = ""
            for child in token.children:
                if child.pos_ == "ADJ" and child.dep_ != "conj":
                    adj2 = child.text
            mainName =  token.text
        elif token.dep_ == "conj":
            adj4 = ""
            for child in token.children:
                if child.pos_ == "ADJ" or child.pos_ == "NOUN":
                    adj4 = child.text
            thirdElement =  token.text

    parameter1 = adj + ' ' + subject + ' '+ adj2 + ' ' + mainName
    parameter2 =  adj4 + ' ' + thirdElement
    parametersList = [parameter1,parameter2]
    return parametersList

def detectParameter(doc,parameterNames):
    
    #Detect the type of sentence
    typeOfSentence = detectSyntax(doc)
    if typeOfSentence == "IsOf":
        parameter = findAttributeOfIs(doc)
    elif typeOfSentence == "Is":
        parameter = findAttributeIs(doc)
    elif typeOfSentence == "Has":
        parameter = findAttributeHas(doc)
    elif typeOfSentence == "conjunction":
        parametersList = findConjunction(doc)
    else: 
        parametersList = findConjunction3(doc)
    #print(typeOfSentence)

    parameters = []
    pair = [] 
    if typeOfSentence == "IsOf" or typeOfSentence == "Is" or typeOfSentence == "Has":
        try:
            value = findValueNonNumerical(doc)[0]
            EntityName = difflib.get_close_matches(parameter, parameterNames)[0]
            pair.append(EntityName)
            pair.append(value)
            parameters.append(pair)
            return parameters
        except IndexError:
            return parameters
    else:
        #If there is a conjunction of sentences in one sentence
        readValues = findValueNonNumerical(doc)
        #print(readValues)
        i = 0
        #print(parametersList)
        parameters = []
        for param in parametersList:
            pair = [] 
            try:
                if param == "wet mass":
                    param = "satellite " + param
                EntityName = difflib.get_close_matches(param, parameterNames)[0]
                value = readValues[i]
                pair.append(EntityName)
                pair.append(value)
                parameters.append(pair)
                i += 1
            except IndexError:
                i += 1
        return parameters

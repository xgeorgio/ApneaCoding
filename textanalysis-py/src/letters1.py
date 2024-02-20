txt="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
letters={}

def main():
    for i in range(len(txt)):
        if txt[i] not in letters.keys():
            letters[txt[i]]=0
        
        letters[txt[i]] += 1

    print(letters)

if __name__ == "__main__":
    main()
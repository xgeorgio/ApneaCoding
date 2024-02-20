import sys

def main( filenames ):
    letters={}
    for fidx in range(1,len(filenames)):
        fname=filenames[fidx]
        print('Processing file "%s"' % fname)
        try:
            with open(fname,'r') as f:
                lines = f.readlines()

                for txt in lines:
                    for i in range(len(txt)):
                        if txt[i] not in letters.keys():
                            letters[txt[i]]=0
                
                        letters[txt[i]] += 1
        except:
            print('Error: Unable to process file "%s"' % fname)

    print(letters)

if __name__ == "__main__":
    if len(sys.argv)>1:
        main(sys.argv)
    else:
        print('Error: No input file')
    
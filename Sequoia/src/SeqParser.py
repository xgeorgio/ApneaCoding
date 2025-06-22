from sly import Lexer, Parser
from datetime import datetime
import re
from SeqOpcode import SeqOpcode
from SeqLexer import SeqLexer


class SeqParser(Parser):
    'class: syntax analyzer/parser'

    debugfile = 'seqparser.out'     # export rules/states, used for debugging only
    tokens = SeqLexer.tokens        # get valid tokens from lexer

    # precedence = (
    #     ('left', PLUS, MINUS),
    #     ('left', TIMES, DIVIDE),
    #     ('right', UMINUS),
    #     )

    # define keywords in identifiers, treat as case-insensitive in grammar
    keywords = ('QUIT', 'RESET', 'CLEAR', 'LIST', 'CONNECT', 'USE', 'RETURN')

    def __init__(self):
        'default constructor'
        self.reset()           # reset all internal state/counters
        #print('interactive: ',self.interactive,' , verbose: ',self.verbose)
        self.oplist_clear()    # clear current opcode listing

    def reset(self, interactive=True, verbose=True):
        'reset parser status, including identifiers and opcodes'
        #self.names = { '$ans': None }   # dictionary for identifiers ($ans = reserved for latest result)
        self.clear_vars()
        self.oplist_clear()

        self.stmtno=0                   # statements counter

        self.hasErrors=False            # flag for parsing errors
        self.hasInput=False             # flag for defined input (yes/no)
        self.hasOutput=False            # flag for defined output (yes/no)
        self.verbose=verbose            # flag for verbose messages
        self.interactive=interactive    # flag for interactive/compile mode
        if (self.interactive):          # set appropriate 'mode' string
            self.mode='interactive'
        else:
            self.mode='compiler'

    def clear_vars(self):
        'clear all identifiers only (opcodes unchanged)'
        self.names = { '$ans': None }   # dictionary for identifiers ($ans = reserved for latest result)

    def list_vars(self):
        'display currently declared identifiers (vars)'
        for (k, v) in self.names.items():
            # keep loop regardless of verbose, for other processing
            if (self.verbose):
                print('\'%s\'\t:  %s' % (k, type(v)))       # display identifier name and type (not value)

    def oplist_clear(self):
        'clear all opcode data (reset)'
        self.oplist = {         # main opcode listing, updated during parsing
            'meta'   : {            # oplist: metadata section
                'name' : None,
                'version' : SeqOpcode.version,
                'mode'    : None,
                'author'  : None,
                'copyright' : None,
                'timestamp' : None,

            },
            'input'  : {            # oplist: input section
                #'dbname'  : None,
                #'dbtype'  : None,

            },
            'steps'  : {            # oplist: pipeline section

            },
            'output' : {            # oplist: output section
                #'return'  : None,

            },
        }

    def oplist_meta(self, name, author, copyright):
        'define metadata section'
        self.oplist['meta']['name'] = name
        self.oplist['meta']['author'] = author
        self.oplist['meta']['copyright'] = copyright
        self.oplist['meta']['version'] = SeqOpcode.version
        self.oplist['meta']['mode'] = self.mode
        self.oplist['meta']['timestamp'] = str(datetime.now())

    def oplist_validate(self):
        'validate pipeline definition'
        if (not (self.hasInput and ('dbname' in self.oplist['input']))):
            print('Error: No \'USE\' or \'CONNECT\' input defined')
            self.hasErrors=True

        if (not (self.hasOutput and ('return' in self.oplist['output']))):
            print('Error: No \'RETURN\' output defined')
            self.hasErrors=True

        return (self.hasErrors)

    def cap_keywords(self, inptext):
        'capitalize keywords for case-insensitive matching in rules'
        for kw in self.keywords:        # convert all keywords to upper case
            re_exp = re.compile(kw, re.IGNORECASE)
            inptext = re_exp.sub(kw, inptext)
        return(inptext)

    def done(self, errcode=0):
        'gracefully finish parsing process and exit'
        if (self.verbose):
            print('Finished parsing %d statements:' % len(self.oplist['steps']))
            print('Identifiers: ',self.names)
            print('oplist:\n',self.oplist)
            if (self.hasErrors):
                print('Exiting with errors (code=%d)' % errcode)
            else:
                print('No errors found in input')

        if (self.hasErrors and errcode != 0):    # should also catch Lexer errors
            exit(errcode)
        elif (self.hasErrors):     # exit with errors, no code given
            exit(1)
        else:                      # no errors (errcode ignored)
            exit(0)        

    @_('QUIT')          # Rule:  'QUIT'
    def statement(self, p):
        #self.stmtno += 1       # do not count 'quit' as statement (interactive mode)
        self.oplist_validate()
        self.done()

    @_('RESET')          # Rule:  'RESET'
    def statement(self, p):
        #self.stmtno += 1       # do not count 'quit' as statement (interactive mode)
        self.reset()
        if (self.verbose):
            print('Parser reset: OK')

    @_('CLEAR')          # Rule:  'CLEAR'
    def statement(self, p):
        #self.stmtno += 1       # do not count 'quit' as statement (interactive mode)
        self.clear_vars()
        if (self.verbose):
            print('Parser clear vars: OK')

    @_('LIST')          # Rule:  'LIST'
    def statement(self, p):
        #self.stmtno += 1       # do not count 'quit' as statement (interactive mode)
        self.list_vars()
        if (self.verbose):
            print('Parser list vars: OK')

    @_('USE IDENT')     # Rule:  'USE <filename>'
    def statement(self, p):
        # if (p.IDENT not in self.names):
        #     print(f'Error (line %d): \'USE\' with undefined identifier {p.IDENT!r}' % p.lineno)
        # elif ('$dbname' in self.names):
        # elif (self.hasInput):
        if (self.hasInput):
            print(f'Error (line %d): Input already defined as {p.IDENT!r}' % p.lineno)
        else:
            self.names['$dbname'] = p.IDENT                         # update identifiers dictionary (special $)
            self.stmtno += 1      # count as valid statement (in oplist)
            self.oplist['input']['dbname'] = self.names['$dbname']          # update oplist (input filename)
            self.oplist['input']['dbtype'] = 'csv/text'                     # update oplist (input type)
            #self.oplist['steps'][self.stmtno] = SeqOpcode.opcodes['USE']    # insert new pipeline step (opcode)
            #self.oplist['steps'][self.stmtno] = (SeqOpcode.opcodes['USE'], self.names['$dbname'])  # opcode content
            self.hasInput=True
            if (self.verbose):
                print('%s: \'%s\'' % (SeqOpcode.opcodes['USE'], self.names['$dbname']))

    @_('CONNECT IDENT')     # Rule:  'USE <filename>'
    def statement(self, p):
        # if (p.IDENT not in self.names):
        #     print(f'Error (line %d): \'CONNECT\' with undefined identifier {p.IDENT!r}' % p.lineno)
        # elif ('$dbname' in self.names):
        # elif (self.hasInput):
        if (self.hasInput):
            print(f'Error (line %d): Input already defined as {p.IDENT!r}' % p.lineno)
        else:
            self.names['$dbname'] = p.IDENT                         # update identifiers dictionary (special $)            
            self.stmtno += 1      # count as valid statement (in oplist)
            self.oplist['input']['dbname'] = self.names['$dbname']          # update oplist (input filename)
            self.oplist['input']['dbtype'] = 'db/binary'                    # update oplist (input type)
            #self.oplist['steps'][self.stmtno] = SeqOpcode.opcodes['CONNECT']    # insert new pipeline step (opcode)
            #self.oplist['steps'][self.stmtno] = (SeqOpcode.opcodes['CONNECT'], self.names['$dbname'])  # opcode content
            self.hasInput=True
            if (self.verbose):
                print('%s: \'%s\'' % (SeqOpcode.opcodes['CONNECT'], self.names['$dbname']))

    @_('RETURN IDENT')     # Rule:  'RETURN <identifier>'
    def statement(self, p):
        if (p.IDENT not in self.names):
            print(f'Error (line %d): \'RETURN\' with undefined identifier {p.IDENT!r}' % p.lineno)
        #elif ('$return' in self.names):
        elif (self.hasOutput):
            print(f'Error (line %d): \'RETURN\' already defined as {p.IDENT!r}' % p.lineno)
        else:
            self.names['$return'] = p.IDENT                         # set output identifiers from dictionary (special $)                    
            self.stmtno += 1      # count as valid statement (in oplist)
            self.oplist['output']['return'] = self.names['$return']          # update oplist (input)
            #self.oplist['steps'][self.stmtno] = SeqOpcode.opcodes['RETURN']    # insert new pipeline step (opcode)
            #self.oplist['steps'][self.stmtno] = (SeqOpcode.opcodes['RETURN'], self.names['$return'])  # opcode content
            self.hasOutput=True
            if (self.verbose):
                print('return: \'%s\'' % self.names['$return'])

    # @_('USE error')
    # def statement(self, p):
    #     line   = p.lineno       # line number of the recognized token
    #     index  = p.index        # Index of the recognized token in input text
    #     print('error in USE: \'%s\'' % p.error)
    #     print('(lineno %d, index %d)' % (line, index))

    @_('IDENT ASSIGN expr')     # Rule:  '<identifier> = <expression>|<identifier>'
    def statement(self, p):
        self.names[p.IDENT] = p.expr        # update identifiers dictionary (new) and set value
        #self.names['$ans']=p.expr           # update latest-result identifier (auto)
        self.stmtno += 1      # count as valid statement (in oplist)
        self.oplist['steps'][self.stmtno] = SeqOpcode.opcodes['ASSIGN']    # insert new pipeline step (opcode)
        self.oplist['steps'][self.stmtno] = (SeqOpcode.opcodes['ASSIGN'], p.IDENT, self.names[p.IDENT])  # opcode content
        # Note: on invalid <expr> the p.expr value becomes 'None', i.e. means 'unset <identifier>'
        if (self.verbose):
            print('set: \'%s\' = %s' % (p.IDENT,self.names[p.IDENT]))
            #print('(auto): $ans = %s' % self.names['$ans'])
            
    @_('expr')      # Rule:  '<expression>|<identifier>' (print current value)
    def statement(self, p):                
        if (p.expr != None):
            print(p.expr)       # useful only in interactive mode (no oplist update)
        #self.names['$ans']=p.expr
        #if (self.verbose):
        #    print('(auto): $ans = %s' % self.names['$ans'])


    @_('LPAREN expr RPAREN')    # Rule:  '( <expression>|<identifier> )'
    def expr(self, p):
        return (p.expr)         # useful only in interactive mode (no oplist update)

    @_('FLOAT')         # Rule:  '<expression> as float'
    def expr(self, p):
        return float(p.FLOAT)    # already checked by the lexer, convert to value

    @_('INT')           # Rule:  '<expression> as integer'
    def expr(self, p):
        return int(p.INT)        # already checked by the lexer, convert to value

    # @_('NUMBER')
    # def expr(self, p):
    #     return int(p.NUMBER)

    @_('IDENT')      # Rule:  <expression>|<identifier>
    def expr(self, p):
        #try:
        if (p.IDENT in self.names.keys()):
            self.stmtno += 1                # useful only in interactive mode (no oplist update) 
            return (self.names[p.IDENT])    # valid identifier, return value
        #except LookupError:
        else:
            print(f'Error (line %d): Undefined identifier {p.IDENT!r}' % p.lineno)
            self.hasErrors=True
            self.stmtno += 1
            #return 0

    def error(self, p):
        if (p==None):     # default error for incomplete rule matching
            print('Error: Invalid or incomplete statement %d' % self.stmtno)
        elif ((p.type=='INT') or (p.type=='FLOAT')):
            print('Error (line %d): Invalid number expression' % p.lineno)
        elif (p.type=='IDENT'):     # Note: keywords already catched by lexer/tokenizer
            print('Error (line=%d): Invalid identifier \'%s\'' % (p.lineno, p.value))
        else:             # default error for any other case
            #print('Error: ',p)    # should be catched earlier
            print('Error (line=%d): Invalid use of \'%s\'' % (p.lineno, p.value))

        self.hasErrors=True
        self.stmtno += 1            # count errors as statements


# MAIN: stand-alone mode, used for unit testing only
if __name__ == '__main__':
    lexer = SeqLexer()
    parser = SeqParser()

    #print('same-line statement separator: ',SeqOpcode.stmtsepar)
    parser.interactive=True
    parser.oplist_meta('SeqParser','Harris Georgiou','CC-BY-SA (c) 2020')
    
    while (True):
        try:
            text = input('seqp > ')
            text = re.sub(SeqOpcode.stmtsepar,'\n',text)    # replace ';' with newline characters
            #print('input: ',text)
            for stmt in text.splitlines(True):              # split lines, input separately to parser
                #print('\tstmt: ',stmt)
                parser.parse( lexer.tokenize( parser.cap_keywords(stmt) ) )    # parse line, update internally
        except EOFError:
            break     # Ctrl+Z exits

        # if text:
        #     parser.parse( lexer.tokenize( parser.cap_keywords(text) ) )


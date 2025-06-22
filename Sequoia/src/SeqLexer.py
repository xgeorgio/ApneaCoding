from sly import Lexer
import re
from SeqOpcode import SeqOpcode


class SeqLexer(Lexer):
    'class: lexical analyzer/tokenizer'
    
    tokens = { IDENT, FLOAT, INT, ASSIGN, LPAREN, RPAREN, QUIT, RESET, CLEAR, LIST, CONNECT, USE, RETURN }#, SEMICOL }
    ignore = ' \t'     # skip by default

    # Tokens
    IDENT = r'[a-zA-Z_][.a-zA-Z0-9_]*'      # valid identifiers and keywords
    #NUMBER = r'\d+'
    #FLOAT = r'/^(?!0\d)\d*(\.\d+)?$/mg'
    FLOAT = r'[-]*\d+[.]\d+'                # signed decimal numbers (preceeding)
    INT = r'[-]*\d+'                        # signed integers (after floats)

    # Special symbols
    ASSIGN  = r'='
    LPAREN  = r'\('
    RPAREN  = r'\)'
    #SEMICOL = r';'         # default statement end, if multiples on the same text line

    # literals (chars)
    literals = { SeqOpcode.stmtsepar }

    # Ignored patterns
    ignore_newline = r'\n+'        # skip all newlines
    ignore_comment = r'\#.*'       # skip single-line comments

    # Special cases
    IDENT['QUIT']    = QUIT          # default exit (interactive mode)
    IDENT['RESET']   = RESET         # default reset (interactive mode)
    IDENT['CLEAR']   = CLEAR         # default clear (interactive mode)
    IDENT['LIST']    = LIST         # default clear (interactive mode)
    IDENT['CONNECT'] = CONNECT       # connect to DB file/url
    IDENT['USE']     = USE           # import from local file (.csv)
    IDENT['RETURN']  = RETURN        # pipeline output (identifier)


    def __init__(self):
        'default constructor'
        self.reset()    # reset all internal state/counters
        #print('interactive: ',self.interactive,' , verbose: ',self.verbose)

    def reset(self, interactive=True, verbose=True):
        'reset lexer status'
        self.hasErrors=False
        self.verbose=verbose
        self.interactive=interactive

    # Extra action for newlines (keep track)
    def ignore_newline(self, t):
        'update line count, ignore as token'
        self.lineno += t.value.count('\n')   

    def error(self, t):
        'default error handler for illegal tokens (characters)'
        print('Error (line %d): Illegal character %r' % (self.lineno, t.value[0]))
        self.index += 1     # skip current position, continue with input
        self.hasErrors=True


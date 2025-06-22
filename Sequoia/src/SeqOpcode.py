# no imports necessary


class SeqOpcode():
    'class for defining low-level opcodes for compiler-oriented output'

    version = '0.0.1'       # core engine/opcodes version

    opcodes = {
        'NOTHING' : 'NOP',
        'USE'     : 'USE',
        'CONNECT' : 'CONN',
        'ASSIGN'  : 'SET',
        'RETURN'  : 'RET'
    }

    stmtsepar = ';'

    def __init__(self):
        pass


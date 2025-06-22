import configparser, logging, logging.handlers, argparse, os
import app_info

class AppServices():

    def __init__(self, app_name='<ApplicationName>', app_version='<0.0.0>', app_copyright='<copyright>', 
                 app_config='<default_cfg_filename>'):
        self.app_name=app_name
        self.app_version=app_version
        self.app_copyright=app_copyright
        self.app_config=app_config


    def get_sys_info(self):
        return (app_info.get_sys_info())


    def get_app_info(self):
        # retrieve application and system info, return as string
        return (app_info.get_app_info( self.app_name, self.app_version, self.app_copyright))


    def init_opt(self):
        self.cmdopt = argparse.ArgumentParser(description=self.app_name+' core functionality.')
        # options '-h' and '--help' are implemented implicitly
        self.cmdopt.add_argument('--version', action='version', version='%(prog)s '+self.app_version)
        self.cmdopt.add_argument('-v', '--verbose', action='store_true', dest='verbose',
                           default=True, help='enable verbose mode, detailed logging is enabled')
        self.cmdopt.add_argument('-q', '--quiet', action='store_true', dest='quiet',
                           default=True, help='enable quiet mode, no output is printed')
        self.cmdopt.add_argument('-c', '--config', action='store', dest='cfgfile',
                          default=self.app_config, help=('configuration file (default=\'%s\')' % self.app_config))
        args = self.cmdopt.parse_args()
        self.opt = vars(args)


    def init_cfg(self, fname=None):
        if (fname != None):
            cfg_filename = fname     # use the given filename if not null
        else:
            cfg_filename = self.opt['config']    # get from command-line options
        # open configuration file for all application parameters
        self.cfg = configparser.ConfigParser()
        self.cfg.read_file(open(cfg_filename))      # read configuration from file


    def init_log_timeR(self, fname, loglevel, logwhen, loginterval, logcycle):
        # initialize logger with time-based rotation
        self.log = logging.getLogger(__name__)      # use module name as logger id
        self.log.setLevel(loglevel)                 # set logging level (from string)
        fh = logging.handlers.TimedRotatingFileHandler(fname, when=logwhen, interval=int(loginterval), backupCount=int(logcycle))
        fmt = logging.Formatter('%(asctime)s; %(levelname)s; %(message)s')    # set default logging format
        fh.setLevel(loglevel)
        fh.setFormatter(fmt)
        self.log.addHandler(fh)


    def init_log_sizeR(self, fname, loglevel, loglimit, logcycle):
        # initialize logger with size-based rotation
        self.log = logging.getLogger(__name__)      # use module name as logger id
        self.log.setLevel(loglevel)                 # set logging level (from string)
        fh = logging.handlers.RotatingFileHandler(fname, maxBytes=int(loglimit), backupCount=int(logcycle))
        #fh = logging.handlers.TimedRotatingFileHandler(fname, when='m', interval=1, backupCount=3)
        fmt = logging.Formatter('%(asctime)s; %(levelname)s; %(message)s')    # set default logging format
        fh.setLevel(loglevel)
        fh.setFormatter(fmt)
        self.log.addHandler(fh)


# MAIN: stand-alone mode, used for unit testing only
if __name__ == '__main__':
    #app = AppServices()
    app = AppServices(app_name='SEQUOIA Engine', app_version='0.0.1 (beta)', 
                      app_copyright='Harris Georgiou (c) 2020, Licence: CC-BY-SA/4.0i',
                      app_config='settings.cfg')

    # test command-line options
    app.init_opt()

    # print full intro if not in 'help' or 'version' options
    print(app.get_app_info(),'\n')        # application details retrieved from external configuration
    print(app.get_sys_info(),'\n\n')    

    # test configuration
    app.init_cfg(app.opt['cfgfile'])     # static argument (app-specific), everything else is in there
    print('configuration: ', app.opt['cfgfile'])

    # test logging
    #   size-based rotation:
    app.init_log_sizeR(app.cfg['logging']['filename'], app.cfg['logging']['level'], app.cfg['logging']['maxBytes'], app.cfg['logging']['backupCount'])
    #   time-based rotation:
    #app.init_log_timeR(app.cfg['logging']['filename'], app.cfg['logging']['level'], app.cfg['logging']['when'], app.cfg['logging']['interval'], app.cfg['logging']['backupCount'])
    app.log.debug('another test message for log')
    print('logging level: ', app.log.getEffectiveLevel())

    

# use only standard modules for cross-platform portability
import os, platform

def get_sys_info():
    arch=platform.architecture()
    res = 'CPU type: %s / CPU count: %s / CPU class: %s\n' % (platform.machine(), os.cpu_count(), platform.processor())
    res += 'OS platform: %s-%s-%s / OS version: %s\n' % (arch[0], str(os.name).upper(), arch[1], platform.platform())
    res += 'Python version: %s (%s) / Python build: %s' % (platform.python_version(), platform.python_implementation(), platform.python_compiler())
    return(res)


def get_app_info(str_appname, str_appversion, str_appcopyright):
    res = '%s, version %s\n%s' % (str_appname, str_appversion, str_appcopyright)
    return(res)


if __name__ == "__main__":
    print(get_app_info('PyTest example','0.1 (beta)','Copyright (c) <author> 2020, Licence: CC-BY-SA/4.0i'))
    print(get_sys_info())

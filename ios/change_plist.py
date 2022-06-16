from biplist import *
import argparse
import os

def main(file):
    plist = readPlist (file)
    #print (plist)
    #dict_list = plist['dict']
    dir_path = os.path.split(os.path.realpath(__file__))[0]
    MARKETING_VERSION = ''
    CURRENT_PROJECT_VERSION = ''
    lines = readfilelines(dir_path + '/app/app.xcodeproj/project.pbxproj')
    for line in lines:
        if 'MARKETING_VERSION' in line:
            if MARKETING_VERSION != line.replace(';', ''):
                MARKETING_VERSION = line.replace(';', '')
                MARKETING_VERSION = MARKETING_VERSION.split()[-1]
        if 'CURRENT_PROJECT_VERSION' in line:
            if CURRENT_PROJECT_VERSION != line.replace(';', ''):
                CURRENT_PROJECT_VERSION = line.replace(';', '')
                CURRENT_PROJECT_VERSION = CURRENT_PROJECT_VERSION.split()[-1]
#    print (MARKETING_VERSION)
#    print (CURRENT_PROJECT_VERSION)
    plist['CFBundleIdentifier'] = 'com.bytedance.iesiccv.tobsdk'
    plist['CFBundleVersion'] = CURRENT_PROJECT_VERSION
    plist['CFBundleShortVersionString'] = MARKETING_VERSION
    writePlist(plist, file)
    pass
    
def readfilelines(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    return lines
    
if __name__ == "__main__":
    parse = argparse.ArgumentParser()
    parse.add_argument('plist', help='source plist')
    args = parse.parse_args()
    main(args.plist)
    pass

